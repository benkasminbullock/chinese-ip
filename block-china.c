#include <stdlib.h>
#include <stdio.h>
#include "ip-tools.h"
#include "block-china-data.h"

#ifdef TEST

int main (int argc, char ** argv)
{
    int i;
    for (i = 1; i < argc; i++) {
        unsigned ipAddr;
        int found;

        ipAddr = ip_tools_ip_to_int (argv[i]);
        printf ("This IP is %X\n", ipAddr);
        found = ip_tools_ip_range (china_ips, n_china_ips, ipAddr);
        if (found != NOTFOUND) {
            printf ("%d\n", found);
        }
        else {
            printf ("Not found.\n");
        }
    }
    return 0;
}

#endif /* def TEST */

