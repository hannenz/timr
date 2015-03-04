namespace Timr {

	public class Job {

		/* Properties / Getters - Setters */

		public int id { get; set; default = 0; }

		public string name { get; set; default = null; }
		
		public string abbrev { get; set; default = null; }

		public Client client { get; set; default = null; }

		/* Constructor */

		public Job (int? id = 0, string? name = null, string? abbrev = null, Client? client = null) {
			this.id = id;
			this.name = name;
			this.abbrev = abbrev;
			this.client = client;
		}
	}
}