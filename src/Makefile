CC = gcc
VALAC = valac
PKGCONFIG = $(shell which pkg-config)
CFLAGS = `$(PKGCONFIG) --cflags gtk+-3.0`
LIBS = `$(PKGCONFIG) --libs gtk+-3.0`
VALAFLAGS = --pkg gtk+-3.0 --pkg sqlite3 --target-glib=2.38 --gresources timr.gresource.xml

SRC = main.vala timr.vala timrwin.vala activity.vala

OBJS = $(SRC:.vala=.c)

all: timr

# %.c: %.vala
# 	$(VALAC) -C $< $(VALAFLAGS)

# %.o: %.c
# 	$(CC) -Wall -rdynamic -c -o $(@F) $< $(CFLAGS)

timr: 
	glib-compile-resources timr.gresource.xml --target=resources.c --generate-source
	$(VALAC) -o timr $(SRC) resources.c $(VALAFLAGS)

clean:
	rm -f $(OBJS)
	rm -f timr
