/* timr.vala.c generated by valac 0.26.2, the Vala compiler
 * generated from timr.vala, do not modify */


#include <glib.h>
#include <glib-object.h>
#include <gtk/gtk.h>
#include <sqlite3.h>
#include <gio/gio.h>
#include <stdlib.h>
#include <string.h>


#define TIMR_TYPE_TIMR (timr_timr_get_type ())
#define TIMR_TIMR(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TIMR_TYPE_TIMR, TimrTimr))
#define TIMR_TIMR_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), TIMR_TYPE_TIMR, TimrTimrClass))
#define TIMR_IS_TIMR(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TIMR_TYPE_TIMR))
#define TIMR_IS_TIMR_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), TIMR_TYPE_TIMR))
#define TIMR_TIMR_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), TIMR_TYPE_TIMR, TimrTimrClass))

typedef struct _TimrTimr TimrTimr;
typedef struct _TimrTimrClass TimrTimrClass;
typedef struct _TimrTimrPrivate TimrTimrPrivate;

#define TIMR_TYPE_APPLICATION_WINDOW (timr_application_window_get_type ())
#define TIMR_APPLICATION_WINDOW(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TIMR_TYPE_APPLICATION_WINDOW, TimrApplicationWindow))
#define TIMR_APPLICATION_WINDOW_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), TIMR_TYPE_APPLICATION_WINDOW, TimrApplicationWindowClass))
#define TIMR_IS_APPLICATION_WINDOW(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TIMR_TYPE_APPLICATION_WINDOW))
#define TIMR_IS_APPLICATION_WINDOW_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), TIMR_TYPE_APPLICATION_WINDOW))
#define TIMR_APPLICATION_WINDOW_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), TIMR_TYPE_APPLICATION_WINDOW, TimrApplicationWindowClass))

typedef struct _TimrApplicationWindow TimrApplicationWindow;
typedef struct _TimrApplicationWindowClass TimrApplicationWindowClass;

#define TIMR_TYPE_REPOSITORY (timr_repository_get_type ())
#define TIMR_REPOSITORY(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TIMR_TYPE_REPOSITORY, TimrRepository))
#define TIMR_REPOSITORY_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), TIMR_TYPE_REPOSITORY, TimrRepositoryClass))
#define TIMR_IS_REPOSITORY(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TIMR_TYPE_REPOSITORY))
#define TIMR_IS_REPOSITORY_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), TIMR_TYPE_REPOSITORY))
#define TIMR_REPOSITORY_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), TIMR_TYPE_REPOSITORY, TimrRepositoryClass))

typedef struct _TimrRepository TimrRepository;
typedef struct _TimrRepositoryClass TimrRepositoryClass;
#define _g_object_unref0(var) ((var == NULL) ? NULL : (var = (g_object_unref (var), NULL)))
#define _timr_repository_unref0(var) ((var == NULL) ? NULL : (var = (timr_repository_unref (var), NULL)))
#define _sqlite3_close0(var) ((var == NULL) ? NULL : (var = (sqlite3_close (var), NULL)))
#define _g_free0(var) (var = (g_free (var), NULL))

#define TIMR_TYPE_ACTIVITY (timr_activity_get_type ())
#define TIMR_ACTIVITY(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TIMR_TYPE_ACTIVITY, TimrActivity))
#define TIMR_ACTIVITY_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), TIMR_TYPE_ACTIVITY, TimrActivityClass))
#define TIMR_IS_ACTIVITY(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TIMR_TYPE_ACTIVITY))
#define TIMR_IS_ACTIVITY_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), TIMR_TYPE_ACTIVITY))
#define TIMR_ACTIVITY_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), TIMR_TYPE_ACTIVITY, TimrActivityClass))

typedef struct _TimrActivity TimrActivity;
typedef struct _TimrActivityClass TimrActivityClass;
typedef struct _TimrActivityPrivate TimrActivityPrivate;

#define TIMR_TYPE_JOB (timr_job_get_type ())
#define TIMR_JOB(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TIMR_TYPE_JOB, TimrJob))
#define TIMR_JOB_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), TIMR_TYPE_JOB, TimrJobClass))
#define TIMR_IS_JOB(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TIMR_TYPE_JOB))
#define TIMR_IS_JOB_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), TIMR_TYPE_JOB))
#define TIMR_JOB_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), TIMR_TYPE_JOB, TimrJobClass))

typedef struct _TimrJob TimrJob;
typedef struct _TimrJobClass TimrJobClass;
typedef struct _TimrApplicationWindowPrivate TimrApplicationWindowPrivate;
#define _gtk_tree_path_free0(var) ((var == NULL) ? NULL : (var = (gtk_tree_path_free (var), NULL)))

#define TIMR_TYPE_CLIENT (timr_client_get_type ())
#define TIMR_CLIENT(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TIMR_TYPE_CLIENT, TimrClient))
#define TIMR_CLIENT_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), TIMR_TYPE_CLIENT, TimrClientClass))
#define TIMR_IS_CLIENT(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TIMR_TYPE_CLIENT))
#define TIMR_IS_CLIENT_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), TIMR_TYPE_CLIENT))
#define TIMR_CLIENT_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), TIMR_TYPE_CLIENT, TimrClientClass))

typedef struct _TimrClient TimrClient;
typedef struct _TimrClientClass TimrClientClass;
#define __g_list_free__timr_client_unref0_0(var) ((var == NULL) ? NULL : (var = (_g_list_free__timr_client_unref0_ (var), NULL)))
typedef struct _Block1Data Block1Data;
#define _g_date_time_unref0(var) ((var == NULL) ? NULL : (var = (g_date_time_unref (var), NULL)))

