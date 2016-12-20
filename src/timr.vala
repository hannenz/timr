using Gtk;
using Sqlite;
using Gee;

namespace Timr {

	public class Timr : Gtk.Application {

		private ApplicationWindow window;

		protected GLib.MenuModel context_menu_model;

		public Repository repository;

		public Timr() {
			application_id = "de.hannenz.timr";
		}

		public override void activate() {

			window = new ApplicationWindow(this);
			window.present();

			window.activity_stopped.connect( (activity) => {

				this.repository.save_activity(activity);
				insert_activity (activity);
			});

			repository = new Repository ();

			load_data ();

			window.activities_treeview.expand_row (new TreePath.first (), true);

			window.activities_treeview.button_press_event.connect ( (event) => {

				if (event.type == Gdk.EventType.BUTTON_PRESS) {
					if (((Gdk.EventButton)event).button == Gdk.BUTTON_SECONDARY) {
						do_popup_menu (window.activities_treeview, event);
						return true;
					}
				}
				return false;
			});

			window.activities_treeview.popup_menu.connect( (event) => {
				do_popup_menu (window.activities_treeview, null);
				return true;
			});


			print ("Connecting signals\n");

			this.window.reporting_range_from.changed.connect ( update_report );
			this.window.reporting_range_to.changed.connect ( update_report );
		}

		public override void startup () {
			base.startup ();

			var action = new GLib.SimpleAction ("preferences", null);
			action.activate.connect (preferences);
			add_action (action);

			action = new GLib.SimpleAction ("quit", null);
			action.activate.connect (quit);
			add_action (action);
			set_accels_for_action("app.quit", {"<Ctrl>Q"} );

			action = new GLib.SimpleAction ("resume", null);
			action.activate.connect (window.resume_activity);
			add_action (action);
			set_accels_for_action ("app.resume", {"<Ctrl>R"});

			action = new GLib.SimpleAction ("delete", null);
			action.activate.connect (delete_activity);
			add_action (action);
			set_accels_for_action ("app.delete", {"Delete"});

			action = new GLib.SimpleAction("add_activity", null);
			action.activate.connect (add_activity);
			add_action (action);

			action = new GLib.SimpleAction("add_client", null);
			action.activate.connect (add_client);
			add_action (action);

			action = new GLib.SimpleAction("add_job", null);
			action.activate.connect (add_job);
			add_action (action);

			var builder = new Gtk.Builder.from_resource ("/de/hannenz/timr/app_menu.ui");
			var app_menu = builder.get_object ("appmenu") as GLib.MenuModel;
			set_app_menu (app_menu);

			context_menu_model = builder.get_object ("context_menu_model") as GLib.MenuModel;
		}

		public void add_activity () {
			this.window.on_activity_add_button_clicked (null);
		}

		public void add_client () {
			this.window.on_add_client_button_clicked ();
		}

		public void add_job () {
			this.window.on_add_job_button_clicked ();
		}

		private void do_popup_menu (Widget widget, Gdk.EventButton? event) {

			uint button, time;
			Gtk.Menu menu = new Gtk.Menu.from_model (context_menu_model);
			menu.attach_to_widget(widget, null);

			if (event != null) {
				button = event.button;
				time = event.time;
			}
			else {
				button = 0;
				time = Gtk.get_current_event_time ();
			}

			menu.popup(null, null, null, button, time);
		}

		private void load_data () {

			var activities = this.repository.get_all_activities ();
			foreach (var activity in activities) {
				this.insert_activity (activity);
			}

			var clients = this.repository.get_all_clients ();
			foreach (var client in clients) {
				Gtk.TreeIter? iter, parent_iter = null;

				window.clients.append (out iter);
				window.clients.set(iter, 0, client, 1, client.name, 2, client.abbrev, 3, "%s %s".printf(client.abbrev, client.name));

				window.clients_jobs.append (out parent_iter, null);
				window.clients_jobs.set (parent_iter, 0, client, 1, client.name, 2, client.abbrev, 3, client.name);

				var jobs = this.repository.get_jobs_by_client (client.id);
				foreach (var job in jobs) {
					window.clients_jobs.append (out iter, parent_iter);
					window.clients_jobs.set (iter, 0, job, 1, job.name, 2, job.abbrev, 3, "<b>%s</b> %s".printf (job.abbrev, job.name));
				}
			}

			var categories = repository.get_all_categories ();
			foreach (var category in categories) {
				Gtk.TreeIter iter;
				window.categories.append(out iter);
				window.categories.set(iter, 0, category, 1, category.name, 2, category.abbrev);
			}
		}

