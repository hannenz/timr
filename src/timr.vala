using Gtk;
using Sqlite;

namespace Timr {

	public class Timr : Gtk.Application {

		private ApplicationWindow window;

		public Sqlite.Database db;

		public Timr() {
			application_id = "de.hannenz.timr";
		}

		public override void activate() {
			window = new ApplicationWindow(this);
			window.present();

			window.update_database.connect( (query) => {

				int rc;
				string error_message;

				if ((rc = db.exec(query, null, out error_message)) != Sqlite.OK){
					stderr.printf("Error while executing Sqlite query: %d: %s\n", rc, error_message);

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
					stderr.printf("Error: %s\n", error_message);
				}

				insert_activity(activity, (int)db.last_insert_rowid());

			});

			load_data();

			window.activities_treeview.expand_row(new TreePath.first(), true);
		}

		private bool load_data() {

			Statement stmt;
			int ec, cols;
			Gtk.TreeIter iter;
			string query = "";

			ec = Sqlite.Database.open("/home/hannenz/timr/data/timr.db", out this.db);
			if (ec != Sqlite.OK){
				stderr.printf("Could not open database:%d: %s\n", db.errcode(), db.errmsg());
				return false;
			}

			// Read clients from db;
			query = "SELECT * FROM clients ORDER BY name ASC";
			if ((ec = db.prepare_v2(query, -1, out stmt, null)) == 1){
				stderr.printf("Could not read clients from database: %d: %s\n", ec, db.errmsg());
				return false;
			}

			cols = stmt.column_count();
			do {
				ec = stmt.step();
				switch (ec){
					case Sqlite.DONE:
						break;
					case Sqlite.ROW:

						int id = stmt.column_int(0);
						string name = stmt.column_text(1);
						string abbrev = stmt.column_text(2);
						
						window.clients_jobs.append(out iter, null);
						window.clients_jobs.set(iter,
							0, id,
							1, name,
							2, abbrev,
							3, name
						);

						break;

					default:
						stderr.printf("Error: %d: %s\n", ec, db.errmsg());
						break;

				}
			} while (ec == Sqlite.ROW);

			window.clients_jobs.foreach( (model, path, parent_iter) => {

				if (window.clients_jobs.iter_depth(parent_iter) > 0){
					return false;
				}

				int client_id; string client_name;
				Gtk.TreeIter child_iter;
				model.get(parent_iter, 0, out client_id, 1, out client_name);

				string query2 = "SELECT * FROM jobs WHERE client_id=%u order by abbrev".printf(client_id);
				if ((ec = db.prepare_v2(query2, -1, out stmt, null)) == 1){
					stderr.printf("Could not read clients from database: %d: %s\n", ec, db.errmsg());
					return false;
				}

				cols = stmt.column_count();
				do {
					ec = stmt.step();
					switch (ec){
						case Sqlite.DONE:
							break;
						case Sqlite.ROW:

							int id = stmt.column_int(0);
							string name = stmt.column_text(1);
							string abbrev = stmt.column_text(2);
							
							window.clients_jobs.append(out child_iter, parent_iter);
							window.clients_jobs.set(child_iter,
								0, id,
								1, name,
								2, abbrev,
								3, "<b>%s</b> %s".printf(abbrev, name)
							);
							break;

						default:
							stderr.printf("Error: %d: %s\n", ec, db.errmsg());
							break;

					}
				}while (ec == Sqlite.ROW);

				return false;
			});

			// Read activities from db;
			query = "SELECT a.id,a.description,a.job_id,a.begin,a.end,j.name,j.abbrev,c.name,c.abbrev FROM activities AS a LEFT JOIN jobs AS j ON j.id=a.job_id LEFT JOIN clients AS c ON c.id=j.client_id ORDER By a.begin ASC";
			if ((ec = db.prepare_v2(query, -1, out stmt, null)) == 1){
				stderr.printf("Could not read activities from database:%d: %s\n", ec, db.errmsg());
				return false;
			}

			cols = stmt.column_count();
			do {
				ec = stmt.step();
				switch (ec){
					case Sqlite.DONE:
						break;
					case Sqlite.ROW:

						int id = stmt.column_int(0);
						string description = stmt.column_text(1);
						int job_id = stmt.column_int(2);
						string begin_str = stmt.column_text(3);
						string end_str = stmt.column_text(4);

						var regex = /[\-\: ]/;
						var date_parts = regex.split(begin_str);
						GLib.DateTime begin = new GLib.DateTime.local(
							int.parse(date_parts[0]),
							int.parse(date_parts[1]),
							int.parse(date_parts[2]),
							int.parse(date_parts[3]),
							int.parse(date_parts[4]),
							int.parse(date_parts[5])
						);
						date_parts = regex.split(end_str);
						GLib.DateTime end = new GLib.DateTime.local(
							int.parse(date_parts[0]),
							int.parse(date_parts[1]),
							int.parse(date_parts[2]),
							int.parse(date_parts[3]),
							int.parse(date_parts[4]),
							int.parse(date_parts[5])
						);


						Activity activity = new Activity.past(description.length > 0 ? description : "Unknown activity", begin, end);
						activity.job_id = job_id;

						// FIXME: Move this into activity constructor ?
						activity.job_name = (job_id > 0) ? "<b>%s %s</b>".printf(stmt.column_text(6), stmt.column_text(5)) : "<b>Unknown job</b>";
						activity.text = activity.job_name + "\n" + stmt.column_text(1);

						insert_activity(activity, id);
						break;

					default:
						stderr.printf("Error:%d: %s\n", ec, db.errmsg());
						break;
				}
			} while (ec == Sqlite.ROW);

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