struct _TimrTimr {
	GtkApplication parent_instance;
	TimrTimrPrivate * priv;
	sqlite3* db;
};

struct _TimrTimrClass {
	GtkApplicationClass parent_class;
};

struct _TimrTimrPrivate {
	TimrApplicationWindow* window;
	TimrRepository* repository;
};

struct _TimrActivity {
	GTypeInstance parent_instance;
	volatile int ref_count;
	TimrActivityPrivate * priv;
	gchar* description;
	TimrJob* job;
	gint job_id;
	gchar* job_name;
	gchar* client;
	gchar* type;
	gchar* text;
};

struct _TimrActivityClass {
	GTypeClass parent_class;
	void (*finalize) (TimrActivity *self);
};

struct _TimrApplicationWindow {
	GtkApplicationWindow parent_instance;
	TimrApplicationWindowPrivate * priv;
	GtkTreeStore* activities;
	GtkListStore* clients;
	GtkListStore* jobs;
	GtkTreeStore* clients_jobs;
	GtkTreeView* activities_treeview;
	GtkInfoBar* info_bar;
	GtkLabel* info_bar_primary_label;
	GtkButtonBox* info_bar_action_area;
	TimrActivity* activity;
};

struct _TimrApplicationWindowClass {
	GtkApplicationWindowClass parent_class;
};

struct _Block1Data {
	int _ref_count_;
	TimrTimr* self;
	GtkTreeIter* parent_iter;
	gchar* date;
};


static gpointer timr_timr_parent_class = NULL;

GType timr_timr_get_type (void) G_GNUC_CONST;
GType timr_application_window_get_type (void) G_GNUC_CONST;
gpointer timr_repository_ref (gpointer instance);
void timr_repository_unref (gpointer instance);
GParamSpec* timr_param_spec_repository (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags);
void timr_value_set_repository (GValue* value, gpointer v_object);
void timr_value_take_repository (GValue* value, gpointer v_object);
gpointer timr_value_get_repository (const GValue* value);
GType timr_repository_get_type (void) G_GNUC_CONST;
#define TIMR_TIMR_GET_PRIVATE(o) (G_TYPE_INSTANCE_GET_PRIVATE ((o), TIMR_TYPE_TIMR, TimrTimrPrivate))
enum  {
	TIMR_TIMR_DUMMY_PROPERTY
};
TimrTimr* timr_timr_new (void);
TimrTimr* timr_timr_construct (GType object_type);
static void timr_timr_real_activate (GApplication* base);
TimrRepository* timr_repository_new (const gchar* db_filename);
TimrRepository* timr_repository_construct (GType object_type, const gchar* db_filename);
TimrApplicationWindow* timr_application_window_new (TimrTimr* application);
TimrApplicationWindow* timr_application_window_construct (GType object_type, TimrTimr* application);
static void __lambda6_ (TimrTimr* self, const gchar* query);
void timr_application_window_error (TimrApplicationWindow* self, const gchar* message);
static void ___lambda6__timr_application_window_update_database (TimrApplicationWindow* _sender, const gchar* query, gpointer self);
gpointer timr_activity_ref (gpointer instance);
void timr_activity_unref (gpointer instance);
GParamSpec* timr_param_spec_activity (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags);
void timr_value_set_activity (GValue* value, gpointer v_object);
void timr_value_take_activity (GValue* value, gpointer v_object);
gpointer timr_value_get_activity (const GValue* value);
GType timr_activity_get_type (void) G_GNUC_CONST;
static void __lambda7_ (TimrTimr* self, TimrActivity* activity);
gpointer timr_job_ref (gpointer instance);
void timr_job_unref (gpointer instance);
GParamSpec* timr_param_spec_job (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags);
void timr_value_set_job (GValue* value, gpointer v_object);
void timr_value_take_job (GValue* value, gpointer v_object);
gpointer timr_value_get_job (const GValue* value);
GType timr_job_get_type (void) G_GNUC_CONST;
gchar* timr_activity_get_begin_datetime (TimrActivity* self);
gchar* timr_activity_get_end_datetime (TimrActivity* self);
gboolean timr_timr_insert_activity (TimrTimr* self, TimrActivity* activity, gint id);
static void ___lambda7__timr_application_window_activity_stopped (TimrApplicationWindow* _sender, TimrActivity* a, gpointer self);
static gboolean timr_timr_load_data (TimrTimr* self);
gpointer timr_client_ref (gpointer instance);
void timr_client_unref (gpointer instance);
GParamSpec* timr_param_spec_client (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags);
void timr_value_set_client (GValue* value, gpointer v_object);
void timr_value_take_client (GValue* value, gpointer v_object);
gpointer timr_value_get_client (const GValue* value);
GType timr_client_get_type (void) G_GNUC_CONST;
GList* timr_repository_get_all_clients (TimrRepository* self);
gchar* timr_client_get_name (TimrClient* self);
static void _timr_client_unref0_ (gpointer var);
static void _g_list_free__timr_client_unref0_ (GList* self);
static void timr_timr_preferences (TimrTimr* self);
static void timr_timr_real_startup (GApplication* base);
static void _timr_timr_preferences_g_simple_action_activate (GSimpleAction* _sender, GVariant* parameter, gpointer self);
static void _g_application_quit_g_simple_action_activate (GSimpleAction* _sender, GVariant* parameter, gpointer self);
static Block1Data* block1_data_ref (Block1Data* _data1_);
static void block1_data_unref (void * _userdata_);
gchar* timr_activity_get_date (TimrActivity* self);
static gboolean __lambda8_ (Block1Data* _data1_, GtkTreeModel* model, GtkTreePath* path, GtkTreeIter* iter);
static GtkTreeIter* _gtk_tree_iter_dup (GtkTreeIter* self);
static gboolean ___lambda8__gtk_tree_model_foreach_func (GtkTreeModel* model, GtkTreePath* path, GtkTreeIter* iter, gpointer self);
static gchar* timr_timr_nice_date (TimrTimr* self, GDateTime* date);
GDateTime* timr_activity_get_begin (TimrActivity* self);
gint timr_activity_get_duration (TimrActivity* self);
gchar* timr_activity_get_duration_nice (TimrActivity* self);
gchar* timr_activity_get_timespan_formatted (TimrActivity* self);
static void timr_timr_finalize (GObject* obj);
static void _vala_array_destroy (gpointer array, gint array_length, GDestroyNotify destroy_func);
static void _vala_array_free (gpointer array, gint array_length, GDestroyNotify destroy_func);


