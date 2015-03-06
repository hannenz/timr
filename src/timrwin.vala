using Gtk;

namespace Timr {

	[GtkTemplate (ui = "/de/hannenz/timr/timr.ui")]
	public class ApplicationWindow : Gtk.ApplicationWindow {

		// [GtkChild]
		// private Gtk.Label elapsed_label;

		[GtkChild]
		private Gtk.Entry activity_entry;

		[GtkChild]
		private Gtk.Button timer_button;

		[GtkChild]
		private Gtk.ComboBox job_combobox;

		[GtkChild]
		public Gtk.TreeStore activities;

		[GtkChild]
		public Gtk.TreeStore clients_jobs;

		[GtkChild]
		public Gtk.ListStore clients;

		[GtkChild]
		public Gtk.TreeView activities_treeview;

		[GtkChild]
		public Gtk.InfoBar info_bar;

		[GtkChild]
		public Gtk.Label info_bar_primary_label;

		[GtkChild]
		public Gtk.ButtonBox info_bar_action_area;

		// [GtkChild]
		// public Gtk.TreeViewColumn buttons_tv_column;

		private GLib.Timer timer;

		private bool timer_running = false;

		public Activity activity;

		private Gdk.RGBA red;
		private Gdk.RGBA green;
		private Gdk.RGBA white;

		public signal void activity_stopped(Activity a);
		public signal void update_database(string query);
		public signal void client_edited(string query);

		private Timr app;

		public ApplicationWindow (Timr application) {
			GLib.Object (application:application);
			this.app = application;
			this.timer = new GLib.Timer();

			//this.elapsed_label.set_size_request(120, -1);

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
			green.parse("#2C7500");
			white.parse("#FFFFFF");

			timer_button.override_background_color(Gtk.StateFlags.NORMAL, green);
			timer_button.override_color(Gtk.StateFlags.NORMAL, white);
			timer_button.grab_default();

			// var renderer = new CellRendererButton ();
			// buttons_tv_column.pack_start(renderer, true);

			// activities_treeview.button_press_event.connect ( (event) => {

			// 	if (event.type == Gdk.EventType.BUTTON_PRESS) {
			// 		debug ("The treeview has been clicked!");

			// 		TreePath path;
			// 		TreeViewColumn column;
			// 		int cell_x, cell_y;
			// 		activities_treeview.get_path_at_pos ((int)event.x, (int)event.y, out path, out column, out cell_x, out cell_y);
			// 		if (column.title == "Actions") {
			// 			debug ("The buttons column has been clicked");
			// 			return true;
			// 		}
			// 	}
			// 	return false;
			// });
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
				timer_button.set_label (mssg);
			}
			return true;
		}

		[GtkCallback]
		public void on_add_client_button_clicked () {
			var dlg = new ClientDialog(this, null);
			var response = dlg.run () ;
			if (response == ResponseType.OK) {
				var client = dlg.get_client ();
				debug ("Saving new client: %s %s", client.name, client.abbrev);

				if (app.repository.save_client (client)) {
					TreeIter iter;
					clients_jobs.append(out iter, null);
					clients_jobs.set(iter, 0, client, 1, client.name, 2, client.abbrev, 3, "%s %s".printf(client.abbrev, client.name));
				}
				else {
					error ("Failed to save client.");
				}
			}
			dlg.destroy ();
		}

		[GtkCallback]
		public void on_add_job_button_clicked () {
			var dlg = new JobDialog(this, null);
			var response = dlg.run ();
			if (response == ResponseType.OK) {
				var job = dlg.get_job ();
				debug ("New job: %s %s %u", job.name, job.abbrev, job.client.id);

				if (app.repository.save_job (job)) {

					clients_jobs.foreach ( (model, path, iter) => {
						if (clients_jobs.iter_depth (iter) == 0) {
							Client client;
							clients_jobs.get(iter, 0, out client);
							if (client.id == job.client.id) {
								TreeIter new_iter;
								clients_jobs.append(out new_iter, iter);
								clients_jobs.set(new_iter, 0, job, 1, job.name, 2, job.abbrev, 3, "<b>%s</b> %s".printf(job.abbrev, job.name));
								return true;
							}
						}
						return false;
					});

				}
				else {
					error ("Failed to save job.");
				}
			}
			dlg.destroy ();
		}

		[GtkCallback]
		public void on_info_bar_response(int response) {
			info_bar.hide();
		}

		// [GtkCallback]
		// public void on_buttons_column_clicked () {
		// 	debug ("Clicked!");
		// 	stdout.printf("Clicked!\n");
		// }

		[GtkCallback]
		public void on_activities_treeview_row_activated (Gtk.TreePath path, Gtk.TreeViewColumn column) {

			TreeIter iter;

			activities.get_iter (out iter, path);
			if (activities.iter_depth (iter) > 0) {
				Activity activity;
				activities.get (iter, 0, out activity);
				var dlg = new ActivityDialog (this, clients_jobs, activity);
				dlg.response.connect ( (response) => {

					if (response == ResponseType.OK) {

						activity = dlg.get_activity ();

						// Remove the old activity from the TreeStore
						TreeIter parent_iter;
						activities.iter_parent (out parent_iter, iter);
						
						activities.remove (ref iter);
						// If removing the last child iter will be invalidated, so we check for that
						if (!activities.iter_is_valid (iter)) {
							// If iter is invalid (last child has been removed), we remove the parent as well
							activities.remove (ref parent_iter);
						}

						// Check if we have a valid timespan
						if (app.check_insert_activity (activity)) {
							// Yes, then save it (UPDATE)
							if (app.repository.save_activity(activity)) {
								// and insert the new one
								app.insert_activity (activity);
							}
							else {
								error ("Failed to save activity");
							}
						}
						else {
							warning ("Timespan already taken");
						}
					}

					dlg.destroy ();
				});
				dlg.run ();


			}
		}

