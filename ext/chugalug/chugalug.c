#include <ruby.h>
#include <ruby/st.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#include "csv.h"

/* String encoding is only available in Ruby 1.9+ */
#ifdef HAVE_RUBY_ENCODING_H

#include <ruby/encoding.h>

#define RB_ENC_FIND_INDEX(encoding) \
  rb_enc_find_index(encoding)

#define ENCODED_STR_NEW(str, length, enc_index)  \
  ({ \
  VALUE _string = rb_str_new(str, length); \
  if (enc_index != -1) { \
    rb_enc_associate_index(_string, enc_index); \
  } \
  _string; \
  })

#else

#define RB_ENC_FIND_INDEX(encoding) \
  ({ \
  rb_raise(rb_eRuntimeError, "Character encodings are unavailable in your ruby version!"); \
  -1; \
  })

#define ENCODED_STR_NEW(str, length, enc_index)  \
  rb_str_new(str, length)

#endif

struct rowdata {
  VALUE ary;
  int encoding;
};

static char termchar;

void fieldcb(void* str, size_t len, void* data) {
  struct rowdata* rdata = (struct rowdata *)data;

  VALUE ary = rdata->ary;
  int encoding = rdata->encoding;

  printf("Encoding index is %i\n", encoding);

  rb_ary_store(ary, RARRAY_LEN(ary), rb_str_new(str, len));
  //rb_ary_store(ary, RARRAY_LEN(ary), ENCODED_STR_NEW(str, len, encoding));
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
  
  /* Specify the character encoding of the input data */

  // if(!RTEST(encoding)) {
  //   encoding = rb_str_new("UTF-8", 5);
  // }

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
    VALUE encoding = rb_hash_aref(options, ID2SYM(rb_intern("encoding")));

    if(RTEST(term)) { termchar = NUM2CHR(term); }
    if(RTEST(delim)) { csv_set_delim(&p, NUM2CHR(delim)); }

    if(RTEST(encoding)) { 
      data.encoding = RB_ENC_FIND_INDEX(StringValueCStr(encoding));
    } else {
      data.encoding = -1;
    }
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

static VALUE mChug, mParser;
void Init_chugalug() {
  mChug = rb_define_module("Chugalug");
  mParser = rb_define_class_under(mChug, "Parser", rb_cObject);

  rb_define_singleton_method(mParser, "foreach", foreach, -2);
}