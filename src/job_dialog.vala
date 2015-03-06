using Gtk;

namespace Timr {

	[GtkTemplate (ui="/de/hannenz/timr/job_dialog.ui")]
	public class JobDialog : Gtk.Dialog {

		[GtkChild]
		private Gtk.Entry name_entry;

		[GtkChild]
		private Gtk.Entry abbrev_entry;

		[GtkChild]
		private Gtk.ComboBox client_combobox;

		private Job job;

		private ApplicationWindow parent_window;

		public JobDialog (ApplicationWindow window, Job? job = null) {

			GLib.Object (transient_for: window, use_header_bar: 0);

			parent_window = window;
			client_combobox.set_model (parent_window.clients);

			if (job != null) {
				name_entry.set_text(job.name);
				abbrev_entry.set_text(job.abbrev);

				// todo: set combobox

				// we really want to be sure ;)
				if (job.client != null && job.client.id > 0) {

					parent_window.clients.foreach ( (model, path, iter) => {

						Client client;
						model.get(iter, 0, out client);
						if (client.id == job.client.id) {
							client_combobox.set_active_iter(iter);
							return true;
						}
						return false;
					});
				}
			}

		}

		public Job? get_job () {

			if (job == null) {
				job = new Job ();
			}
			job.name = name_entry.get_text ();
			job.abbrev = abbrev_entry.get_text ();

			TreeIter iter;
			if (client_combobox.get_active_iter (out iter)) {
				Client client;
				parent_window.clients.get(iter, 0, out client);
				job.client = client;
			}

			return job;
		}
	}
}