TimrTimr* timr_timr_construct (GType object_type) {
	TimrTimr * self = NULL;
	self = (TimrTimr*) g_object_new (object_type, NULL);
	g_application_set_application_id ((GApplication*) self, "de.hannenz.timr");
	return self;
}


TimrTimr* timr_timr_new (void) {
	return timr_timr_construct (TIMR_TYPE_TIMR);
}


static gint _sqlite3_exec (sqlite3* self, const gchar* sql, sqlite3_callback callback, void* callback_target, gchar** errmsg) {
	gchar* _vala_errmsg = NULL;
	gint result = 0;
	const gchar* sqlite_errmsg = NULL;
	gint ec = 0;
	const gchar* _tmp0_ = NULL;
	sqlite3_callback _tmp1_ = NULL;
	void* _tmp1__target = NULL;
	const gchar* _tmp2_ = NULL;
	gint _tmp3_ = 0;
	const gchar* _tmp6_ = NULL;
	g_return_val_if_fail (self != NULL, 0);
	g_return_val_if_fail (sql != NULL, 0);
	_tmp0_ = sql;
	_tmp1_ = callback;
	_tmp1__target = callback_target;
	_tmp3_ = sqlite3_exec (self, _tmp0_, _tmp1_, _tmp1__target, (char**) (&_tmp2_));
	sqlite_errmsg = _tmp2_;
	ec = _tmp3_;
	if ((&_vala_errmsg) != NULL) {
		const gchar* _tmp4_ = NULL;
		gchar* _tmp5_ = NULL;
		_tmp4_ = sqlite_errmsg;
		_tmp5_ = g_strdup (_tmp4_);
		_g_free0 (_vala_errmsg);
		_vala_errmsg = _tmp5_;
	}
	_tmp6_ = sqlite_errmsg;
	sqlite3_free ((void*) _tmp6_);
	result = ec;
	if (errmsg) {
		*errmsg = _vala_errmsg;
	} else {
		_g_free0 (_vala_errmsg);
	}
	return result;
}


static void __lambda6_ (TimrTimr* self, const gchar* query) {
	gint rc = 0;
	gchar* error_message = NULL;
	sqlite3* _tmp0_ = NULL;
	const gchar* _tmp1_ = NULL;
	gchar* _tmp2_ = NULL;
	gint _tmp3_ = 0;
	gint _tmp4_ = 0;
	g_return_if_fail (query != NULL);
	_tmp0_ = self->db;
	_tmp1_ = query;
	_tmp3_ = _sqlite3_exec (_tmp0_, _tmp1_, NULL, NULL, &_tmp2_);
	_g_free0 (error_message);
	error_message = _tmp2_;
	rc = _tmp3_;
	_tmp4_ = rc;
	if (_tmp4_ != SQLITE_OK) {
		TimrApplicationWindow* _tmp5_ = NULL;
		gint _tmp6_ = 0;
		const gchar* _tmp7_ = NULL;
		gchar* _tmp8_ = NULL;
		gchar* _tmp9_ = NULL;
		_tmp5_ = self->priv->window;
		_tmp6_ = rc;
		_tmp7_ = error_message;
		_tmp8_ = g_strdup_printf ("Error while executing Sqlite query: %d: %s\n", _tmp6_, _tmp7_);
		_tmp9_ = _tmp8_;
		timr_application_window_error (_tmp5_, _tmp9_);
		_g_free0 (_tmp9_);
	}
	_g_free0 (error_message);
}


static void ___lambda6__timr_application_window_update_database (TimrApplicationWindow* _sender, const gchar* query, gpointer self) {
	__lambda6_ ((TimrTimr*) self, query);
}


