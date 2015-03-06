namespace Timr {

	public class ActivityRepository : Repository {

		public ActivityRepository () {

			base ();

			this.table_name = "activities";
			this.fields = {"`id`", "`description`", "`job_id`", "`begin`","`end`"};
			this.order_by = "begin";
			this.order_dir = "ASC";
			
		}

		protected override Object create_object (string[] values) {

			var client_repository = new ClientRepository ();
			
			return new Job (int.parse(values[0]), values[1], values[2], client_repository.get(int.parse(values[3])));
		}
	}
}