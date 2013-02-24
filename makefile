CFLAGS=-Wall -g
OBJ=block-china-test.o block-china-data.o
INFILE=/home/ben/data/maxmind-geolite/GeoIPCountryWhois.csv

block-china-test:	$(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o $@

block-china-test.o:	block-china.c block-china.h
	$(CC) $(CFLAGS) -DTEST -c block-china.c -o $@

block-china-data.o:	block-china-data.c block-china.h
	$(CC) $(CFLAGS) -c block-china-data.c

block-china.h:  block-china.c
	cfunctions -inc block-china.c

block-china-data.c:	get-ip-addresses.pl $(INFILE)
	./get-ip-addresses.pl --infile $(INFILE) --outfile $@

clean:
	-rm -f $(OBJ) block-china.h block-china-data.c block-china-test

test:	test.pl block-china-test
	./test.pl

