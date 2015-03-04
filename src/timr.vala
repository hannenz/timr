using Gtk;
using Sqlite;

namespace Timr {

	public class Timr : Gtk.Application {

		private ApplicationWindow window;

		/* This should be private, but alas... */
		public Repository repository;

		public Sqlite.Database db;

		public Timr() {
			application_id = "de.hannenz.timr";
		}

		public override void activate() {

			this.repository = new Repository("/home/hannenz/timr/data/timr.db");

			window = new ApplicationWindow(this);
			window.present();

			window.update_database.connect( (query) => {

				int rc;
				string error_message;

				if ((rc = db.exec(query, null, out error_message)) != Sqlite.OK){
					this.window.error("Error while executing Sqlite query: %d: %s\n".printf(rc, error_message));
				}
			});

			window.activity_stopped.connect( (activity) => {

				this.repository.save_activity(activity);
				insert_activity (activity);

			});

			load_data ();

			// window.activities_treeview.expand_row (new TreePath.first (), true);
			window.activities_treeview.expand_all();
		}

		private bool load_data() {

			var activities = this.repository.get_all_activities ();
			foreach (var activity in activities) {
				this.insert_activity (activity);
			}

			return true;
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

			var builder = new Gtk.Builder.from_resource ("/de/hannenz/timr/app_menu.ui");
			var app_menu = builder.get_object ("appmenu") as GLib.MenuModel;

			set_app_menu (app_menu);
		}


		public void insert_activity(Activity activity) {

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

				var fake_activity = new Activity();

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