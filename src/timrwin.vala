namespace Timr {

	[GtkTemplate (ui = "/de/hannenz/timr/timr.ui")]
	public class ApplicationWindow : Gtk.ApplicationWindow {

		[GtkChild]
		private Gtk.Label elapsed_label;

		[GtkChild]
		private Gtk.Entry activity_entry;

		[GtkChild]
		private Gtk.ComboBoxText projects_combobox;

		[GtkChild]
		public Gtk.ListStore activities;

		private GLib.Timer timer;

		private bool timer_running = false;

		public Activity activity;

		public signal void activity_stopped(Activity a);

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
		public void on_timer_toggle_button_clicked(Gtk.Button button) {

			Gdk.RGBA red = Gdk.RGBA();
			Gdk.RGBA green = Gdk.RGBA();
			Gdk.RGBA white = Gdk.RGBA();
			red.parse("#C00000");
			green.parse("#00C000");
			white.parse("#FFFFFF");

			if (timer_running && this.activity != null){

				this.activity.stop();

				this.activity.description = activity_entry.get_text();
				this.activity.project = projects_combobox.get_active_text();

				timer.stop();
				timer_running = false;
				button.set_label("Start timer");
				button.override_background_color(Gtk.StateFlags.NORMAL, green);
				button.override_color(Gtk.StateFlags.NORMAL, white);


				Gtk.TreeIter iter;
				this.activities.append(out iter);
				this.activities.set(iter,
					0, this.activity.description,
					1, this.activity.project,
					2, this.activity.get_duration(),
					3, this.activity.get_duration_nice(),
					// 4, time0.to_unix(),
					// 5, time1.to_unix(),
					6, this.activity.get_timespan_formatted()
				);

				// Reset UI
				elapsed_label.set_text("0 sec");
				activity_entry.set_text("");
				projects_combobox.set_active(0);

				// Emit signal
				activity_stopped(this.activity);
			}
			else {
				this.activity = new Activity();

				timer.start();
				timer_running = true;
				button.set_label("Stop timer");

				button.override_background_color(Gtk.StateFlags.NORMAL, red);
				button.override_color(Gtk.StateFlags.NORMAL, white);
			}
		}
	}
}