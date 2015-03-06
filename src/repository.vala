using Gtk;
using Sqlite;
using Gee;

namespace Timr {

	public class Repository {

		private Sqlite.Database db;

		protected string table_name;

		protected string[] fields;

		protected string order_by;

		protected string order_dir;

		private string db_filename = "/home/hannenz/timr/data/timr.db";

		public Repository () {

			// IMPLEMENT ME: If file does not exist, create it and create all tables from schema

			int r = Database.open (db_filename, out this.db);
			if (r != Sqlite.OK){
				stderr.printf ("Error while connecting to database: %d: %s", r, db.errmsg ());
			}
		}

		public ArrayList<Client>? get_all_clients () {
			ArrayList<Client> clients = new ArrayList<Client>();

			var query = "SELECT `id`,`name`,`abbrev` FROM `clients` ORDER BY `name` ASC";
			int r = db.exec (query, (n_columns, values, column_names) => {
				var client = new Client(int.parse(values[0]), values[1], values[2]);
				clients.add(client);
				return 0;
			});
			if (r != Sqlite.OK){
				return null;
			}

			return clients;
		}

		public ArrayList<Job>? get_all_jobs () {
			ArrayList<Job> jobs = new ArrayList<Job>();

			var query = "SELECT `id`,`name`,`abbrev`,`client_id` FROM `jobs` ORDER BY `abbrev` ASC";
			int r = db.exec (query, (n, values, names) => {
				var job = new Job (int.parse(values[0]), values[1], values[2], this.get_client (int.parse(values[3])));
				jobs.add(job);
				return 0;
			});
			if (r != Sqlite.OK){
				return null;
			}

			return jobs;
		}

		public ArrayList<Job>? get_jobs_by_client (int client_id) {
			ArrayList<Job> jobs = new ArrayList<Job>();

			var query = "SELECT `id`,`name`,`abbrev`,`client_id` FROM `jobs` WHERE `client_id`=%u ORDER BY `abbrev` ASC".printf (client_id);
			int r = db.exec (query, (n, values, names) => {
				var job = new Job (int.parse(values[0]), values[1], values[2], this.get_client (int.parse(values[3])));
				jobs.add(job);
				return 0;
			});
			if (r != Sqlite.OK){
				return null;
			}
			return jobs;
		}

		public Client? get_client (int client_id) {
			Client client = null;
			string query = "SELECT `id`,`name`,`abbrev` FROM `clients` WHERE `id`=%u".printf (client_id);
			db.exec (query, (n, values, names) => {
				client = new Client (int.parse (values[0]), values[1], values[2]);
				return 1;
			});
			return client;
		}

		public bool save_client (Client client) {

			string query = (client.id > 0) 
				? "UPDATE `clients` SET `name`='%s',`abbrev`='%s' WHERE `id`=%u".printf (client.name, client.abbrev, client.id)
				: "INSERT INTO `clients` (`name`, `abbrev`) VALUES ('%s','%s')".printf (client.name, client.abbrev)
			;
			return (db.exec (query) == Sqlite.OK);
		}

		public Job? get_job (int job_id) {
			Job job = null;
			string query = "SELECT `id`,`name`,`abbrev`,`client_id` FROM `jobs` WHERE `id`=%u".printf (job_id);
			db.exec (query, (n, values, names) => {
				job = new Job (int.parse (values[0]), values[1], values[2], this.get_client (int.parse(values[3])));
				return 1;
			});
			return job;
		}

		public bool save_job (Job job) {

			string query = (job.id > 0) 
				? "UPDATE `jobs` SET `name`='%s',`abbrev`='%s',`client_id`=%u WHERE `id`=%u".printf (job.name, job.abbrev, job.client.id, job.id)
				: "INSERT INTO `jobs` (`name`,`abbrev`,`client_id`) VALUES ('%s','%s',%u)".printf (job.name, job.abbrev, job.client.id)
			;
			return (db.exec(query) == Sqlite.OK);
		}

