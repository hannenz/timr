using Gtk;
using Sqlite;

namespace Timr {

	public class Timr : Gtk.Application {

		private ApplicationWindow window;

		/* This should be private, but alas... */
		public Repository repository;

		public Timr() {
			application_id = "de.hannenz.timr";
		}

		public override void activate() {

			this.repository = new Repository("/home/hannenz/timr/data/timr.db");

			window = new ApplicationWindow(this);
			window.present();

			// Get rid of this!
			// window.update_database.connect( (query) => {
			// 	this.repository.query (query);
			// });

			window.activity_stopped.connect( (activity) => {

				this.repository.save_activity(activity);
				insert_activity (activity);
			});

			load_data ();

			window.activities_treeview.expand_row (new TreePath.first (), true);
			//window.activities_treeview.expand_all();
		}

		private void load_data () {

			var activities = this.repository.get_all_activities ();
			foreach (var activity in activities) {
				this.insert_activity (activity);
			}

			var clients = this.repository.get_all_clients ();
			foreach (var client in clients) {
				Gtk.TreeIter? iter, parent_iter = null;
				window.clients_jobs.append (out parent_iter, null);
				window.clients_jobs.set (parent_iter, 0, client, 1, client.name, 2, client.abbrev, 3, client.name);

				var jobs = this.repository.get_jobs_by_client (client.id);
				foreach (var job in jobs) {
					window.clients_jobs.append (out iter, parent_iter);
					window.clients_jobs.set (iter, 0, job, 1, job.name, 2, job.abbrev, 3, "<b>%s</b> %s".printf (job.abbrev, job.name));
				}
			}
		}

		private void preferences () { 
			// IMPLEMENT ME!
		}

		public override void startup () {
			base.startup();

			var action = new GLib.SimpleAction ("preferences", null);
			action.activate.connect(preferences);
			add_action (action);

			action = new GLib.SimpleAction ("quit", null);
			action.activate.connect (quit);
			add_action (action);
			set_accels_for_action("app.quit", {"<Ctrl>Q"} );

			action = new GLib.SimpleAction ("delete_activity", null);
			action.activate.connect (delete_activity);
			add_action (action);
			set_accels_for_action ("app.delete_activity", {"<Ctrl>D"});

			var builder = new Gtk.Builder.from_resource ("/de/hannenz/timr/app_menu.ui");
			var app_menu = builder.get_object ("appmenu") as GLib.MenuModel;
			set_app_menu (app_menu);
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
	}
}