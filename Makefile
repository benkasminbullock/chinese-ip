.include "/home/ben/config/make.conf"
CFLAGS=-Wall -g -O
OBJ=block-china-test.o block-china-data.o ip-tools.o

block-china-test:	$(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o $@

block-china-test.o:	block-china.c ip-tools.h block-china-data.h
	$(CC) $(CFLAGS) -DTEST -c block-china.c -o $@

block-china-data.o:	block-china-data.c ip-tools.h block-china-data.h
	$(CC) $(CFLAGS) -c block-china-data.c

block-china-data.h:	block-china-data.c
	cfunctions  block-china-data.c

block-china-data.c:	get-ip-addresses.pl
	./get-ip-addresses.pl --outfile $@

ip-tools.o:	ip-tools.c ip-tools.h
	$(CC) $(CFLAGS) -c ip-tools.c

IPTDIR=/home/ben/projects/ip-tools

ip-tools.c:	$(IPTDIR)/$@
	copyafile $(IPTDIR)/$@ $@

ip-tools.h:	ip-tools.c
	cfunctions ip-tools.c

clean:
	-rm -f $(OBJ) block-china.h block-china-data.[ch] block-china-test \
	ip-tools.[ch]

test:	test.pl block-china-test
	./test.pl

