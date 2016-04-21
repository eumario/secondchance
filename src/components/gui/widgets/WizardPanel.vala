using Gtk;
using Granite;
using Granite.Widgets;

namespace SecondChance.Widgets {
	public class WizardPanel : Gtk.EventBox {
		public signal void activated(int index);
		public signal void drag_event(int index, string pathinfo);

		protected new GLib.List<Gtk.Button> children = new GLib.List<Gtk.Button>();

		protected Gtk.Box options;

		public string title {
			get {
				return title_label.get_label();
			}

			set {
				title_label.set_label(value);
			}
		}

		public string subtitle {
			get {
				return subtitle_label.get_label();
			}
			set {
				subtitle_label.set_label(value);
			}
		}

		public Gtk.Box content_area {
			get { return _content_area; }
		}

		private Gtk.Label title_label;
		private Gtk.Label subtitle_label;
		private Gtk.Box _content_area;

		public WizardPanel(string title_text, string subtitle_text) {
			Object(title: title_text, subtitle: subtitle_text);
		}

		construct {

			// Labels
			title_label = new Gtk.Label(null);
			title_label.get_style_context().add_class("h1");
			title_label.set_justify (Gtk.Justification.CENTER);

			subtitle_label = new Gtk.Label(null);
			subtitle_label.get_style_context().add_class("h2");
			subtitle_label.set_line_wrap(true);
			subtitle_label.set_line_wrap_mode(Pango.WrapMode.WORD);
			subtitle_label.set_justify(Gtk.Justification.CENTER);

			// Content Areas (Content and Options)
			_content_area = new Gtk.Box(Gtk.Orientation.VERTICAL,0);

			this.options = new Gtk.Box(Gtk.Orientation.VERTICAL, 8);
			var options_wrapper = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
			options_wrapper.pack_start(new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0), true, true, 0);
			options_wrapper.pack_start(this.options, false, false, 0);
			options_wrapper.pack_end(new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0), true, true, 0);

			Gtk.Box content = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
			content.homogeneous = false;

			content.pack_start(new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0), true, true, 0);
			content.pack_start(title_label, false, true, 0);
			content.pack_start(subtitle_label, false, true, 2);
			content.pack_start(_content_area,false,true,0);
			content.pack_start(options_wrapper,false,false,20);
			content.pack_end(new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0), true, true, 0);

			add(content);
		}

		public void set_options_visible(bool val) {
			this.options.set_no_show_all(!val);
			this.options.set_visible(val);
		}

		public void set_item_visible(uint index, bool val) {
			if (index < children.length() && children.nth_data(index) is Gtk.Widget) {
				children.nth_data(index).set_no_show_all(!val);
				children.nth_data(index).set_visible(val);
			}
		}

		public void enable_item_drag_n_drop(uint index) {
			if (index < children.length() && children.nth_data(index) is OptionButton) {
				((OptionButton)children.nth_data(index)).enable_drag_n_drop();
				((OptionButton)children.nth_data(index)).drag_event.connect(this.on_drag_event);
			}
		}

		private void on_drag_event(Gtk.Widget widget, string pathinfo) {
			int index = this.children.index(((Gtk.Button)widget));
			drag_event(index, pathinfo);
		}

		public void remove_item(uint index) {
			if (index < children.length() && children.nth_data(index) is Gtk.Widget) {
				var item = children.nth_data(index);
				item.destroy();
				children.remove(item);
			}
		}

		public void set_item_sensitivity(uint index, bool val) {
			if (index < children.length() && children.nth_data(index) is Gtk.Widget)
				children.nth_data(index).set_sensitive(val);
		}

		public int append(string icon_name, string option_text, string description_text) {
			Gtk.Image? image = new Gtk.Image.from_icon_name(icon_name, Gtk.IconSize.DIALOG);
			return append_with_image(image,option_text,description_text);
		}

		public int append_with_pixbuf(Gdk.Pixbuf? pixbuf, string option_text, string description_text) {
			var image = new Gtk.Image.from_pixbuf(pixbuf);
			return append_with_image(image,option_text,description_text);
		}

		public int append_with_image(Gtk.Image? image, string option_text, string description_text) {
			var button = new OptionButton(image,option_text,description_text);
			children.append(button);
			options.pack_start(button,false,false,0);
			button.button_release_event.connect (() => {
				int index = this.children.index(button);
				activated(index);
				return false;
			});

			return this.children.index(button);
		}

		public SecondChance.Widgets.OptionButton? get_button_from_index(int index) {
			if (index >= 0 && index < children.length())
				return children.nth_data(index) as OptionButton;
			return null;
		}
	}
}