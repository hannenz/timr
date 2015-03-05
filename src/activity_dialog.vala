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

		private int activity_id;

		// private int job_id = 0;

		// private string job_name = null;

		// private string text = null;

		// private string job_abbrev= null;

		// private string job_display_name = null;

		private ApplicationWindow parent_window;

		public ActivityDialog (ApplicationWindow window, Gtk.TreeStore clients_jobs, Activity? activity = null) {

			GLib.Object (transient_for: window, use_header_bar: 0);

			job_combobox.set_model(clients_jobs);

			if (activity != null) {
				description_entry.set_text (activity.description);
				timespan_entry.set_text ("%s-%s".printf(activity.begin.format("%H:%M"), activity.end.format("%H:%M")));
				calendar.year = activity.begin.get_year ();
				calendar.month = activity.begin.get_month () - 1;
				calendar.day = activity.begin.get_day_of_month ();
				activity_id = activity.id;
			}

		}

		public Activity? get_activity () {

			Activity? activity = null;

			if (split_timespan ()) {

				Job? job = null;
				TreeIter iter;
				TreeStore model = (TreeStore) job_combobox.get_model ();
				job_combobox.get_active_iter (out iter);

				if (model.iter_depth (iter) > 0){
					model.get (iter, 0, out job);
				}

				activity = new Activity (activity_id, description_entry.get_text(), job, begin, end);
			}
			return activity;
		}

		/**
		 * split a string in the form "915-11" into hours and minutes integers
		 */
		private bool split_time(string str, out int hours, out int minutes) {
			hours = minutes = 0;
			
			switch (str.length){
				case 1:
				case 2:
					hours = int.parse(str);
					minutes = 0;
					break;
				case 3:
					hours = int.parse(str.substring(0, 1));
					minutes = int.parse(str.substring(1, 2));
					break;
				case 4:
					hours = int.parse(str.substring(0, 2));
					minutes = int.parse(str.substring(2, 2));
					break;
				default:
					return false;
			}
			return true;
		}

		private bool split_timespan() {

			uint year = 1915, month = 0, day = 1, hours = 0, minutes = 0;

			try {
				this.calendar.get_date(out year, out month, out day);

				string timespan = this.timespan_entry.get_text();
				// Remove everything except digits and hyphen
				var regex = new Regex("[^0-9\\-]");
				var _timespan = regex.replace(timespan, timespan.length, 0, "");

				// split at hyphen
				string[] times = GLib.Regex.split_simple("(.+)\\-(.+)", _timespan);

				if (times.length > 2){
					split_time(times[1], out hours, out minutes);
					this.begin = new DateTime.local((int)year, (int)month + 1, (int)day, (int)hours, (int)minutes, 0);

					split_time(times[2], out hours, out minutes);
					this.end = new DateTime.local((int)year, (int)month + 1, (int)day, (int)hours, (int)minutes, 0);
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

		// public DateTime get_begin() {
		// 	if (this.begin == null){
		// 		split_timespan();
		// 	}
		// 	debug ("%s\n", this.begin.to_string());
		// 	return this.begin;
		// }

		// public DateTime get_end() {
		// 	if (this.end == null){
		// 		split_timespan();
		// 	}
		// 	debug ("%s\n", this.end.to_string());
		// 	return this.end;
		// }

		// public string get_description() {
		// 	return this.description_entry.get_text();
		// }

		// private void get_job_detail() {
		// 	TreeIter iter;
		// 	TreeStore model = (TreeStore)job_combobox.get_model();
		// 	int job_id;
		// 	string job_name, job_abbrev, job_display_name;

		// 	if (job_combobox.get_active_iter(out iter)){
		// 		if (model.iter_depth(iter) > 0){
		// 			model.get(iter, 0, out job_id, 1, out job_name, 2, out job_abbrev, 3, out job_display_name);
		// 			this.job_id = job_id;
		// 			this.job_name = job_display_name;
		// 			this.text = "<b>" + job_display_name + "</b>\n" + this.description_entry.get_text();
		// 			this.job_abbrev = job_abbrev;
		// 			this.job_display_name = job_display_name;
		// 		}
		// 	}
		// }

		// public int get_job_id() {
		// 	if (this.job_id == 0){
		// 		get_job_detail();
		// 	}
		// 	return this.job_id;
		// }

		// public string get_text() {
		// 	if (this.text == null){
		// 		get_job_detail();
		// 	}
		// 	return this.text;
		// }

		// public string get_job_display_name() {
		// 	if (this.job_display_name == null){
		// 		get_job_detail();
		// 	}
		// 	return this.job_display_name;
		// }

		// public string get_job_name() {
		// 	if (this.job_name == null){
		// 		get_job_detail();
		// 	}
		// 	return this.job_name;
		// }

		// public string get_job_abbrev() {
		// 	if (this.job_abbrev == null){
		// 		get_job_detail();
		// 	}
		// 	return this.job_abbrev;
		// }
	}
}