		private void preferences () { 
			// IMPLEMENT ME!
		}


		public void delete_activity () {
			TreeModel model;
			TreeIter iter;
			Activity activity;

			window.activities_treeview.get_selection ().get_selected (out model, out iter);
			model.get(iter, 0, out activity);
			if (repository.delete_activity (activity)) {
				// Get the parent iter before removing	
				TreeIter parent_iter;
				window.activities.iter_parent (out parent_iter, iter);
				
				window.activities.remove (ref iter);
				// If removing the last child iter will be invalidated, so we check for that
				if (!window.activities.iter_is_valid (iter)) {
					// If iter is invalid (last child has been removed), we remove the parent as well
					window.activities.remove (ref parent_iter);
				}
			}
		}

		/**
		 * Check for overlapping timespans
		 */
		public bool check_insert_activity (Activity activity) {

			bool flag = true;
			uint64 d0begin = activity.begin.to_unix ();
			uint64 d0end = activity.end.to_unix ();

			window.activities.foreach ( (model, path, iter) => {

				Activity a;
				model.get (iter, 0, out a);

				if (a is Activity) {

					a.debug ();

					uint64 d1begin = a.begin.to_unix ();
					uint64 d1end = a.end.to_unix ();

					if ( (d0begin > d1begin && d0begin < d1end) || (d0end > d1begin && d0end < d1end)) {
						flag = false;
						return true;
					}
				}
				return false;
			});

			return flag;
		}


		public void insert_activity(Activity activity) requires (activity is Activity) {

			// TODO: We need to insert SORTED!! (by date)

			Gtk.TreeIter? iter, parent_iter;
			var date = activity.get_date();

			iter = null;
			parent_iter = null;
			window.activities.foreach( (model, path, iter) => {

				string d;
				model.get (iter, 4, out d);

				if (date == d) {

					if (model.iter_parent (out parent_iter, iter)){
						return true;
					}
				}
				return false;
			});

			if (parent_iter == null) {

				window.activities.prepend (out parent_iter, null);
				window.activities.set (parent_iter, 
					0, null,
					1, "<b>" + nice_date (activity.begin) + "</b>",
					2, "",
					3, "",
					4, date
				);
			}

			window.activities.prepend (out iter, parent_iter);
			window.activities.set (iter,
				0, activity,
				1, activity.get_summary (),
				2, activity.get_duration_nice (),
				3, activity.get_timespan_formatted (),
				4, date
			);
		}

		private string nice_date (GLib.DateTime date) {

			var today = new GLib.DateTime.now_local ();
			var yesterday = today.add_days (-1);

			if (
				today.get_year () == date.get_year () &&
				today.get_month () == date.get_month () &&
				today.get_day_of_month () == date.get_day_of_month ()
			)
			{
				return "Today";
			}
			if (
				yesterday.get_year () == date.get_year () &&
				yesterday.get_month () == date.get_month () &&
				yesterday.get_day_of_month () == date.get_day_of_month ()
			)
			{
				return "Yesterday";
			}

			return date.format ("%a, %d. %B %Y");
		}

		protected void update_report () {

			print ("Updating report from %s to %s\n", this.window.reporting_range_from.date.to_string (), this.window.reporting_range_to.date.to_string ());

			var map = new Gee.HashMap<string, int> ();

			window.activities.foreach ( (model, path, iter) => {
					Activity activity;
					model.get(iter, 0, out activity);

					if (activity != null) {

						var duration = activity.get_duration ();

						if (activity.job.abbrev in map) {
							duration += map[activity.job.abbrev];
						}

						map.set(activity.job.abbrev, duration);

					}
					return false;
				});

			foreach (string job in map.keys) {
				stdout.printf("%-12s %02u:%02u hrs.\n", job, map[job] / 3600, map[job] % 3600);
			}
		}
	}
}