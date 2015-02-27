namespace Timr {

	[GtkTemplate (ui = "/de/hannenz/timr/timr.ui")]
	public class ApplicationWindow : Gtk.ApplicationWindow {

		[GtkChild]
		private Gtk.Label elapsed_label;

		[GtkChild]
		private Gtk.Entry activity_entry;

		[GtkChild]
		private Gtk.Button timer_button;

		[GtkChild]
		private Gtk.ComboBox job_combobox;

		[GtkChild]
		public Gtk.ListStore activities;

		[GtkChild]
		public Gtk.ListStore clients;

		[GtkChild]
		public Gtk.ListStore jobs;

		private GLib.Timer timer;

		private bool timer_running = false;

		public Activity activity;

		private Gdk.RGBA red;
		private Gdk.RGBA green;
		private Gdk.RGBA white;

		public signal void activity_stopped(Activity a);
		public signal void client_edited(string query);

		public ApplicationWindow (Timr application) {
			GLib.Object (application:application);

			this.timer = new GLib.Timer();
			this.elapsed_label.set_size_request(120, -1);

			// Gtk.TreeIter iter;
			// this.activities.append(out iter);
			// this.activities.set(iter,
			// 	0, "Checked Emails",
			// 	1, "HALMA_15001 Internes",
			// 	2, 17*60 + 12,
			// 	3, "<b>17</b>:12 min"
			// );
			// this.activities.append(out iter);
			// this.activities.set(iter,
			// 	0, "Bugfix",
			// 	1, "HILAG_15001 Websitepflege",
			// 	2, 17*60 + 12,
			// 	3, "<b>03</b>:44 hrs"
			// );

			Timeout.add(1, this.update_timer);

			red = Gdk.RGBA();
			green = Gdk.RGBA();
			white = Gdk.RGBA();
			red.parse("#C00000");
			green.parse("#00C000");
			white.parse("#FFFFFF");

		}

		private bool update_timer() {

			if (timer_running){

				uint seconds = (uint)timer.elapsed();
				string mssg = "";

				if (seconds < 60){
					mssg = "%u sec".printf(seconds);
				}
				else if (seconds < 3600) {
					mssg = "%02u:%02u min".printf(seconds / 60, seconds % 60);
				}
				else {
					mssg = "%02u:%02u hrs".printf(seconds / 3600, seconds % 3600);
				}
				elapsed_label.set_text(mssg);
			}
			return true;
		}



		[GtkCallback]
		public void on_activities_treeview_row_activated (Gtk.TreePath path, Gtk.TreeViewColumn column) {

			Gtk.TreeIter iter;
			string description;

			activities.get_iter(out iter, path);
			activities.get(iter, 1, out description);

			activity_entry.set_text(description);
			timer_start();

		}

		[GtkCallback]
		public void on_client_treeview_row_activated(Gtk.TreePath path, Gtk.TreeViewColumn column) {
			stdout.printf("Row has been activated\n");
		}

		[GtkCallback]
		public void on_client_treeview_name_column_edited(string path_str, string new_text){
			
			Gtk.TreeIter iter;
			Gtk.TreePath path;
			int id;
			path = new Gtk.TreePath.from_string(path_str);
			clients.get_iter(out iter, path);
			clients.get(iter, 0, out id);
			clients.set(iter, 1, new_text);

			string query = "UPDATE clients SET name='%s' WHERE id=%u\n".printf(new_text, id);
			client_edited(query);
			// string errormsg;
			// if ((ec = db.exec(query, null, out errormsg)) != Sqlite.OK){
			// 	stderr.printf("Error writing client record: %d: %s\n", ec, errormsg);
			// }
		}

		[GtkCallback]
		public void on_client_treeview_abbrev_column_edited(string path_str, string new_text){
			Gtk.TreeIter iter;
			Gtk.TreePath path;
			int id;
			path = new Gtk.TreePath.from_string(path_str);
			clients.get_iter(out iter, path);
			clients.get(iter, 0, out id);
			clients.set(iter, 2, new_text);

			string query = "UPDATE clients SET abbrev='%s' WHERE id=%u\n".printf(new_text, id);

			client_edited(query);
			// string errormsg;
			// if ((ec = db.exec(query, null, out errormsg)) != Sqlite.OK){
			// 	stderr.printf("Error writing client record: %d: %s\n", ec, errormsg);
			// }
		}

		[GtkCallback]
		public void on_timer_toggle_button_clicked(Gtk.Button button) {

			if (timer_running && this.activity != null){
				timer_stop();
			}
			else {
				timer_start();
			}
		}

		private void  timer_start(){

				this.activity = new Activity();

				timer.start();
				timer_running = true;
				timer_button.set_label("Stop timer");

				timer_button.override_background_color(Gtk.StateFlags.NORMAL, red);
				timer_button.override_color(Gtk.StateFlags.NORMAL, white);
		}

		private void  timer_stop(){
				this.activity.stop();

				this.activity.description = activity_entry.get_text();
//				this.activity.project = job_combobox.get_active_text();

				timer.stop();
				timer_running = false;
				timer_button.set_label("Start timer");
				timer_button.override_background_color(Gtk.StateFlags.NORMAL, green);
				timer_button.override_color(Gtk.StateFlags.NORMAL, white);

				Gtk.TreeIter iter;
				this.activities.append(out iter);
				this.activities.set(iter,
					1, this.activity.description,
					2, this.activity.job_id,
					3, this.activity.get_duration(),
					4, this.activity.get_duration_nice(),
					// 4, time0.to_unix(),
					// 5, time1.to_unix(),
					6, this.activity.get_timespan_formatted()
				);

				// Reset UI
				elapsed_label.set_text("0 sec");
//				activity_entry.set_text("");
				job_combobox.set_active(0);

				// Emit signal
				activity_stopped(this.activity);

		}
	}
}