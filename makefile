CFLAGS=-Wall -g
OBJ=block-china-test.o block-china-data.o ip-tools.o
INFILE=/home/ben/data/maxmind-geolite/GeoIPCountryWhois.csv

block-china-test:	$(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o $@

block-china-test.o:	block-china.c ip-tools.h block-china-data.h
	$(CC) $(CFLAGS) -DTEST -c block-china.c -o $@

block-china-data.o:	block-china-data.c ip-tools.h block-china-data.h
	$(CC) $(CFLAGS) -c block-china-data.c

block-china-data.h:	block-china-data.c
	cfunctions -inc block-china-data.c

block-china-data.c:	get-ip-addresses.pl $(INFILE)
	./get-ip-addresses.pl --infile $(INFILE) --outfile $@

ip-tools.o:	ip-tools.c ip-tools.h
	$(CC) $(CFLAGS) -c ip-tools.c

IPTDIR=/home/ben/projects/IP-Tools

ip-tools.c:	$(IPTDIR)/$@
	cp -f $(IPTDIR)/$@ .

ip-tools.h:	$(IPTDIR)/$@
	cp -f $(IPTDIR)/$@ .

clean:
	-rm -f $(OBJ) block-china.h block-china-data.c block-china-test

test:	test.pl block-china-test
	./test.pl

