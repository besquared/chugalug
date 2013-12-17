#include <ruby/st.h>
#include <ruby.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#include "csv.h"

struct rowdata {
  VALUE ary;
};

static char termchar;

void fieldcb(void* str, size_t len, void* data) {
  VALUE ary = ((struct rowdata *)data)->ary;
  rb_ary_store(ary, RARRAY_LEN(ary), rb_str_new(str, len));
}

void rowcb(int c, void* data) {
  rb_yield(((struct rowdata *)data)->ary);
  ((struct rowdata *)data)->ary = rb_ary_new();
}

static int is_space(unsigned char c) {
  if (c == CSV_SPACE || c == CSV_TAB) return 1;
  return 0;
}

static int is_term(unsigned char c) {
  if (termchar && c == termchar) return 1;
  if (c == CSV_CR || c == CSV_LF) return 1;
  return 0;
}

int do_print(VALUE key, VALUE val, VALUE in) {
  fprintf(stderr, "Input data is %s\n", StringValueCStr(in));
  fprintf(stderr, "Key %s=>Value %s\n", StringValueCStr(key), StringValueCStr(val));
  return ST_CONTINUE;
}

static VALUE foreach(VALUE self, VALUE args) {
  VALUE filename = rb_ary_shift(args);
  VALUE options = rb_ary_shift(args);
  
  FILE *file = fopen(StringValueCStr(filename), "r");
  
  if (file == NULL) {
    rb_raise(rb_eRuntimeError, "File not found");
  }
  
  char buf[1024];
  size_t bytes_read;
  struct csv_parser p;
  unsigned char csv_options = 0;
  
  struct rowdata data;
  data.ary = rb_ary_new();
  
  if(csv_init(&p, csv_options) != 0) {
    rb_raise(rb_eRuntimeError, "Failed to initialize csv parser");
    exit(EXIT_FAILURE);
  }
  
  csv_set_space_func(&p, is_space);
  csv_set_term_func(&p, is_term);
  
  if(RTEST(options)) {
    VALUE term = rb_hash_aref(options, ID2SYM(rb_intern("row_sep")));
    VALUE delim = rb_hash_aref(options, ID2SYM(rb_intern("col_sep")));
    
    if(RTEST(term)) { termchar = NUM2CHR(term); }
    if(RTEST(delim)) { csv_set_delim(&p, NUM2CHR(delim)); }
  }
  
  while((bytes_read = fread(buf, 1, 1024, file)) > 0) {
    if(csv_parse(&p, buf, bytes_read, fieldcb, rowcb, &data) != bytes_read) {
      rb_raise(rb_eRuntimeError, "Error while parsing file"); //, csv_strerror(csv_error(&p)));
    }
  }
  
  csv_fini(&p, fieldcb, rowcb, &data);
  csv_free(&p);
  
  if(ferror(file)) {
    fclose(file);
    rb_raise(rb_eRuntimeError, "Error while reading file");
  } else {
    fclose(file);
  }
  
  return Qnil;
}

static VALUE rb_cC;
void Init_chugalug() {
  rb_cC = rb_define_class("Chugalug", rb_cObject);
  rb_define_singleton_method(rb_cC, "foreach", foreach, -2);
}
