namespace Timr {

	public class Activity : GLib.Object {

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
			int64 duration = (int64)this.end.difference(this.begin) / 1000000;

			int64 hours = duration / 3600;
			int64 minutes = (duration / 60) % 60;
			int64 seconds = duration % 60;

			duration_nice = (hours > 0) ? "<b>%02u</b>".printf((int)hours) : "%02u".printf((int)hours);
			duration_nice += ":";
			duration_nice += (minutes > 0) ? "<b>%02u</b>".printf((int)minutes) : "%02u".printf((int)minutes);
			duration_nice += ":";
			duration_nice += "%02u".printf((int)seconds);

			return duration_nice;
		}

		public string get_duration_plaintext () {
			string duration_nice;
			int64 duration = (int64)this.end.difference(this.begin) / 1000000;

			int64 hours = duration / 3600;
			int64 minutes = (duration / 60) % 60;
			int64 seconds = duration % 60;

			duration_nice = (hours > 0) ? "%02u".printf((int)hours) : "%02u".printf((int)hours);
			duration_nice += ":";
			duration_nice += (minutes > 0) ? "%02u".printf((int)minutes) : "%02u".printf((int)minutes);
			duration_nice += ":";
			duration_nice += "%02u".printf((int)seconds);

			return duration_nice;
		}

		public int get_duration () {
			return (int)(this.end.difference(this.begin) / 1000000);
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

		public void debug () {
			GLib.debug ("[id]%u [description]%s [job_id]%u [job_name]%s [begin]%s [end]%s",
				this.id,
				this.description,
				this.job.id,
				this.job.name,
				this.begin.to_string (),
				this.end.to_string ()
			);
		}

	}
}