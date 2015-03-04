using Gtk;

namespace Timr {
	
	public class Client {

		/* Properties */

		public int id { get; set; default = 0; }

		public string name { get; set; default = null; }

		public string abbrev { get; set; default = null; }

		/* Constructor */

		public Client (int? id = 0, string? name = null, string? abbrev = null) {
			this.id = id;
			this.name = name;
			this.abbrev = abbrev;
		}
	}
}