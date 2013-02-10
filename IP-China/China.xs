#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "block-china.h"

MODULE=IP::China PACKAGE=IP::China

PROTOTYPES: ENABLE

int
chinese_ip (char * ip)
CODE:
        unsigned long ipAddr;
        ipAddr = ip_to_int (ip);
        RETVAL = chinese_ip (ipAddr);
        OUTPUT:
        RETVAL
