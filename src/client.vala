using Gtk;

namespace Timr {
	
	public class Client {

		private string name;

		public Client() {

		}

		public string get_name(){
			return this.name;
		}

		public void set_name(string name){
			this.name = name;
		}

	}
}