#include <mcl.h>

MCL_IMPORT(void, User32, MessageBoxA, (int, char*, char*, int));

#include <stdarg.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void log(char* fmt, ...) {
    va_list ap, aq;

    va_start(ap, fmt);
    va_copy(aq, ap);

    int len = vsnprintf(NULL, 0, fmt, ap);

    char* buf = malloc(len + 1);

    vsnprintf(buf, len, fmt, ap);

    va_end(ap);
    va_end(aq);

    MessageBoxA(0, buf, NULL, 0);
}

#define max(a, b) ((a) > (b) ? (a) : (b))
#define min(a, b) ((a) > (b) ? (b) : (a))

#define M_SQRT2 1.41421356237309504880

#include <stdarg.h>

#define PRIx8     "hhx"
#define PRIx16    "hx"
#define PRIx32    "lx"
#define PRIx64    "llx"

#define strcasecmp strcmp
#include "pdfgen.c"

MCL_EXPORT(pdf_get_err);
MCL_EXPORT(pdf_height);
MCL_EXPORT(pdf_width);
MCL_EXPORT(pdf_set_font);
MCL_EXPORT(pdf_append_page);
MCL_EXPORT(pdf_page_set_size);
MCL_EXPORT(pdf_get_font_text_width);
MCL_EXPORT(pdf_add_text);
MCL_EXPORT(pdf_add_text_spacing);
MCL_EXPORT(pdf_add_text_wrap);
MCL_EXPORT(pdf_add_line);
MCL_EXPORT(pdf_add_image_data);
MCL_EXPORT(pdf_add_image_file);
MCL_EXPORT(pdf_save);
MCL_EXPORT(pdf_destroy);

MCL_EXPORT_INLINE(void, pdf_get_a4_dimensions, (float* W, float* H)) {
    *W = PDF_A4_WIDTH;
    *H = PDF_A4_HEIGHT;
}

MCL_EXPORT_INLINE(struct pdf_doc*, pdf_create_info, ( \
    char* creator, char* producer, char* title, \
    char* author, char* subject, char* date, \
    float width, float height)) {

    struct pdf_info info;

    #define COPY_TO_INFO(Field) memcpy(&info. Field, Field, min(strlen(Field), 64)) 

    COPY_TO_INFO(creator);
    COPY_TO_INFO(producer);
    COPY_TO_INFO(title);
    COPY_TO_INFO(author);
    COPY_TO_INFO(subject);
    COPY_TO_INFO(date);

    return pdf_create(width, height, &info);
}

/*

int main(void) {
    struct pdf_info info = {
        .creator = "My software",
        .producer = "My software",
        .title = "My document",
        .author = "My name",
        .subject = "My subject",
        .date = "Today"
    };
    struct pdf_doc *pdf = pdf_create(PDF_A4_WIDTH, PDF_A4_HEIGHT, &info);
    pdf_set_font(pdf, "Times-Roman");
    pdf_append_page(pdf);
    pdf_add_text(pdf, NULL, "This is text", 12, 50, 20, PDF_BLACK);
    pdf_add_line(pdf, NULL, 50, 24, 150, 24, 3, PDF_BLACK);
    pdf_save(pdf, "output.pdf");
    pdf_destroy(pdf);
    return 0;
}
*/