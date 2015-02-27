namespace Timr {

	public class Activity {

		private GLib.TimeZone timezone;

		private GLib.DateTime begin;

		private GLib.DateTime end;

		private bool is_running;

		public string description;

		public int job_id;

		public string client;

		public string type;

		
		public 	Activity() {

			this.timezone = new GLib.TimeZone.local();
			this.begin = new GLib.DateTime.now(this.timezone);
			this.is_running = true;
		}

		public Activity.past(string description, GLib.DateTime begin, GLib.DateTime end) {
			this.is_running = false;
			this.begin = begin;
			this.end = end;
		}

		public void stop () {
			this.end = new GLib.DateTime.now(this.timezone);
			this.is_running = false;

		}

		public string get_duration_nice () {
			string duration_nice;
			int duration = (int)this.end.difference(this.begin) / 1000000;

			int hours = duration / 3600;
			int minutes = duration / 60 % 60;
			int seconds = duration % 60;

			duration_nice = (hours > 0) ? "<b>%02u</b>".printf(hours) : "%02u".printf(hours);
			duration_nice += ":";
			duration_nice += (minutes > 0) ? "<b>%02u</b>".printf(minutes) : "%02u".printf(minutes);
			duration_nice += ":";
			duration_nice += "%02u".printf(seconds);

			return duration_nice;
		}

		public int get_duration () {
			return (int)this.end.difference(this.begin) / 1000000;
		}

		public string get_timespan_formatted () {
			
			string timespan = "%s - %s".printf(
				this.begin.format("%H:%M"),
				this.end.format("%H:%M")
			);
			return timespan;
		}

		public string get_begin_datetime() {
			return this.begin.format("%Y-%m-%d %T");
		}

		public string get_end_datetime() {
			return this.end.format("%Y-%m-%d %T");
		}
	}
}