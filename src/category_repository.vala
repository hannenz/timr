namespace Timr {

	public class CategoryRepository : Repository {

		public CategoryRepository () {

			base ();
	
			this.table_name = "categories";
			this.fields = {"`id`", "`name`", "`abbrev`"};
			this.order_by = "abbrev";
			this.order_dir = "ASC";
			
		}

		protected override Object create_object (string[] values) {
			return new Category (int.parse(values[0]), values[1], values[2]);
		}
	}
}