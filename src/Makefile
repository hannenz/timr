CC = gcc
PKGCONFIG = $(shell which pkg-config)
CFLAGS = `$(PKGCONFIG) --cflags gtk+-3.0`
LIBS = `$(PKGCONFIG) --libs gtk+-3.0`

SRC = main.c timr.c timrwin.c resources.c

OBJS = $(SRC:.c=.o)

all: timr

%.o: %.c
	$(CC) -Wall -rdynamic -c -o $(@F) $< $(CFLAGS)

timr: $(OBJS)
	glib-compile-resources timr.gresource.xml --target=resources.c --generate-source
	$(CC) -Wall -rdynamic -o $(@F) $(OBJS) $(LIBS)

clean:
	rm -f $(OBJS)
	rm -f timr
