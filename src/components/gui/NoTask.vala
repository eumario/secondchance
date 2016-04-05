using Gtk;
using Granite;
using Granite.Widgets;

namespace SecondChance {
	public class NoTask : Welcome {
		construct {
			var welcome_box = ((Gtk.Box)this.get_child());

			var label = new Gtk.Label("No Tasks available");
			label.get_style_context().add_class("h3");
			label.set_justify(Gtk.Justification.CENTER);
			var separator = new Gtk.Separator(Gtk.Orientation.HORIZONTAL);
			separator.halign = Gtk.Align.CENTER;
			separator.set_size_request(100,-1);

			welcome_box.pack_start(label, false, true, 0);
			welcome_box.pack_start(separator, false, false, 10);

			welcome_box.reorder_child(separator,3);
			welcome_box.reorder_child(label,4);

			append("document-open","Add Task","Or drop files");
		}

		public NoTask() {
			base("Add Files & Folders","to backup task");
		}
	}
}