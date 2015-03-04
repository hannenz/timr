namespace Timr {

	public class Activity {

		/* Properties */

		public int id { get; set; default = 0; }

		public string description { get; set; default = null; }

		public Job job { get; set; default = null; }

		public GLib.DateTime begin { get; set; default = null; }

		public GLib.DateTime end {get; set; default = null; }

		// public string type { get; set; default = null; }

		/* Constructor */
		
		public Activity(int? id = 0, string? description = null, Job? job = null, DateTime? begin = null, DateTime? end = null) {
			this.id = id;
			this.description = description;
			this.job = job;
			this.begin = begin;
			this.end = end;
		}

		public void start () {
			this.begin = new GLib.DateTime.now_local ();
		}

		public void stop () {
			this.end = new GLib.DateTime.now_local ();
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

		public string get_summary () {

			string summary = "<b>";
			if (this.job.abbrev != null){
			 	summary += this.job.abbrev;
			}
			if (this.job.name != null){
			 	summary += " " + this.job.name;
			}
			summary += "</b>\n";
			summary += this.description;
			return summary;
		}

		public string get_date(){
			return this.begin.format("%Y-%m-%d");
		}

	}
}