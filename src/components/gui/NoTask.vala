using Gtk;
using Granite;
using Granite.Widgets;

namespace SecondChance {
	public class NoTask : Widgets.WizardPanel {
		construct {
			//var welcome_box = ((Gtk.Box)this.get_child());
			var welcome_box = this.content_area;

			var label = new Gtk.Label(_("No Tasks available"));
			label.get_style_context().add_class("h3");
			label.set_justify(Gtk.Justification.CENTER);
			var separator = new Gtk.Separator(Gtk.Orientation.HORIZONTAL);
			separator.halign = Gtk.Align.CENTER;
			separator.set_size_request(100,-1);

			welcome_box.pack_start(separator, false, false, 10);
			welcome_box.pack_start(label, false, true, 0);

			append("sc_open",_("Add Task"),_("Or drop files"));
		}

		public NoTask() {
			base(_("Add Files & Folders"),_("to backup task"));
		}
	}
}