static void __lambda7_ (TimrTimr* self, TimrActivity* activity) {
	gchar* query = NULL;
	TimrActivity* _tmp0_ = NULL;
	const gchar* _tmp1_ = NULL;
	TimrActivity* _tmp2_ = NULL;
	gint _tmp3_ = 0;
	TimrActivity* _tmp4_ = NULL;
	gchar* _tmp5_ = NULL;
	gchar* _tmp6_ = NULL;
	TimrActivity* _tmp7_ = NULL;
	gchar* _tmp8_ = NULL;
	gchar* _tmp9_ = NULL;
	gchar* _tmp10_ = NULL;
	gchar* _tmp11_ = NULL;
	gchar* error_message = NULL;
	gint ec = 0;
	sqlite3* _tmp12_ = NULL;
	const gchar* _tmp13_ = NULL;
	gchar* _tmp14_ = NULL;
	gint _tmp15_ = 0;
	gint _tmp16_ = 0;
	TimrActivity* _tmp21_ = NULL;
	sqlite3* _tmp22_ = NULL;
	gint64 _tmp23_ = 0LL;
	g_return_if_fail (activity != NULL);
	_tmp0_ = activity;
	_tmp1_ = _tmp0_->description;
	_tmp2_ = activity;
	_tmp3_ = _tmp2_->job_id;
	_tmp4_ = activity;
	_tmp5_ = timr_activity_get_begin_datetime (_tmp4_);
	_tmp6_ = _tmp5_;
	_tmp7_ = activity;
	_tmp8_ = timr_activity_get_end_datetime (_tmp7_);
	_tmp9_ = _tmp8_;
	_tmp10_ = g_strdup_printf ("INSERT INTO activities (description,job_id,begin,end) VALUES ('%s', %u" \
", '%s', '%s')", _tmp1_, (guint) _tmp3_, _tmp6_, _tmp9_);
	_tmp11_ = _tmp10_;
	_g_free0 (_tmp9_);
	_g_free0 (_tmp6_);
	query = _tmp11_;
	_tmp12_ = self->db;
	_tmp13_ = query;
	_tmp15_ = _sqlite3_exec (_tmp12_, _tmp13_, NULL, NULL, &_tmp14_);
	_g_free0 (error_message);
	error_message = _tmp14_;
	ec = _tmp15_;
	_tmp16_ = ec;
	if (_tmp16_ != SQLITE_OK) {
		TimrApplicationWindow* _tmp17_ = NULL;
		const gchar* _tmp18_ = NULL;
		gchar* _tmp19_ = NULL;
		gchar* _tmp20_ = NULL;
		_tmp17_ = self->priv->window;
		_tmp18_ = error_message;
		_tmp19_ = g_strconcat ("Error: ", _tmp18_, NULL);
		_tmp20_ = _tmp19_;
		timr_application_window_error (_tmp17_, _tmp20_);
		_g_free0 (_tmp20_);
	}
	_tmp21_ = activity;
	_tmp22_ = self->db;
	_tmp23_ = sqlite3_last_insert_rowid (_tmp22_);
	timr_timr_insert_activity (self, _tmp21_, (gint) _tmp23_);
	_g_free0 (error_message);
	_g_free0 (query);
}


static void ___lambda7__timr_application_window_activity_stopped (TimrApplicationWindow* _sender, TimrActivity* a, gpointer self) {
	__lambda7_ ((TimrTimr*) self, a);
}


static void timr_timr_real_activate (GApplication* base) {
	TimrTimr * self;
	TimrRepository* _tmp0_ = NULL;
	TimrApplicationWindow* _tmp1_ = NULL;
	TimrApplicationWindow* _tmp2_ = NULL;
	TimrApplicationWindow* _tmp3_ = NULL;
	TimrApplicationWindow* _tmp4_ = NULL;
	TimrApplicationWindow* _tmp5_ = NULL;
	GtkTreeView* _tmp6_ = NULL;
	GtkTreePath* _tmp7_ = NULL;
	GtkTreePath* _tmp8_ = NULL;
	self = (TimrTimr*) base;
	_tmp0_ = timr_repository_new ("/home/hannenz/timr/data/timr.db");
	_timr_repository_unref0 (self->priv->repository);
	self->priv->repository = _tmp0_;
	_tmp1_ = timr_application_window_new (self);
	g_object_ref_sink (_tmp1_);
	_g_object_unref0 (self->priv->window);
	self->priv->window = _tmp1_;
	_tmp2_ = self->priv->window;
	gtk_window_present ((GtkWindow*) _tmp2_);
	_tmp3_ = self->priv->window;
	g_signal_connect_object (_tmp3_, "update-database", (GCallback) ___lambda6__timr_application_window_update_database, self, 0);
	_tmp4_ = self->priv->window;
	g_signal_connect_object (_tmp4_, "activity-stopped", (GCallback) ___lambda7__timr_application_window_activity_stopped, self, 0);
	timr_timr_load_data (self);
	_tmp5_ = self->priv->window;
	_tmp6_ = _tmp5_->activities_treeview;
	_tmp7_ = gtk_tree_path_new_first ();
	_tmp8_ = _tmp7_;
	gtk_tree_view_expand_row (_tmp6_, _tmp8_, TRUE);
	_gtk_tree_path_free0 (_tmp8_);
}


static void _timr_client_unref0_ (gpointer var) {
	(var == NULL) ? NULL : (var = (timr_client_unref (var), NULL));
}


static void _g_list_free__timr_client_unref0_ (GList* self) {
	g_list_foreach (self, (GFunc) _timr_client_unref0_, NULL);
	g_list_free (self);
}


static gboolean timr_timr_load_data (TimrTimr* self) {
	gboolean result = FALSE;
	GList* clients = NULL;
	TimrRepository* _tmp0_ = NULL;
	GList* _tmp1_ = NULL;
	GList* _tmp2_ = NULL;
	g_return_val_if_fail (self != NULL, FALSE);
	_tmp0_ = self->priv->repository;
	_tmp1_ = timr_repository_get_all_clients (_tmp0_);
	clients = _tmp1_;
	_tmp2_ = clients;
	{
		GList* c_collection = NULL;
		GList* c_it = NULL;
		c_collection = _tmp2_;
		for (c_it = c_collection; c_it != NULL; c_it = c_it->next) {
			TimrClient* c = NULL;
			c = (TimrClient*) c_it->data;
			{
				TimrClient* _tmp3_ = NULL;
				gchar* _tmp4_ = NULL;
				gchar* _tmp5_ = NULL;
				_tmp3_ = c;
				_tmp4_ = timr_client_get_name (_tmp3_);
				_tmp5_ = _tmp4_;
				g_debug ("timr.vala:63: %s", _tmp5_);
				_g_free0 (_tmp5_);
			}
		}
	}
	result = TRUE;
	__g_list_free__timr_client_unref0_0 (clients);
	return result;
}


