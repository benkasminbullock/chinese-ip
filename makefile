CFLAGS=-Wall -g
OBJ=block-china-test.o block-china-data.o

block-china-test:	$(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o $@

block-china-test.o:	block-china.c block-china.h
	$(CC) $(CFLAGS) -DTEST -c block-china.c -o $@

block-china-data.o:	block-china-data.c block-china.h
	$(CC) $(CFLAGS) -c block-china-data.c

block-china.h:  block-china.c
	cfunctions -inc block-china.c

block-china-data.c:	get-ip-addresses.pl
	./get-ip-addresses.pl --outfile $@

clean:
	-rm -f $(OBJ) block-china.h block-china-data.c block-china-test

test:	test.pl block-china-test
	./test.pl

