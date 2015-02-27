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

			window.client_edited.connect( (query) => {
				string errmsg;
				int ec;
				if ((ec = db.exec(query, null, out errmsg)) != Sqlite.OK){
					stderr.printf("Error while writing client record: %d: %s\n", ec, errmsg);
				}
			});

			load_data();
		}

		private bool load_data() {

			Statement stmt;
			int ec, col, cols;
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
						
						window.clients.append(out iter);
						window.clients.set(iter, 0, id, 1, name, 2, abbrev);

						break;

					default:
						stderr.printf("Error: %d: %s\n", ec, db.errmsg());
						break;

				}
			}while (ec == Sqlite.ROW);

			// Read jobs from db;
			query = "SELECT * FROM jobs";
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
						int client_id = stmt.column_int(3);
						
						window.jobs.append(out iter);
						window.jobs.set(iter, 0, id, 1, name, 2, abbrev, 3, client_id, 4, "<b>%s</b> %s".printf(abbrev, name));
						break;

					default:
						stderr.printf("Error: %d: %s\n", ec, db.errmsg());
						break;

				}
			}while (ec == Sqlite.ROW);

			// Read activities from db;
			query = "SELECT a.id,a.description,a.job_id,a.begin,a.end,j.name,j.abbrev,c.name,c.abbrev FROM activities AS a LEFT JOIN jobs AS j ON j.id=a.job_id LEFT JOIN clients AS c ON c.id=j.client_id";
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

						Activity activity = new Activity.past(description, new DateTime.from_string(begin_str).get_datetime(), new DateTime.from_string(end_str).get_datetime());

						window.activities.append(out iter);
						window.activities.set(iter,
							0, id,
							1, description,
							2, job_id,
							3, activity.get_duration(),
							4, activity.get_duration_nice()
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