static void timr_timr_preferences (TimrTimr* self) {
	g_return_if_fail (self != NULL);
}


static void _timr_timr_preferences_g_simple_action_activate (GSimpleAction* _sender, GVariant* parameter, gpointer self) {
	timr_timr_preferences ((TimrTimr*) self);
}


static void _g_application_quit_g_simple_action_activate (GSimpleAction* _sender, GVariant* parameter, gpointer self) {
	g_application_quit ((GApplication*) self);
}


static gpointer _g_object_ref0 (gpointer self) {
	return self ? g_object_ref (self) : NULL;
}


static void timr_timr_real_startup (GApplication* base) {
	TimrTimr * self;
	GSimpleAction* action = NULL;
	GSimpleAction* _tmp0_ = NULL;
	GSimpleAction* _tmp1_ = NULL;
	GSimpleAction* _tmp2_ = NULL;
	GSimpleAction* _tmp3_ = NULL;
	GSimpleAction* _tmp4_ = NULL;
	GSimpleAction* _tmp5_ = NULL;
	gchar* _tmp6_ = NULL;
	gchar** _tmp7_ = NULL;
	gchar** _tmp8_ = NULL;
	gint _tmp8__length1 = 0;
	GtkBuilder* builder = NULL;
	GtkBuilder* _tmp9_ = NULL;
	GMenuModel* app_menu = NULL;
	GObject* _tmp10_ = NULL;
	GMenuModel* _tmp11_ = NULL;
	self = (TimrTimr*) base;
	G_APPLICATION_CLASS (timr_timr_parent_class)->startup ((GApplication*) G_TYPE_CHECK_INSTANCE_CAST (self, gtk_application_get_type (), GtkApplication));
	_tmp0_ = g_simple_action_new ("preferences", NULL);
	action = _tmp0_;
	_tmp1_ = action;
	g_signal_connect_object (_tmp1_, "activate", (GCallback) _timr_timr_preferences_g_simple_action_activate, self, 0);
	_tmp2_ = action;
	g_action_map_add_action ((GActionMap*) self, (GAction*) _tmp2_);
	_tmp3_ = g_simple_action_new ("quit", NULL);
	_g_object_unref0 (action);
	action = _tmp3_;
	_tmp4_ = action;
	g_signal_connect_object (_tmp4_, "activate", (GCallback) _g_application_quit_g_simple_action_activate, (GApplication*) self, 0);
	_tmp5_ = action;
	g_action_map_add_action ((GActionMap*) self, (GAction*) _tmp5_);
	_tmp6_ = g_strdup ("<Ctrl>Q");
	_tmp7_ = g_new0 (gchar*, 1 + 1);
	_tmp7_[0] = _tmp6_;
	_tmp8_ = _tmp7_;
	_tmp8__length1 = 1;
	gtk_application_set_accels_for_action ((GtkApplication*) self, "app.quit", _tmp8_);
	_tmp8_ = (_vala_array_free (_tmp8_, _tmp8__length1, (GDestroyNotify) g_free), NULL);
	_tmp9_ = gtk_builder_new_from_resource ("/de/hannenz/timr/app_menu.ui");
	builder = _tmp9_;
	_tmp10_ = gtk_builder_get_object (builder, "appmenu");
	_tmp11_ = _g_object_ref0 (G_TYPE_CHECK_INSTANCE_TYPE (_tmp10_, g_menu_model_get_type ()) ? ((GMenuModel*) _tmp10_) : NULL);
	app_menu = _tmp11_;
	gtk_application_set_app_menu ((GtkApplication*) self, app_menu);
	_g_object_unref0 (app_menu);
	_g_object_unref0 (builder);
	_g_object_unref0 (action);
}


static Block1Data* block1_data_ref (Block1Data* _data1_) {
	g_atomic_int_inc (&_data1_->_ref_count_);
	return _data1_;
}


static void block1_data_unref (void * _userdata_) {
	Block1Data* _data1_;
	_data1_ = (Block1Data*) _userdata_;
	if (g_atomic_int_dec_and_test (&_data1_->_ref_count_)) {
		TimrTimr* self;
		self = _data1_->self;
		_g_free0 (_data1_->date);
		_g_free0 (_data1_->parent_iter);
		_g_object_unref0 (self);
		g_slice_free (Block1Data, _data1_);
	}
}


static GtkTreeIter* _gtk_tree_iter_dup (GtkTreeIter* self) {
	GtkTreeIter* dup;
	dup = g_new0 (GtkTreeIter, 1);
	memcpy (dup, self, sizeof (GtkTreeIter));
	return dup;
}


static gpointer __gtk_tree_iter_dup0 (gpointer self) {
	return self ? _gtk_tree_iter_dup (self) : NULL;
}


