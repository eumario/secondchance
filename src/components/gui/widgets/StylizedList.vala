using Gtk;
using Gdk;
using Granite;
using Granite.Widgets;

namespace SecondChance.Widgets {
	public class StylizedList : Gtk.ScrolledWindow {
		Gtk.ListBox _box;
		protected new GLib.List<StylizedRow> children = new GLib.List<StylizedRow>();
		public signal void remove_request(int i, string filepath);
		public signal void drag_event(Gtk.Widget widget, string pathinfo);

		public StylizedList() {
			Object();
		}

		construct {
			_box = new Gtk.ListBox();
			_box.selection_mode = Gtk.SelectionMode.NONE;
			_box.set_sort_func(sortfunc);
			add(_box);
		}

		public void append_item(string filename) {
			var row = new StylizedRow(filename);
			row.remove_request.connect(on_remove_request);
			children.append(row);
			_box.add(row);
			_box.invalidate_sort();
			_box.show_all();
		}

		private void on_remove_request(StylizedRow row) {
			int index = children.index(row);
			remove_request(index,row.filepath);
		}

		public string? get_item_path(int index) {
			if (index < children.length() && children.nth_data(index) is StylizedRow) {
				return ((StylizedRow)children.nth_data(index)).filepath;
			}
			return null;
		}

		public int get_count() {
			return ((int)children.length());
		}

		private int sortfunc(Gtk.ListBoxRow row1, Gtk.ListBoxRow row2) {
			var row1_filepath = ((StylizedRow)row1.get_child()).filepath;
			var row2_filepath = ((StylizedRow)row2.get_child()).filepath;

			var row1_file = File.new_for_uri(row1_filepath);
			var row2_file = File.new_for_uri(row2_filepath);

			var row1_isdir = (row1_file.query_file_type(0) == FileType.DIRECTORY);
			var row2_isdir = (row2_file.query_file_type(0) == FileType.DIRECTORY);

			if ((row1_isdir && row2_isdir) || (!row1_isdir && !row2_isdir)) {
				// Is 0, cause they are both directories.
				var row1_fname = row1_file.get_path();
				var row2_fname = row2_file.get_path();
				return row1_fname.collate(row2_fname);
			} else {
				if (row1_isdir)
					return -1;
				else
					return 1;
			}
		}

		
		public void enable_drag_n_drop() {
			Gtk.drag_dest_set (
				this,
				DestDefaults.MOTION
				| DestDefaults.HIGHLIGHT,
				target_list,
				DragAction.COPY
				);
			this.drag_drop.connect(this.on_drag_drop);
			this.drag_data_received.connect(this.on_drag_data_received);
		}

		private bool on_drag_drop(Widget widget, DragContext context,
									int x, int y, uint time) {

			bool is_valid_drop_site = true;

			if (context.list_targets() != null) {
				var target_type = (Atom) context.list_targets().nth_data(Target.INT32);

				Gtk.drag_get_data(
					widget,
					context,
					target_type,
					time
					);
			} else {
				is_valid_drop_site = false;
			}

			return is_valid_drop_site;
		}

		private void on_drag_data_received(Widget widget, DragContext context,
											int x, int y,
											SelectionData selection_data,
											uint target_type, uint time) {
			bool dnd_success = false;
			bool delete_selection_data = false;

			if ((selection_data != null) && (selection_data.get_length() >= 0)) {
				if (context.get_suggested_action() == DragAction.ASK) {
					// Ask the user to move or copy, then set the context action.
				}

				if (context.get_suggested_action() == DragAction.MOVE) {
					delete_selection_data = true;
				}

				switch (target_type) {
				case Target.INT32:
					dnd_success = true;
					break;
				case Target.STRING:
					var text = (string) selection_data.get_data();
					drag_event(this,text);
					dnd_success = true;
					break;
				default:
					dnd_success = false;
					break;
				}
			}

			Gtk.drag_finish(context, dnd_success, delete_selection_data, time);
		}
	}
}