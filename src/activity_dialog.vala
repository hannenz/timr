using Gtk;

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
		private Gtk.Entry timespan_entry;

		private DateTime begin = null;

		private DateTime end = null;

		private int job_id = 0;

		private string job_name = null;

		private string text = null;

		private string job_abbrev= null;

		private string job_display_name = null;

		private ApplicationWindow parent_window;

		public ActivityDialog (ApplicationWindow window, Gtk.TreeStore clients_jobs) {

			GLib.Object (transient_for: window, use_header_bar: 0);

			job_combobox.set_model(clients_jobs);
		}

		private void split_time(string str, out int hours, out int minutes) {
			hours = minutes = 0;
			
			switch (str.length){
				case 1:
				case 2:
					hours = int.parse(str);
					minutes = 0;
					break;
				case 3:
					hours = int.parse(str.substring(0, 2));
					minutes = int.parse(str.substring(2, 1)) * 10;
					break;
				case 4:
					hours = int.parse(str.substring(0, 2));
					minutes = int.parse(str.substring(2, 2));
					break;
			}
		}

		private bool split_timespan() {

			uint year = 1915, month = 0, day = 1, hours = 0, minutes = 0;

			try {
				this.calendar.get_date(out year, out month, out day);

				string timespan = this.timespan_entry.get_text();
				var regex = new Regex("[^0-9\\-]");
				var _timespan = regex.replace(timespan, timespan.length, 0, "");

				string[] times = GLib.Regex.split_simple("(.+)\\-(.+)", _timespan);
				if (times.length > 2){
					split_time(times[1], out hours, out minutes);
					this.begin = new DateTime.local((int)year, (int)month, (int)day, (int)hours, (int)minutes, 0);

					split_time(times[2], out hours, out minutes);
					this.end = new DateTime.local((int)year, (int)month, (int)day, (int)hours, (int)minutes, 0);
				}
				else {
					return false;
				}
			}
			catch (Error e){
				this.parent_window.error ("Error: " + e.message);
				return false;
			}
			return true;
		}

		public DateTime get_begin() {
			if (this.begin == null){
				split_timespan();
			}
			debug ("%s\n", this.begin.to_string());
			return this.begin;
		}

		public DateTime get_end() {
			if (this.end == null){
				split_timespan();
			}
			debug ("%s\n", this.end.to_string());
			return this.end;
		}

		public string get_description() {
			return this.description_entry.get_text();
		}

		private void get_job_detail() {
			TreeIter iter;
			TreeStore model = (TreeStore)job_combobox.get_model();
			int job_id;
			string job_name, job_abbrev, job_display_name;

			if (job_combobox.get_active_iter(out iter)){
				if (model.iter_depth(iter) > 0){
					model.get(iter, 0, out job_id, 1, out job_name, 2, out job_abbrev, 3, out job_display_name);
					this.job_id = job_id;
					this.job_name = job_display_name;
					this.text = "<b>" + job_display_name + "</b>\n" + this.description_entry.get_text();
					this.job_abbrev = job_abbrev;
					this.job_display_name = job_display_name;
				}
			}
		}

		public int get_job_id() {
			if (this.job_id == 0){
				get_job_detail();
			}
			return this.job_id;
		}

		public string get_text() {
			if (this.text == null){
				get_job_detail();
			}
			return this.text;
		}

		public string get_job_display_name() {
			if (this.job_display_name == null){
				get_job_detail();
			}
			return this.job_display_name;
		}

		public string get_job_name() {
			if (this.job_name == null){
				get_job_detail();
			}
			return this.job_name;
		}

		public string get_job_abbrev() {
			if (this.job_abbrev == null){
				get_job_detail();
			}
			return this.job_abbrev;
		}
	}
}