PRG = timr
CC = gcc
VALAC = valac
PKGCONFIG = $(shell which pkg-config)
PACKAGES = gtk+-3.0 sqlite3 gee-0.8 granite
CFLAGS = `$(PKGCONFIG) --cflags $(PACKAGES)`
LIBS = `$(PKGCONFIG) --libs $(PACKAGES)`
VALAFLAGS = $(patsubst %, --pkg %, $(PACKAGES)) --target-glib=2.38 --gresources data/timr.gresource.xml

SOURCES =	src/main.vala\
			src/timr.vala\
			src/timrwin.vala\
			src/activity.vala\
			src/job.vala\
			src/client.vala\
			src/category.vala\
			src/activity_dialog.vala\
			src/client_dialog.vala\
			src/job_dialog.vala\
			src/repository.vala\
#			src/cell_renderer_button.vala\

UIFILES = 	data/timr.ui\
			data/app_menu.ui\
			data/activity_dialog.ui\
			data/job_dialog.ui\
			data/client_dialog.ui\
			data/timr.gresource.xml

#Disable implicit rules by empty target .SUFFIXES
.SUFFIXES:

.PHONY: all clean distclean

all: $(PRG)

$(PRG): $(SOURCES) $(UIFILES)
	glib-compile-resources data/timr.gresource.xml --target=src/resources.c --generate-source --sourcedir="./data"
	$(VALAC) -o $(PRG) $(SOURCES) src/resources.c $(VALAFLAGS)

clean:
	rm -f $(OBJS)
	rm -f $(PRG)

distclean: clean
	rm -f src/*.vala.c