static gboolean __lambda8_ (Block1Data* _data1_, GtkTreeModel* model, GtkTreePath* path, GtkTreeIter* iter) {
	TimrTimr* self;
	gboolean result = FALSE;
	gchar* d = NULL;
	GtkTreeModel* _tmp0_ = NULL;
	GtkTreeIter _tmp1_ = {0};
	const gchar* _tmp2_ = NULL;
	const gchar* _tmp3_ = NULL;
	self = _data1_->self;
	g_return_val_if_fail (model != NULL, FALSE);
	g_return_val_if_fail (path != NULL, FALSE);
	g_return_val_if_fail (iter != NULL, FALSE);
	_tmp0_ = model;
	_tmp1_ = *iter;
	gtk_tree_model_get (_tmp0_, &_tmp1_, 10, &d, -1);
	_tmp2_ = _data1_->date;
	_tmp3_ = d;
	if (g_strcmp0 (_tmp2_, _tmp3_) == 0) {
		GtkTreeModel* _tmp4_ = NULL;
		GtkTreeIter _tmp5_ = {0};
		GtkTreeIter _tmp6_ = {0};
		gboolean _tmp7_ = FALSE;
		GtkTreeIter _tmp8_ = {0};
		GtkTreeIter* _tmp9_ = NULL;
		_tmp4_ = model;
		_tmp5_ = *iter;
		_tmp7_ = gtk_tree_model_iter_parent (_tmp4_, &_tmp6_, &_tmp5_);
		_g_free0 (_data1_->parent_iter);
		_tmp8_ = _tmp6_;
		_tmp9_ = __gtk_tree_iter_dup0 (&_tmp8_);
		_data1_->parent_iter = _tmp9_;
		if (_tmp7_) {
			result = TRUE;
			_g_free0 (d);
			return result;
		}
	}
	result = FALSE;
	_g_free0 (d);
	return result;
}


static gboolean ___lambda8__gtk_tree_model_foreach_func (GtkTreeModel* model, GtkTreePath* path, GtkTreeIter* iter, gpointer self) {
	gboolean result;
	result = __lambda8_ (self, model, path, iter);
	return result;
}


