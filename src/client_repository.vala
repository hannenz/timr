namespace Timr {

	public class ClientRepository : Repository {

		public ClientRepository () {

			base ();

			this.table_name = "clients";
			this.fields = {"`id`", "`name`", "`abbrev`"};
			this.order_by = "abbrev";
			this.order_dir = "ASC";
			
		}

		protected override Object create_object (string[] values) {
			return new Client (int.parse(values[0]), values[1]);
		}
	}
}