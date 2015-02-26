using Gtk;
using Sqlite;

namespace Timr {
	public class Timr : Gtk.Application {

		private ApplicationWindow window;

		public Sqlite.Database db;

		public Timr() {
			application_id = "de.hannenz.timr";
			// flags |= Glib.ApplicationFlags.HANDLES_OPEN;

		}

		public override void activate() {
			window = new ApplicationWindow(this);
			window.present();
			window.activity_stopped.connect( (activity) => {

				string query = "INSERT INTO activities (description,project,client,start,end) VALUES ('%s', '%s', '%s', '%s', '%s')".printf(
					activity.description,
					activity.project,
					activity.client,
					activity.get_start_datetime(),
					activity.get_end_datetime()
				);

				stdout.printf("%s\n", query);

				string error_message;
				int ec = this.db.exec(query, null, out error_message);
				if (ec != Sqlite.OK){
					stderr.printf("Error: %s\n", error_message);
				}

			});

			// Read activities from db;
			Statement stmt;
			int ec, col, cols;

			ec = Sqlite.Database.open("/home/hannenz/timr/data/timr.db", out this.db);
			if (ec != Sqlite.OK){
				stderr.printf("Could not open database:%d: %s\n", db.errcode(), db.errmsg());
			}


			string query = "SELECT * FROM activities";
			if ((ec = db.prepare_v2(query, -1, out stmt, null)) == 1){
				stderr.printf("Could not open database:%d: %s\n", ec, db.errmsg());
			}

			Gtk.TreeIter iter;

			cols = stmt.column_count();
			do {
				ec = stmt.step();
				switch (ec){
					case Sqlite.DONE:
						break;
					case Sqlite.ROW:

						window.activities.append(out iter);

						for (col = 0; col < cols; col++){
							string txt = stmt.column_text(col);
							stdout.printf("%s\n", txt);

							switch (col){
								case 1:
									window.activities.set(iter, 0, txt);
									break;
								case 2:
									window.activities.set(iter, 1, txt);
									break;
							}
						}

						break;
					default:
						stderr.printf("Error:%d: %s\n", ec, db.errmsg());
						break;
				}
			} while (ec == Sqlite.ROW);
		}
	}
}