namespace Timr {

	public class Job {

		private int id;

		private string name;

		private string abbrev;

		private Client client;

		public Job (int id, string name, string abbrev, Client client) {
			this.id = id;
			this.name = name;
			this.abbrev = abbrev;
			this.client = client;
		}

		public int get_id () {
			return this.id;
		}

		public void set_id (int id) {
			this.id = id;
		}

		public string get_name () {
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

		public Client get_client () {
			return this.client;
		}

		public void set_client (Client client) {
			this.client = client;
		}
	}
}