using Gtk;
using Sqlite;

namespace Timr {

	public class Timr : Gtk.Application {

		private ApplicationWindow window;

		private Repository repository;

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

				string query = "INSERT INTO activities (description,job_id,begin,end) VALUES ('%s', %u, '%s', '%s')".printf(
					activity.description,
					activity.job_id,
					activity.get_begin_datetime(),
					activity.get_end_datetime()
				);

				string error_message;
				int ec = this.db.exec(query, null, out error_message);
				if (ec != Sqlite.OK){
					this.window.error ("Error: " + error_message);
				}

				insert_activity (activity, (int) db.last_insert_rowid ());
			});

			load_data ();

			window.activities_treeview.expand_row (new TreePath.first (), true);
		}

		private bool load_data() {

			List<Client>clients = this.repository.get_all_clients ();

			foreach (unowned Client c in clients) {
				debug (c.get_name());
			}

			return true;
		}

		private void preferences () { 

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


		public bool insert_activity(Activity activity, int id) {

			Gtk.TreeIter? iter, parent_iter;
			var date = activity.get_date();

			parent_iter = null;
			window.activities.foreach( (model, path, iter) => {
				string d;
				model.get(iter, 10, out d);
				if (date == d){
					if (model.iter_parent(out parent_iter, iter)){
						return true;
					}
				}
				return false;
			});

			if (parent_iter == null) {
				window.activities.prepend(out parent_iter, null);
				window.activities.set(parent_iter, 
					0, 0,
					1, "<b>" + nice_date(activity.get_begin()) + "</b>",
					2, 0,
					3, "",
					4, "",
					7, "",
					8, "",
					10, date,
					11, "<b>" + nice_date(activity.get_begin()) + "</b>"
				);
			}

			window.activities.prepend(out iter, parent_iter);
			window.activities.set(iter,
				0, id,
				1, activity.description,
				2, activity.job_id,
				3, activity.get_duration(),
				4, activity.get_duration_nice(),
				7, activity.get_timespan_formatted(),
				8, activity.job_name,
				10, date,
				11, activity.text
			);

			return true;
		}

		private string nice_date(GLib.DateTime date) {
			var today = new GLib.DateTime.now_local();
			var yesterday = today.add_days(-1);

			if (
				today.get_year() == date.get_year() &&
				today.get_month() == date.get_month() &&
				today.get_day_of_month() == date.get_day_of_month()
			)
			{
				return "Today";
			}
			if (
				yesterday.get_year() == date.get_year() &&
				yesterday.get_month() == date.get_month() &&
				yesterday.get_day_of_month() == date.get_day_of_month()
			)
			{
				return "Yesterday";
			}

			return date.format("%a, %d. %B %Y");

		}
	}
}