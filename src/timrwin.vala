namespace Timr {

	[GtkTemplate (ui = "/de/hannenz/timr/timr.ui")]
	public class ApplicationWindow : Gtk.ApplicationWindow {

		[GtkChild]
		private Gtk.Label elapsed_label;

		[GtkChild]
		private Gtk.Entry activity_entry;

		[GtkChild]
		private Gtk.ComboBoxText projects_combobox;

		private GLib.DateTime time0;

		private GLib.DateTime time1;

		private GLib.Timer timer;
		bool timer_running = false;

		[GtkChild]
		public Gtk.ListStore activities;

		public ApplicationWindow (Gtk.Application application) {
			GLib.Object (application:application);

			this.timer = new GLib.Timer();
			this.elapsed_label.set_size_request(120, -1);


			Gtk.TreeIter iter;
			this.activities.append(out iter);
			this.activities.set(iter,
				0, "Checked Emails",
				1, "HALMA_15001 Internes",
				2, 17*60 + 12,
				3, "<b>17</b>:12 min"
			);
			this.activities.append(out iter);
			this.activities.set(iter,
				0, "Bugfix",
				1, "HILAG_15001 Websitepflege",
				2, 17*60 + 12,
				3, "<b>03</b>:44 hrs"
			);

		}

		[GtkCallback]
		public void on_timer_toggle_button_clicked(Gtk.Button button) {

			Gdk.RGBA red = Gdk.RGBA();
			Gdk.RGBA green = Gdk.RGBA();
			Gdk.RGBA white = Gdk.RGBA();
			red.parse("#C00000");
			green.parse("#00C000");
			white.parse("#FFFFFF");

			if (timer_running){
				time1 = new DateTime.now(new TimeZone.local());
				timer.stop();
				timer_running = false;
				button.set_label("Start timer");
				button.override_background_color(Gtk.StateFlags.NORMAL, green);
				button.override_color(Gtk.StateFlags.NORMAL, white);


				stdout.printf("Logging activity: »%s« on Project »%s«, started at %s, for %u seconds\n",
					activity_entry.get_text(),
					projects_combobox.get_active_text(),
					time0.to_string(),
					(uint)timer.elapsed()
				);

				string duration_nice;
				int duration = (int)timer.elapsed();

				int hours = duration / 3600;
				int minutes = duration / 60 % 60;
				int seconds = duration % 60;

				duration_nice = (hours > 0) ? "<b>%02u</b>".printf(hours) : "%02u".printf(hours);
				duration_nice += ":";
				duration_nice += (minutes > 0) ? "<b>%02u</b>".printf(minutes) : "%02u".printf(minutes);
				duration_nice += ":";
				duration_nice += "%02u".printf(seconds);

				Gtk.TreeIter iter;
				this.activities.append(out iter);
				this.activities.set(iter,
					0, activity_entry.get_text(),
					1, projects_combobox.get_active_text(),
					2, duration,
					3, duration_nice,
					4, time0.to_unix(),
					5, time1.to_unix()
				);

				// Reset UI
				elapsed_label.set_text("0 sec");
				activity_entry.set_text("");
				projects_combobox.set_active(0);

			}
			else {
				time0 = new DateTime.now(new TimeZone.local());
				timer.start();
				timer_running = true;
				button.set_label("Stop timer");

				button.override_background_color(Gtk.StateFlags.NORMAL, red);
				button.override_color(Gtk.StateFlags.NORMAL, white);

				Timeout.add_seconds(1, () => {

					if (timer_running){
						uint seconds = (uint)timer.elapsed();
						var mssg = "";

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
				});
			}
		}
	}
}