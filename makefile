CFLAGS=-Wall -g
OBJ=block-china-test.o block-china-data.o ip-tools.o
INFILE=/home/ben/data/maxmind-geolite/GeoLite2-Country-CSV_20180306/GeoLite2-Country-Blocks-IPv4.csv

block-china-test:	$(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o $@

block-china-test.o:	block-china.c ip-tools.h block-china-data.h
	$(CC) $(CFLAGS) -DTEST -c block-china.c -o $@

block-china-data.o:	block-china-data.c ip-tools.h block-china-data.h
	$(CC) $(CFLAGS) -c block-china-data.c

block-china-data.h:	block-china-data.c
	cfunctions  block-china-data.c

block-china-data.c:	get-ip-addresses.pl $(INFILE)
	./get-ip-addresses.pl --outfile $@
#	./get-ip-addresses.pl --infile $(INFILE) --outfile $@

ip-tools.o:	ip-tools.c ip-tools.h
	$(CC) $(CFLAGS) -c ip-tools.c

IPTDIR=/home/ben/projects/ip-tools

ip-tools.c:	$(IPTDIR)/$@
	if [ -f $@ ]; then chmod 0644 $@; fi
	cp -f $(IPTDIR)/$@ .
	chmod 0444 $@

ip-tools.h:	$(IPTDIR)/$@
	if [ -f $@ ]; then chmod 0644 $@; fi
	cp -f $(IPTDIR)/$@ .
	chmod 0444 $@

clean:
	-rm -f $(OBJ) block-china.h block-china-data.[ch] block-china-test \
	ip-tools.[ch]

test:	test.pl block-china-test
	./test.pl

