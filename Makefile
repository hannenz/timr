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

UIFILES = 	data/timr.ui\
			data/app_menu.ui\
			data/activity_dialog.ui\
			data/timr.gresource.xml

.PHONY: all clean distclean

all: $(PRG)

$(PRG): $(SOURCES) $(UIFILES)
	glib-compile-resources data/timr.gresource.xml --target=src/resources.c --generate-source --sourcedir="./data"
	$(VALAC) -o $(PRG) $(SOURCES) src/resources.c $(VALAFLAGS)

clean:
	rm -f $(OBJS)
	rm -f $(PRG)

distclean: clean
	rm -f *.vala.c