namespace Timr {
	class Activity {

		private GLib.TimeZone timezone;

		private GLib.DateTime start;

		private GLib.DateTime end;

		private bool is_running;
		
		public void Activity {

			this.timezone = new GLib.TimeZone.local();
			this.start = new GLib.DateTime(this.timezone);
			this.running = true;
		}

		public void stop () {
			this.end = new GLib.DateTime(this.timezone);
			this.running = false;
		}

		public string 


	}
}