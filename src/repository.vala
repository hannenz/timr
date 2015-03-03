using Gtk;
using Sqlite;

namespace Timr {

	public class Repository {

		private Sqlite.Database db;

		public Repository (string db_filename) {

			int r;

			r = Database.open (db_filename, out this.db);
			if (r != Sqlite.OK){
				stderr.printf ("Error while connecting to database: %d: %s", r, db.errmsg ());
			}
		}

		public List<Client>? get_all_clients () {
			List<Client> clients = new List<Client>();

			var query = "SELECT * FROM clients ORDER BY name asc";
			int r = db.exec (query, (n_columns, values, column_names) => {
				var client = new Client(int.parse(values[0]), values[1], values[2]);
				clients.append(client);
				return 0;
			});
			if (r != Sqlite.OK){
				return null;
			}
			return clients.copy();
		}

		public List<Job> get_all_jobs () {
			List<Job> jobs = new List<Job>();
			return jobs;
		}

		public Client get_client (int client_id) {
			Client client = new Client (1, "foo", "bar");
			// string error_message;
			// string query = "SELECT id,name,abbrev FROM clients WHERE id=%u".printf(client_id);
			// if ((int r = this.db.exec(query, out error_message)) != Sqlite.OK){
			// 	return null;
			// }
			// return new Client(stmt.)
			return client;
		}

		public bool save_client (Client client) {

			return true;
		}

		public Job get_job (int job_id) {
			Job job = new Job (1, "foo", "bar", new Client(1, "foo", "bar"));
			return job;
		}

		public bool save_job (Job job) {

			return true;
			
		}

		public List<Activity> get_all_activities () {

			List<Activity> activities = new List<Activity>();

			// Statement stmt;
			// int r, cols;
			// query = "SELECT a.id,a.description,a.job_id,a.begin,a.end,j.name,j.abbrev,c.name,c.abbrev FROM activities AS a LEFT JOIN jobs AS j ON j.id=a.job_id LEFT JOIN clients AS c ON c.id=j.client_id ORDER By a.begin ASC";
			// r = db.exec(query, (n_columns, values, column_names) => {
			// 	Activity activity;

			// 	for (int i = 0; i < n_columns; i++) {
			// 		if (column_names[i] == "id"){

			// 		}
			// 	}
			// });
			return activities;

		}

	}
	
}