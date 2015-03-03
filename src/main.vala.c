/* main.vala.c generated by valac 0.26.2, the Vala compiler
 * generated from main.vala, do not modify */


#include <glib.h>
#include <glib-object.h>
#include <stdlib.h>
#include <string.h>
#include <gtk/gtk.h>
#include <gio/gio.h>


#define TIMR_TYPE_TIMR (timr_timr_get_type ())
#define TIMR_TIMR(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TIMR_TYPE_TIMR, TimrTimr))
#define TIMR_TIMR_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), TIMR_TYPE_TIMR, TimrTimrClass))
#define TIMR_IS_TIMR(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TIMR_TYPE_TIMR))
#define TIMR_IS_TIMR_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), TIMR_TYPE_TIMR))
#define TIMR_TIMR_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), TIMR_TYPE_TIMR, TimrTimrClass))

typedef struct _TimrTimr TimrTimr;
typedef struct _TimrTimrClass TimrTimrClass;
#define _g_object_unref0(var) ((var == NULL) ? NULL : (var = (g_object_unref (var), NULL)))



gint timr_main (gchar** args, int args_length1);
GType timr_timr_get_type (void) G_GNUC_CONST;
TimrTimr* timr_timr_new (void);
TimrTimr* timr_timr_construct (GType object_type);


gint timr_main (gchar** args, int args_length1) {
	gint result = 0;
	TimrTimr* app = NULL;
	TimrTimr* _tmp0_ = NULL;
	gint _tmp1_ = 0;
	_tmp0_ = timr_timr_new ();
	app = _tmp0_;
	_tmp1_ = g_application_run ((GApplication*) app, 0, NULL);
	result = _tmp1_;
	_g_object_unref0 (app);
	return result;
}


int main (int argc, char ** argv) {
#if !GLIB_CHECK_VERSION (2,35,0)
	g_type_init ();
#endif
	return timr_main (argv, argc);
}



