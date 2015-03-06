using Gtk;

namespace Timr {

	[GtkTemplate (ui="/de/hannenz/timr/client_dialog.ui")]
	public class ClientDialog : Gtk.Dialog {

		[GtkChild]
		private Gtk.Entry name_entry;

		[GtkChild]
		private Gtk.Entry abbrev_entry;

		private Client client;

		private ApplicationWindow parent_window;

		public ClientDialog (ApplicationWindow window, Client? client = null) {

			GLib.Object (transient_for: window, use_header_bar: 0);
			
			parent_window = window;

			if (client != null) {
				name_entry.set_text(client.name);
				abbrev_entry.set_text(client.abbrev);
			}
		}

		public Client? get_client () {

			if (client == null) {
				client = new Client ();
			}
			client.name = name_entry.get_text ();
			client.abbrev = abbrev_entry.get_text ();

			return client;
		}
	}
}