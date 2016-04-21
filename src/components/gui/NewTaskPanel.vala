namespace SecondChance.Widgets {
	class NewTaskPanel : Gtk.EventBox {
		Widgets.StylizedList _list;
		Gtk.ComboBox _destination;
		Gtk.ComboBox _compression;
		Gtk.Entry _taskname;
		string[] compressOptions = {
			_("None"),
			_("Low (GZip)"),
			_("Medium (BZip2)"),
			_("High (LZMA)")
		};

		string[] destOptions = {
			_("USB Flash"),
			_("Burn to CD/DVD..."),
			_("Select Folder...")
		};

		public GLib.List<string> destinations;
		public CompressStyle compression;

		public NewTaskPanel(string? paths) {
			Object();
			destinations = new GLib.List<string>();
			append_paths(paths);
		}

		private void append_paths(string? paths) {
			if (paths != null) {
				if ("\n" in paths) {
					var spaths = paths.strip().split("\n");
					foreach(var path in spaths) {
						_list.append_item(path);
					}
				} else {
					_list.append_item(paths.strip());
				}
			}
		}

		construct {
			// Controls:
			_list = new Widgets.StylizedList();
			_list.enable_drag_n_drop();
			_list.drag_event.connect(on_drag_event);
			_taskname = new Gtk.Entry();
			_taskname.margin_right = 2;
			_taskname.margin_top = 4;
			_taskname.margin_bottom = 4;
			_taskname.placeholder_text = _("Enter name of task...");
			_compression = new Gtk.ComboBox.with_model(generate_list_store(compressOptions));
			_destination = new Gtk.ComboBox.with_model(generate_list_store(destOptions));

			var renderer = new Gtk.CellRendererText();
			_compression.pack_start(renderer, true);
			_compression.add_attribute(renderer, "text", 0);
			_compression.active = 0;
			_compression.changed.connect(on_compression_changed);
			_compression.vexpand = false;
			_compression.valign = Gtk.Align.CENTER;

			renderer = new Gtk.CellRendererText();
			_destination.pack_start(renderer, true);
			_destination.add_attribute(renderer, "text", 0);
			_destination.active = 0;
			_destination.changed.connect(on_destination_changed);
			_destination.margin_right = 2;
			_destination.margin_top = 4;
			_destination.margin_bottom = 4;
			_destination.hexpand = true;

			Gtk.Box content = new Gtk.Box(Gtk.Orientation.VERTICAL,0);
			var label = new Gtk.Label(_("Destionation:"));
			var grid = new Gtk.Grid();
			content.pack_start(_list, true, true, 4);
			content.pack_start(grid, false, true, 4);
			var add_dest = new Gtk.EventBox();
			add_dest.add(new Gtk.Image.from_icon_name("sc_add_blue",Gtk.IconSize.LARGE_TOOLBAR));
			// Row 0: Destination|ComboBox -|->    | Button +
			label.xpad = 4;
			((Gtk.Misc)label).xalign = 0.0f;
			label.ellipsize = Pango.EllipsizeMode.END;
			grid.attach(label, 0, 0, 1, 1);
			grid.attach(_destination, 1, 0, 2, 1);
			grid.attach(add_dest, 3, 0, 1, 1);

			// Row 1: Task Name  |Entry    -|->    | Spacer
			label = new Gtk.Label("Task Name:");
			label.xpad = 4;
			((Gtk.Misc)label).xalign = 0.0f;
			label.ellipsize = Pango.EllipsizeMode.END;
			grid.attach(label, 0, 1, 1, 1);
			grid.attach(_taskname, 1, 1, 2, 1);

			// Row 2: Compression|Combo     | Save | Spacer
			label = new Gtk.Label("Compression:");
			((Gtk.Misc)label).xalign = 0.0f;
			label.xpad = 4;
			label.ellipsize = Pango.EllipsizeMode.END;
			var save = new Gtk.Button();
			var bbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL,0);
			var lbox = new Gtk.Box(Gtk.Orientation.VERTICAL,0);
			bbox.pack_start(new Gtk.Image.from_icon_name("sc_apply",Gtk.IconSize.DND), false, false, 0);
			var vl = new Gtk.Label("Save");
			vl.get_style_context().add_class("h3");
			lbox.pack_start(vl, false, false, 0);
			vl = new Gtk.Label("Task");
			vl.get_style_context().add_class("h4");
			lbox.pack_start(vl, false, false, 0);
			bbox.pack_end(lbox);
			save.add(bbox);
			save.relief = Gtk.ReliefStyle.NONE;
			save.halign = Gtk.Align.END;

			grid.attach(label, 0, 2, 1, 1);
			grid.attach(_compression, 1, 2, 1, 1);
			grid.attach(save, 2, 2, 1, 1);

			add(content);

			show_all();
		}

		private Gtk.ListStore generate_list_store(string[] options) {
			Gtk.ListStore ls = new Gtk.ListStore(2, typeof(string), typeof(int));
			Gtk.TreeIter iter;
			int i = 0;

			foreach(string option in options) {
				ls.append(out iter);
				ls.set(iter, 0, option, 1, i);
				i++;
			}

			return ls;
		}

		private void on_compression_changed() {
			Value val;
			Gtk.TreeIter iter;

			_compression.get_active_iter(out iter);
			_compression.get_model().get_value(iter,1, out val);
			switch((int)val) {
				case 0:
					compression = CompressStyle.NONE;
					break;
				case 1:
					compression = CompressStyle.LOW;
					break;
				case 2:
					compression = CompressStyle.MEDIUM;
					break;
				case 3:
					compression = CompressStyle.HIGH;
					break;
				default:
					compression = CompressStyle.NONE;
					break;
			}
		}

		private void on_destination_changed() {

		}

		private void on_drag_event(Gtk.Widget widget, string pathinfo) {
			append_paths(pathinfo);
		}
	}
}