gboolean timr_timr_insert_activity (TimrTimr* self, TimrActivity* activity, gint id) {
	gboolean result = FALSE;
	Block1Data* _data1_;
	GtkTreeIter* iter = NULL;
	TimrActivity* _tmp0_ = NULL;
	gchar* _tmp1_ = NULL;
	TimrApplicationWindow* _tmp2_ = NULL;
	GtkTreeStore* _tmp3_ = NULL;
	GtkTreeIter* _tmp4_ = NULL;
	TimrApplicationWindow* _tmp33_ = NULL;
	GtkTreeStore* _tmp34_ = NULL;
	GtkTreeIter* _tmp35_ = NULL;
	GtkTreeIter _tmp36_ = {0};
	GtkTreeIter _tmp37_ = {0};
	GtkTreeIter* _tmp38_ = NULL;
	TimrApplicationWindow* _tmp39_ = NULL;
	GtkTreeStore* _tmp40_ = NULL;
	gint _tmp41_ = 0;
	TimrActivity* _tmp42_ = NULL;
	const gchar* _tmp43_ = NULL;
	TimrActivity* _tmp44_ = NULL;
	gint _tmp45_ = 0;
	TimrActivity* _tmp46_ = NULL;
	gint _tmp47_ = 0;
	TimrActivity* _tmp48_ = NULL;
	gchar* _tmp49_ = NULL;
	gchar* _tmp50_ = NULL;
	TimrActivity* _tmp51_ = NULL;
	gchar* _tmp52_ = NULL;
	gchar* _tmp53_ = NULL;
	TimrActivity* _tmp54_ = NULL;
	const gchar* _tmp55_ = NULL;
	const gchar* _tmp56_ = NULL;
	TimrActivity* _tmp57_ = NULL;
	const gchar* _tmp58_ = NULL;
	GtkTreeIter _tmp59_ = {0};
	g_return_val_if_fail (self != NULL, FALSE);
	g_return_val_if_fail (activity != NULL, FALSE);
	_data1_ = g_slice_new0 (Block1Data);
	_data1_->_ref_count_ = 1;
	_data1_->self = g_object_ref (self);
	_tmp0_ = activity;
	_tmp1_ = timr_activity_get_date (_tmp0_);
	_data1_->date = _tmp1_;
	_g_free0 (_data1_->parent_iter);
	_data1_->parent_iter = NULL;
	_tmp2_ = self->priv->window;
	_tmp3_ = _tmp2_->activities;
	gtk_tree_model_foreach ((GtkTreeModel*) _tmp3_, ___lambda8__gtk_tree_model_foreach_func, _data1_);
	_tmp4_ = _data1_->parent_iter;
	if (_tmp4_ == NULL) {
		TimrApplicationWindow* _tmp5_ = NULL;
		GtkTreeStore* _tmp6_ = NULL;
		GtkTreeIter _tmp7_ = {0};
		GtkTreeIter _tmp8_ = {0};
		GtkTreeIter* _tmp9_ = NULL;
		TimrApplicationWindow* _tmp10_ = NULL;
		GtkTreeStore* _tmp11_ = NULL;
		GtkTreeIter* _tmp12_ = NULL;
		TimrActivity* _tmp13_ = NULL;
		GDateTime* _tmp14_ = NULL;
		GDateTime* _tmp15_ = NULL;
		gchar* _tmp16_ = NULL;
		gchar* _tmp17_ = NULL;
		gchar* _tmp18_ = NULL;
		gchar* _tmp19_ = NULL;
		gchar* _tmp20_ = NULL;
		gchar* _tmp21_ = NULL;
		const gchar* _tmp22_ = NULL;
		TimrActivity* _tmp23_ = NULL;
		GDateTime* _tmp24_ = NULL;
		GDateTime* _tmp25_ = NULL;
		gchar* _tmp26_ = NULL;
		gchar* _tmp27_ = NULL;
		gchar* _tmp28_ = NULL;
		gchar* _tmp29_ = NULL;
		gchar* _tmp30_ = NULL;
		gchar* _tmp31_ = NULL;
		GtkTreeIter _tmp32_ = {0};
		_tmp5_ = self->priv->window;
		_tmp6_ = _tmp5_->activities;
		gtk_tree_store_prepend (_tmp6_, &_tmp7_, NULL);
		_g_free0 (_data1_->parent_iter);
		_tmp8_ = _tmp7_;
		_tmp9_ = __gtk_tree_iter_dup0 (&_tmp8_);
		_data1_->parent_iter = _tmp9_;
		_tmp10_ = self->priv->window;
		_tmp11_ = _tmp10_->activities;
		_tmp12_ = _data1_->parent_iter;
		_tmp13_ = activity;
		_tmp14_ = timr_activity_get_begin (_tmp13_);
		_tmp15_ = _tmp14_;
		_tmp16_ = timr_timr_nice_date (self, _tmp15_);
		_tmp17_ = _tmp16_;
		_tmp18_ = g_strconcat ("<b>", _tmp17_, NULL);
		_tmp19_ = _tmp18_;
		_tmp20_ = g_strconcat (_tmp19_, "</b>", NULL);
		_tmp21_ = _tmp20_;
		_tmp22_ = _data1_->date;
		_tmp23_ = activity;
		_tmp24_ = timr_activity_get_begin (_tmp23_);
		_tmp25_ = _tmp24_;
		_tmp26_ = timr_timr_nice_date (self, _tmp25_);
		_tmp27_ = _tmp26_;
		_tmp28_ = g_strconcat ("<b>", _tmp27_, NULL);
		_tmp29_ = _tmp28_;
		_tmp30_ = g_strconcat (_tmp29_, "</b>", NULL);
		_tmp31_ = _tmp30_;
		_tmp32_ = *_tmp12_;
		gtk_tree_store_set (_tmp11_, &_tmp32_, 0, 0, 1, _tmp21_, 2, 0, 3, "", 4, "", 7, "", 8, "", 10, _tmp22_, 11, _tmp31_, -1);
		_g_free0 (_tmp31_);
		_g_free0 (_tmp29_);
		_g_free0 (_tmp27_);
		_g_date_time_unref0 (_tmp25_);
		_g_free0 (_tmp21_);
		_g_free0 (_tmp19_);
		_g_free0 (_tmp17_);
		_g_date_time_unref0 (_tmp15_);
	}
	_tmp33_ = self->priv->window;
	_tmp34_ = _tmp33_->activities;
	_tmp35_ = _data1_->parent_iter;
	gtk_tree_store_prepend (_tmp34_, &_tmp36_, _tmp35_);
	_g_free0 (iter);
	_tmp37_ = _tmp36_;
	_tmp38_ = __gtk_tree_iter_dup0 (&_tmp37_);
	iter = _tmp38_;
	_tmp39_ = self->priv->window;
	_tmp40_ = _tmp39_->activities;
	_tmp41_ = id;
	_tmp42_ = activity;
	_tmp43_ = _tmp42_->description;
	_tmp44_ = activity;
	_tmp45_ = _tmp44_->job_id;
	_tmp46_ = activity;
	_tmp47_ = timr_activity_get_duration (_tmp46_);
	_tmp48_ = activity;
	_tmp49_ = timr_activity_get_duration_nice (_tmp48_);
	_tmp50_ = _tmp49_;
	_tmp51_ = activity;
	_tmp52_ = timr_activity_get_timespan_formatted (_tmp51_);
	_tmp53_ = _tmp52_;
	_tmp54_ = activity;
	_tmp55_ = _tmp54_->job_name;
	_tmp56_ = _data1_->date;
	_tmp57_ = activity;
	_tmp58_ = _tmp57_->text;
	_tmp59_ = *iter;
	gtk_tree_store_set (_tmp40_, &_tmp59_, 0, _tmp41_, 1, _tmp43_, 2, _tmp45_, 3, _tmp47_, 4, _tmp50_, 7, _tmp53_, 8, _tmp55_, 10, _tmp56_, 11, _tmp58_, -1);
	_g_free0 (_tmp53_);
	_g_free0 (_tmp50_);
	result = TRUE;
	_g_free0 (iter);
	block1_data_unref (_data1_);
	_data1_ = NULL;
	return result;
}


