namespace Timr {

	public class JobRepository : Repository {

		public JobRepository () {

			base ();

			this.table_name = "jobs";
			this.fields = {"`id`", "`name`", "`abbrev`, `client_id`"};
			this.order_by = "abbrev";
			this.order_dir = "ASC";
			
		}

		protected override Object create_object (string[] values) {

			var client_repository = new ClientRepository ();

			return new Job (int.parse(values[0]), values[1], values[2], client_repository.get(int.parse(values[3])));
		}
	}
}