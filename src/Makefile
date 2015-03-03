PRG = timr
CC = gcc
VALAC = valac
PKGCONFIG = $(shell which pkg-config)
CFLAGS = `$(PKGCONFIG) --cflags gtk+-3.0 sqlite3`
LIBS = `$(PKGCONFIG) --libs gtk+-3.0 sqlite3`
VALAFLAGS = --pkg gtk+-3.0 --pkg sqlite3 --target-glib=2.38 --gresources data/timr.gresource.xml

SOURCES =	main.vala\
			timr.vala\
			timrwin.vala\
			activity.vala\
			job.vala\
			client.vala\
			activity_dialog.vala\
			repository.vala
			#$(wildcard *.vala)

CSOURCES = 	$(SOURCES:.vala=.c)
OBJS =		$(CSOURCES:.c=.o)

UIFILES = 	../data/timr.ui\
			../data/app_menu.ui\
			../data/activity_dialog.ui\
			../data/timr.gresource.xml


.PHONY: all clean distclean
.SECONDARY: $(CSOURCES)

foo:
	@echo $(SOURCES)
	@echo $(CSOURCES)
	@echo $(OBJS)
	@echo $(UIFILES)


all: $(PRG)

$(PRG): $(SOURCES) $(UIFILES)
	glib-compile-resources ../data/timr.gresource.xml --target=resources.c --generate-source --sourcedir="../data"
	$(VALAC) -o $(PRG) $(SOURCES) $(VALAFLAGS)
	#$(CC) $^ -o $@ $(LDFLAGS)

# %.o:%.c
# 	$(CC) $^ -c -o $@ -Wall -rdynamic $(CFLAGS)

# %.c:%.vala
# 	$(VALAC) $^ -C -o $@ $(VALAFLAGS)


clean:
	rm -f $(OBJS)
	rm -f $(PRG)

distclean: clean
	rm -f $(CSOURCES)