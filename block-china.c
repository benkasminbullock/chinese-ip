#include <stdlib.h>
#include <stdio.h>
#include "block-china.h"
#ifdef HEADER
typedef struct {
    unsigned start;
    unsigned end;
}
china_ip_t;
extern china_ip_t china_ips[];
extern int n_china_ips;
#endif /* def HEADER */

unsigned int ip_to_int (const char * ip)
{
    unsigned v = 0;
    int i;
    const char * start;
    start = ip;
    for (i = 0; i < 4; i++) {
        char c;
        int n = 0;
        while (1) {
            c = * start;
            start++;
            if (c >= '0' && c <= '9') {
                n *= 10;
                n += c - '0';
            }
            else {
                break;
            }
        }
        v *= 256;
        v += n;
    }
    return v;
}

#define NOTFOUND 0
#define FOUND -1

int chinese_ip (unsigned ip)
{
    int i;
    int division;
    int count = 0;

    division = n_china_ips / 2;
    i = division;
    while (1) {
        count++;
        if (count > 100) {
            fprintf (stderr, "There is bad logic in the search.\n");
            exit (1);
        }
#if 0
        printf ("i is %d; Division is %d, start is %X end is %X\n",
                i, division, china_ips[i].start, china_ips[i].end);
#endif /* 0 */
        division /= 2;
        if (division == 0) {
            division = 1;
        }
        if (china_ips[i].start > ip) {
            i-= division;
        }
        else if (china_ips[i+1].start < ip) {
            i+= division;
        }
        else {
            if (ip >= china_ips[i].start && ip <= china_ips[i].end) {
                return FOUND;
            }
            else {
                return NOTFOUND;
            }
        }
        if (i >= n_china_ips - 1 || i < 0) {
            return NOTFOUND;
        }
    }
}

#ifdef TEST

int main (int argc, char ** argv)
{
    int i;
    for (i = 1; i < argc; i++) {
        unsigned long ipAddr;
        ipAddr = ip_to_int (argv[i]);
        printf ("%X\n", ipAddr);
        printf ("%d\n", chinese_ip (ipAddr));
    }
    return 0;
}

#endif /* def TEST */