		public void resume_activity () {

			debug ("Resuming...!");

			// Gtk.TreeIter iter;
			// Activity activity;

			// activities.get_iter (out iter, path);

			// if (activities.iter_depth (iter) > 0) {

			// 	activities.get (iter, 0, out activity);

			// 	activity_entry.set_text (activity.description);

			// 	clients_jobs.foreach ( (model, path, iter) => {
			// 		if (clients_jobs.iter_depth (iter) > 0) {
			// 			Job job;
			// 			model.get (iter, 0, out job);
			// 			if (job.id == activity.job.id) {
			// 				job_combobox.set_active_iter (iter);
			// 				return true;
			// 			}
			// 		}
			// 		return false;
			// 	});
			// 	timer_start ();
			// }
		}

		[GtkCallback]
		public void on_client_treeview_row_activated (Gtk.TreePath path, Gtk.TreeViewColumn column) {
//			stdout.printf("Row has been activated\n");
			
			TreeIter iter;
			if (clients_jobs.get_iter (out iter, path)) {
				if (clients_jobs.iter_depth (iter) == 0){
					// Handle Clients
				}
				else {
					// Handle Jobs

					Job job;
					clients_jobs.get (iter, 0, out job);
					var dlg = new JobDialog (this, job);
					if ((dlg.run ()) == ResponseType.OK) {

						job = dlg.get_job ();

						if (app.repository.save_job (job)) {
							clients_jobs.set(iter, 0, job, 1, job.name, 2, job.abbrev, 3, "<b>%s</b> %s".printf(job.abbrev, job.name));
						}
						else {
							error ("Failed to save job.");
						}
					}
				}
			}
		}

		// [GtkCallback]
		// public void on_client_treeview_name_column_edited(string path_str, string new_text){
			
		// 	Gtk.TreeIter iter;
		// 	Gtk.TreePath path;
		// 	int id;
		// 	path = new Gtk.TreePath.from_string(path_str);
		// 	clients.get_iter(out iter, path);
		// 	clients.get(iter, 0, out id);
		// 	clients.set(iter, 1, new_text);

		// 	string query = "UPDATE clients SET name='%s' WHERE id=%u\n".printf(new_text, id);
		// 	update_database(query);
		// }

		// [GtkCallback]
		// public void on_client_treeview_abbrev_column_edited(string path_str, string new_text){
		// 	Gtk.TreeIter iter;
		// 	Gtk.TreePath path;
		// 	int id;
		// 	path = new Gtk.TreePath.from_string(path_str);
		// 	clients.get_iter(out iter, path);
		// 	clients.get(iter, 0, out id);
		// 	clients.set(iter, 2, new_text);

		// 	string query = "UPDATE clients SET abbrev='%s' WHERE id=%u\n".printf(new_text, id);

		// 	update_database(query);
		// }

		[GtkCallback]
		public void on_timer_toggle_button_clicked(Gtk.Button button) {

			if (timer_running && this.activity != null){
				timer_stop();
			}
			else {
				timer_start();
			}
		}

		[GtkCallback]
		public void on_activity_add_button_clicked (Gtk.Button button) {
			var activity_dialog = new ActivityDialog (this, clients_jobs);
			activity_dialog.response.connect ( (response) => {
				if (response == Gtk.ResponseType.OK){
					var activity = activity_dialog.get_activity ();
					if (activity == null) {
						this.warning ("Invalid activity.");
					}
					else {
						if (!app.check_insert_activity (activity)) {
							this.warning ("This timespan is already in use");
						}
						else {
							app.repository.save_activity (activity);
							activity_stopped (activity);
						}
					}
				}
				activity_dialog.destroy ();
			});
			activity_dialog.run ();
		}

		private void message (string message, Gtk.MessageType type) {
			this.info_bar_primary_label.set_markup (message);
			this.info_bar.message_type = type;
			this.info_bar.show ();
		}

		public void error (string message) {
			this.message (message, Gtk.MessageType.ERROR);
		}

		public void warning (string message) {
			this.message (message, Gtk.MessageType.WARNING);
		}

		public void info (string message) {
			this.message (message, Gtk.MessageType.INFO);
		}

		private void  timer_start () {

				this.activity = new Activity ();
				this.activity.start ();

				timer.start ();
				timer_running = true;
				timer_button.set_label ("Stop timer");

				timer_button.override_background_color  (Gtk.StateFlags.NORMAL, red);
				timer_button.override_color (Gtk.StateFlags.NORMAL, white);
		}

		private void  timer_stop (){

			Gtk.TreeIter iter;
			Job? job = null;
			//int job_id = 0;
			//string job_display_name = "unknown job", job_name, job_abbrev;

			this.activity.stop ();

			this.activity.description = activity_entry.get_text ();
			if (job_combobox.get_active_iter (out iter)){
				if (clients_jobs.iter_depth (iter) > 0){
					clients_jobs.get (iter, 0, out job);
				}
			}

			this.activity.job = app.repository.get_job (job.id);
			this.activity.debug ();

			timer.stop ();
			timer_running = false;
			timer_button.set_label ("Start timer");
			timer_button.override_background_color (Gtk.StateFlags.NORMAL, green);
			timer_button.override_color (Gtk.StateFlags.NORMAL, white);

			// Reset UI
			//timer_button.set_text ("0 sec");
			activity_entry.set_text ("");
			job_combobox.set_active (0);

			// Emit signal
			activity_stopped (this.activity);

		}
	}
}