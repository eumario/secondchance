namespace SecondChance.Widgets {
	public class StylizedRow : Gtk.Bin {
		Gtk.Image? icon;
		Gtk.Label label;
		Gtk.EventBox remove_button;
		string _image;
		private string _filepath;

		public string filepath {
			get { return _filepath; }
			set { _filepath = value; }
		}

		public string image {
			get { return _image; }
			set {
				_image = value;
				icon.set_from_icon_name(_image,Gtk.IconSize.MENU);
			}
		}

		public string display_name {
			get { return label.get_label(); }
			set { label.set_markup(value); }
		}

		public signal void remove_request(StylizedRow row);

		public StylizedRow(string filename) {
			string icon_name = "";
			//var file = File.new_for_path(filename);
			var file = File.new_for_uri(filename);
			if (file.query_exists()) {
				if (file.query_file_type(0) == FileType.DIRECTORY) {
					icon_name = "folder";
				} else {
					icon_name = "document";
				}
			}
			var markup = "<b>%s</b>\n<span color='#999'><small>%s/</small></span>";
			var path = File.new_for_uri(filename);
			Object(filepath: filename, image: icon_name, display_name: markup.printf(path.get_basename(),path.get_parent().get_path()));
		}

		private bool on_click(Gdk.EventButton eventButton) {
			remove_request(this);
			return false;
		}

		construct {
			this.icon = new Gtk.Image();
			this.label = new Gtk.Label(null);
			this.label.ellipsize = Pango.EllipsizeMode.MIDDLE;
			this.remove_button = new Gtk.EventBox();
			this.remove_button.add(new Gtk.Image.from_icon_name("sc_list-remove",Gtk.IconSize.MENU));

			this.remove_button.button_release_event.connect(this.on_click);

			var content = new Gtk.Box(Gtk.Orientation.HORIZONTAL,0);
			content.pack_start(this.icon,false,false,2);
			content.pack_start(this.label,false,true,0);
			content.pack_end(this.remove_button,false,false,0);

			add(content);
		}
	}
}