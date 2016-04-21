using Gtk;
using Gdk;
using Granite;
using Granite.Widgets;

namespace SecondChance.Widgets {
	const int BYTE_BITS = 8;
	const int WORD_BITS = 16;
	const int DWORD_BITS = 32;

	enum Target {
		INT32,
		STRING,
		ROOTWIN
	}

	const TargetEntry[] target_list = {
		{ "INTEGER",    0, Target.INT32 },
		{ "STRING",     0, Target.STRING },
		{ "text/plain", 0, Target.STRING },
		{ "application/x-rootwindow-drop", 0, Target.ROOTWIN }
	};

	public class OptionButton : Gtk.Button {
		Gtk.Label button_title;
		Gtk.Label button_description;
		Gtk.Image? _icon;
		Gtk.Grid button_grid;

		public signal void drag_event(Gtk.Widget widget, string pathinfo);

		public string title {
			get { return button_title.get_text(); }
			set { button_title.set_text(value); }
		}

		public string description {
			get { return button_description.get_text(); }
			set { button_description.set_text(value); }
		}

		public Gtk.Image? icon {
			get { return _icon; }
			set {
				if (_icon != null) {
					_icon.destroy();
				}
				_icon = value;
				if (_icon != null) {
					_icon.set_pixel_size(48);
					_icon.halign = Gtk.Align.CENTER;
					_icon.valign = Gtk.Align.CENTER;
					button_grid.attach(_icon, 0, 0, 1, 2);
				}
			}
		}

		public OptionButton(Gtk.Image? image, string option_text, string description_text) {
			Object (title: option_text, description: description_text, icon: image);
		}

		construct {
			// Title label
			button_title = new Gtk.Label(null);
			button_title.get_style_context().add_class("h3");
			button_title.halign = Gtk.Align.START;
			button_title.valign = Gtk.Align.END;

			// Description label
			button_description = new Gtk.Label(null);
			button_description.halign = Gtk.Align.START;
			button_description.valign = Gtk.Align.START;
			button_description.set_line_wrap(true);
			button_description.set_line_wrap_mode(Pango.WrapMode.WORD);

			get_style_context().add_class(Gtk.STYLE_CLASS_FLAT);

			// Button contents wrapper
			button_grid = new Gtk.Grid();
			button_grid.column_spacing = 12;

			button_grid.attach(button_title, 1, 0, 1, 1);
			button_grid.attach(button_description, 1, 1, 1, 1);
			this.add(button_grid);
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