		public ArrayList<Activity>? get_all_activities () {
			/* 
			00 act.id
			01 act.description
			02 act.job_id
			03 act.begin
			04 act.end
			05 job.name
			06 job.abbrev
			07 job.client_id
			08 cln.id
			09 cln.name
			10 cln.abbrev
			*/
			ArrayList<Activity> activities = new ArrayList<Activity>();
			string error_message;
			string query = "SELECT `a`.`id`,`a`.`description`,`a`.`job_id`,`a`.`begin`,`a`.`end`,`j`.`name`,`j`.`abbrev`,`j`.`client_id`,`c`.`id`,`c`.`name`,`c`.`abbrev` FROM `activities` AS `a` LEFT JOIN `jobs` AS `j` ON `j`.`id`=`a`.`job_id` LEFT JOIN `clients` AS `c` ON `c`.`id`=`j`.`client_id` ORDER By `a`.`begin` ASC";

			int r = db.exec (query, (n, values, names) => {

				var job = new Job (int.parse (values[2]), values[5], values[6]);
				int year, month, day, hours, minutes, seconds;

				values[3].scanf ("%d-%d-%d %d:%d:%d", out year, out month, out day, out hours, out minutes, out seconds);
				var begin = new DateTime.local (year, month, day, hours, minutes, seconds);
				values[4].scanf ("%d-%d-%d %d:%d:%d", out year, out month, out day, out hours, out minutes, out seconds);
				var end = new DateTime.local (year, month, day, hours, minutes, seconds);

				var activity = new Activity (int.parse (values[0]), values[1], job, begin, end);
				activities.add (activity);

				return 0;
			}, out error_message);

			if (r != Sqlite.OK) {
				warning("QUERY Failed: %u: %s", r, error_message);
				return null;
			}

			return activities;

		}

		public bool save_activity (Activity activity) {

			string error_message;
			string query = (activity.id > 0) 
				? "UPDATE `activities` SET `description`='%s',`job_id`=%u,`begin`='%s', `end`='%s' WHERE `id`=%u".printf (activity.description, activity.job.id, activity.begin.format("%F %T"), activity.end.format("%F %T"), activity.id)
				: "INSERT INTO `activities` (`description`,`job_id`,`begin`,`end`) VALUES ('%s',%u,'%s','%s')".printf (activity.description, activity.job.id, activity.begin.format("%F %T"), activity.end.format("%F %T"))
			;

			debug (query);

			if (db.exec(query, null, out error_message) != Sqlite.OK) {
				warning (error_message);
				return false;
			}
			return true;
		}

		public bool delete_activity (Activity activity) {
			string query = "DELETE FROM `activities` WHERE `id`=%u".printf(activity.id);
			return (db.exec(query) == Sqlite.OK);
		}

		public bool delete_client (Client client) {
			string query = "DELETE FROM `clients` WHERE `id`=%u".printf(client.id);
			return (db.exec(query) == Sqlite.OK);
		}

		public bool delete_job (Job job) {
			string query = "DELETE FROM `jobs` WHERE `id`=%u".printf(job.id);
			return (db.exec(query) == Sqlite.OK);
		}

		public ArrayList<Category>? get_all_categories () {
			ArrayList<Category> categories = new ArrayList<Category>();

			var query = "SELECT `id`,`name`,`abbrev` FROM `categories` ORDER BY `name` ASC";
			int r = db.exec (query, (n_columns, values, column_names) => {
				var category = new Category(int.parse(values[0]), values[1], values[2]);
				categories.add(category);
				return 0;
			});
			if (r != Sqlite.OK){
				return null;
			}

			return categories;
		}

		public Category? get_category (int category_id) {
			Category category = null;
			string query = "SELECT `id`,`name`,`abbrev` FROM `categories` WHERE `id`=%u".printf (category_id);
			db.exec (query, (n, values, names) => {
				category = new Category (int.parse (values[0]), values[1], values[2]);
				return 1;
			});
			return category;
		}

		public bool save_category (Category category) {

			string query = (category.id > 0) 
				? "UPDATE `categories` SET `name`='%s',`abbrev`='%s' WHERE `id`=%u".printf (category.name, category.abbrev, category.id)
				: "INSERT INTO `categories` (`name`, `abbrev`) VALUES ('%s','%s')".printf (category.name, category.abbrev)
			;
			return (db.exec (query) == Sqlite.OK);
		}

		public bool delete_category (Category category) {
			string query = "DELETE FROM `categories` WHERE `id`=%u".printf(category.id);
			return (db.exec(query) == Sqlite.OK);
		}

		public bool query (string query) {
			int r = db.exec (query);
			return (r == Sqlite.OK);
		}
	}
}