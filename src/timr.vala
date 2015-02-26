namespace Timr {
	public class Timr : Gtk.Application {

		private ApplicationWindow window;

		public Timr() {
			application_id = "de.hannenz.timr";
			// flags |= Glib.ApplicationFlags.HANDLES_OPEN;
		}

		public override void activate() {
			window = new ApplicationWindow(this);
			window.present();
		}

		// public override void open(GLib.File[] files, string hint) {
		// 	if (window == null)	{
		// 		window = new ApplicationWindow(this);
		// 	}
		// 	else {
		// 		window.open (file);
		// 	}
		// 	window.present();
		// }
	}
}