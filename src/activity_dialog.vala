
namespace Timr {
	
	[GtkTemplate (ui="/de/hannenz/timr/activity_dialog.ui")]
	public class ActivityDialog : Gtk.Dialog {

		[GtkChild]
		private Gtk.Entry description_entry;

		[GtkChild]
		private Gtk.ComboBox job_combobox;

		[GtkChild]
		private Gtk.Calendar calendar;

		[GtkChild]
		private Gtk.Entry begin_entry;

		[GtkChild]
		private Gtk.Entry end_entry;

		public ActivityDialog (ApplicationWindow window, Gtk.TreeStore clients_jobs) {

			GLib.Object (transient_for: window, use_header_bar: 0);

			job_combobox.set_model(clients_jobs);

		}

		public DateTime get_begin() {

			uint year, month, day;
			this.calendar.get_date(out year, out month, out day);

			string begin = this.begin_entry.get_text();
			var regex = new Regex("[^0-9]");
			var begin1 = regex.replace(begin, begin.length, 0, "");
			stdout.printf("%s\n", begin1);

			return new DateTime.local((int)year, (int)month, (int)day, 0, 0, 0);
		}

		public DateTime get_end() {
			// int year, month, day;
			return new DateTime.now_local();
		}

		public string get_description() {
			return this.description_entry.get_text();
		}
	}
}