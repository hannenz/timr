using Gtk;

namespace Timr {
	
	public class Category : GLib.Object{

		/* Properties */

		public int id { get; set; default = 0; }

		public string name { get; set; default = null; }

		public string abbrev { get; set; default = null; }

		/* Constructor */

		public Category (int? id = 0, string? name = null, string? abbrev = null) {
			this.id = id;
			this.name = name;
			this.abbrev = abbrev;
		}
	}
}