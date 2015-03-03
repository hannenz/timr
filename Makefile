PRG = timr
CC = gcc
VALAC = valac
PKGCONFIG = $(shell which pkg-config)
CFLAGS = `$(PKGCONFIG) --cflags gtk+-3.0 sqlite3`
LIBS = `$(PKGCONFIG) --libs gtk+-3.0 sqlite3`
VALAFLAGS = --pkg gtk+-3.0 --pkg sqlite3 --target-glib=2.38 --gresources data/timr.gresource.xml

SOURCES =	src/main.vala\
			src/timr.vala\
			src/timrwin.vala\
			src/activity.vala\
			src/job.vala\
			src/client.vala\
			src/activity_dialog.vala\
			src/repository.vala

CSOURCES = 	$(SOURCES:.vala=.c)
OBJS =		$(CSOURCES:.c=.o)

UIFILES = 	data/timr.ui\
			data/app_menu.ui\
			data/activity_dialog.ui\
			data/timr.gresource.xml


.PHONY: all clean distclean
.SECONDARY: $(CSOURCES)

foo:
	@echo $(SOURCES)
	@echo $(CSOURCES)
	@echo $(OBJS)

all: $(PRG)

$(PRG): $(OBJS) $(UIFILES)
	glib-compile-resources data/timr.gresource.xml --target=src/resources.c --generate-source --sourcedir="./data"
	$(CC) $^ -o $@ $(LDFLAGS)

%.o: %.c
	$(CC) $^ -c -o $@ -Wall -rdynamic $(CFLAGS)

%.c: %.vala
	$(VALAC) $^ -C -o $@ $(VALAFLAGS)


clean:
	rm -f $(OBJS)
	rm -f $(PRG)

distclean: clean
	rm -f $(CSOURCES)