using Gtk;

namespace Timr {
	
	public class Client {

		private int id;

		private string name;

		private string abbrev;

		public Client (int id, string name, string abbrev) {
			this.id = id;
			this.name = name;
			this.abbrev = abbrev;
		}

		public string get_name (){
			return this.name;
		}

		public void set_name (string name){
			this.name = name;
		}

		public string get_abbrev () {
			return this.abbrev;
		}

		public void set_abbrev (string abbrev) {
			this.abbrev = abbrev;
		}
	}
}