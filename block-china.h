/* This is a Cfunctions (version 0.28) generated header file.
   Cfunctions is a free program for extracting headers from C files.
   Get Cfunctions from 'http://www.lemoda.net/cfunctions/'. */

/* This file was generated with:
'cfunctions -inc block-china.c' */
#ifndef CFH_BLOCK_CHINA_H
#define CFH_BLOCK_CHINA_H

/* From 'block-china.c': */

#line 4 "block-china.c"
typedef struct {
    unsigned start;
    unsigned end;
}
china_ip_t;

#line 10 "block-china.c"
extern china_ip_t china_ips[];

#line 11 "block-china.c"
extern int n_china_ips;

#line 15 "block-china.c"
unsigned int ip_to_int (char * ip );

#line 27 "block-china.c"
int chinese_ip (unsigned ip );

#endif /* CFH_BLOCK_CHINA_H */