static gchar* timr_timr_nice_date (TimrTimr* self, GDateTime* date) {
	gchar* result = NULL;
	GDateTime* today = NULL;
	GDateTime* _tmp0_ = NULL;
	GDateTime* yesterday = NULL;
	GDateTime* _tmp1_ = NULL;
	GDateTime* _tmp2_ = NULL;
	gboolean _tmp3_ = FALSE;
	gboolean _tmp4_ = FALSE;
	GDateTime* _tmp5_ = NULL;
	gint _tmp6_ = 0;
	GDateTime* _tmp7_ = NULL;
	gint _tmp8_ = 0;
	gboolean _tmp18_ = FALSE;
	gboolean _tmp19_ = FALSE;
	GDateTime* _tmp20_ = NULL;
	gint _tmp21_ = 0;
	GDateTime* _tmp22_ = NULL;
	gint _tmp23_ = 0;
	GDateTime* _tmp33_ = NULL;
	gchar* _tmp34_ = NULL;
	g_return_val_if_fail (self != NULL, NULL);
	g_return_val_if_fail (date != NULL, NULL);
	_tmp0_ = g_date_time_new_now_local ();
	today = _tmp0_;
	_tmp1_ = today;
	_tmp2_ = g_date_time_add_days (_tmp1_, -1);
	yesterday = _tmp2_;
	_tmp5_ = today;
	_tmp6_ = g_date_time_get_year (_tmp5_);
	_tmp7_ = date;
	_tmp8_ = g_date_time_get_year (_tmp7_);
	if (_tmp6_ == _tmp8_) {
		GDateTime* _tmp9_ = NULL;
		gint _tmp10_ = 0;
		GDateTime* _tmp11_ = NULL;
		gint _tmp12_ = 0;
		_tmp9_ = today;
		_tmp10_ = g_date_time_get_month (_tmp9_);
		_tmp11_ = date;
		_tmp12_ = g_date_time_get_month (_tmp11_);
		_tmp4_ = _tmp10_ == _tmp12_;
	} else {
		_tmp4_ = FALSE;
	}
	if (_tmp4_) {
		GDateTime* _tmp13_ = NULL;
		gint _tmp14_ = 0;
		GDateTime* _tmp15_ = NULL;
		gint _tmp16_ = 0;
		_tmp13_ = today;
		_tmp14_ = g_date_time_get_day_of_month (_tmp13_);
		_tmp15_ = date;
		_tmp16_ = g_date_time_get_day_of_month (_tmp15_);
		_tmp3_ = _tmp14_ == _tmp16_;
	} else {
		_tmp3_ = FALSE;
	}
	if (_tmp3_) {
		gchar* _tmp17_ = NULL;
		_tmp17_ = g_strdup ("Today");
		result = _tmp17_;
		_g_date_time_unref0 (yesterday);
		_g_date_time_unref0 (today);
		return result;
	}
	_tmp20_ = yesterday;
	_tmp21_ = g_date_time_get_year (_tmp20_);
	_tmp22_ = date;
	_tmp23_ = g_date_time_get_year (_tmp22_);
	if (_tmp21_ == _tmp23_) {
		GDateTime* _tmp24_ = NULL;
		gint _tmp25_ = 0;
		GDateTime* _tmp26_ = NULL;
		gint _tmp27_ = 0;
		_tmp24_ = yesterday;
		_tmp25_ = g_date_time_get_month (_tmp24_);
		_tmp26_ = date;
		_tmp27_ = g_date_time_get_month (_tmp26_);
		_tmp19_ = _tmp25_ == _tmp27_;
	} else {
		_tmp19_ = FALSE;
	}
	if (_tmp19_) {
		GDateTime* _tmp28_ = NULL;
		gint _tmp29_ = 0;
		GDateTime* _tmp30_ = NULL;
		gint _tmp31_ = 0;
		_tmp28_ = yesterday;
		_tmp29_ = g_date_time_get_day_of_month (_tmp28_);
		_tmp30_ = date;
		_tmp31_ = g_date_time_get_day_of_month (_tmp30_);
		_tmp18_ = _tmp29_ == _tmp31_;
	} else {
		_tmp18_ = FALSE;
	}
	if (_tmp18_) {
		gchar* _tmp32_ = NULL;
		_tmp32_ = g_strdup ("Yesterday");
		result = _tmp32_;
		_g_date_time_unref0 (yesterday);
		_g_date_time_unref0 (today);
		return result;
	}
	_tmp33_ = date;
	_tmp34_ = g_date_time_format (_tmp33_, "%a, %d. %B %Y");
	result = _tmp34_;
	_g_date_time_unref0 (yesterday);
	_g_date_time_unref0 (today);
	return result;
}


static void timr_timr_class_init (TimrTimrClass * klass) {
	timr_timr_parent_class = g_type_class_peek_parent (klass);
	g_type_class_add_private (klass, sizeof (TimrTimrPrivate));
	((GApplicationClass *) klass)->activate = timr_timr_real_activate;
	((GApplicationClass *) klass)->startup = timr_timr_real_startup;
	G_OBJECT_CLASS (klass)->finalize = timr_timr_finalize;
}


static void timr_timr_instance_init (TimrTimr * self) {
	self->priv = TIMR_TIMR_GET_PRIVATE (self);
}


static void timr_timr_finalize (GObject* obj) {
	TimrTimr * self;
	self = G_TYPE_CHECK_INSTANCE_CAST (obj, TIMR_TYPE_TIMR, TimrTimr);
	_g_object_unref0 (self->priv->window);
	_timr_repository_unref0 (self->priv->repository);
	_sqlite3_close0 (self->db);
	G_OBJECT_CLASS (timr_timr_parent_class)->finalize (obj);
}


GType timr_timr_get_type (void) {
	static volatile gsize timr_timr_type_id__volatile = 0;
	if (g_once_init_enter (&timr_timr_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (TimrTimrClass), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) timr_timr_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (TimrTimr), 0, (GInstanceInitFunc) timr_timr_instance_init, NULL };
		GType timr_timr_type_id;
		timr_timr_type_id = g_type_register_static (gtk_application_get_type (), "TimrTimr", &g_define_type_info, 0);
		g_once_init_leave (&timr_timr_type_id__volatile, timr_timr_type_id);
	}
	return timr_timr_type_id__volatile;
}


static void _vala_array_destroy (gpointer array, gint array_length, GDestroyNotify destroy_func) {
	if ((array != NULL) && (destroy_func != NULL)) {
		int i;
		for (i = 0; i < array_length; i = i + 1) {
			if (((gpointer*) array)[i] != NULL) {
				destroy_func (((gpointer*) array)[i]);
			}
		}
	}
}


static void _vala_array_free (gpointer array, gint array_length, GDestroyNotify destroy_func) {
	_vala_array_destroy (array, array_length, destroy_func);
	g_free (array);
}



