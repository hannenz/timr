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

				stdout.printf("%s\n", query);

				string error_message;
				int ec = this.db.exec(query, null, out error_message);
				if (ec != Sqlite.OK){
					stderr.printf("Error: %s\n", error_message);
				}

			});

			load_data();
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
			query = "SELECT * FROM clients";
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

				stdout.printf("Iterating client: %s\n", client_name);

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
			query = "SELECT a.id,a.description,a.job_id,a.begin,a.end,j.name,j.abbrev,c.name,c.abbrev FROM activities AS a LEFT JOIN jobs AS j ON j.id=a.job_id LEFT JOIN clients AS c ON c.id=j.client_id ORDER By a.begin DESC";
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
						activity.job_name = (job_id > 0) ? "<b>%s</b> %s".printf(stmt.column_text(6), stmt.column_text(5)) : "Unknown job";

						stdout.printf("Timespan formatted: %s\n", activity.get_timespan_formatted());

						window.activities.append(out iter);
						window.activities.set(iter,
							0, id,
							1, activity.description,
							2, job_id,
							3, activity.get_duration(),
							4, activity.get_duration_nice(),
							7, activity.get_timespan_formatted(),
							8, activity.job_name
						);
						break;
					default:
						stderr.printf("Error:%d: %s\n", ec, db.errmsg());
						break;
				}
			} while (ec == Sqlite.ROW);

			return true;
		}
	}
}