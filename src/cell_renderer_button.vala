using Gtk;

namespace Timr {
	public class CellRendererButton : Gtk.CellRenderer {

		public CellRendererButton () {
			GLib.Object ();
		}

		public override void get_size (Widget widget, Gdk.Rectangle? cell_area, out int x_offset, out int y_offset, out int width, out int height) {

			x_offset = 0;
			y_offset = 0;
			width = 50;
			height = 50;

		}

		public override void render (Cairo.Context ctx, Widget widget, Gdk.Rectangle background_area, Gdk.Rectangle cell_area, CellRendererState flags) {

			if (flags == Gtk.CellRendererState.PRELIT) {

				Gdk.cairo_rectangle (ctx, background_area);
				Gdk.Pixbuf? icon = null;

				try {
					icon = new Gdk.Pixbuf.from_file ("/usr/share/pixmaps/firefox.png");
				}
				catch (Error e){
					error("Could not open pixbuf file: %s", e.message);
				}

				if (icon != null) {
					Gdk.cairo_set_source_pixbuf (ctx, icon, background_area.x, background_area.y);
					ctx.fill ();
				}
			}
		}

		public override bool activate (Gdk.Event event, Widget widget, string path, Gdk.Rectangle background_area, Gdk.Rectangle cell_area, CellRendererState flags) {

			return true;
		}
	}
}