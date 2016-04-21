using Gtk;
using Granite;
using Granite.Widgets;

namespace SecondChance {
	class MainWindow : Gtk.Window {
		private Gtk.HeaderBar hbar;
		private Gtk.Button cancel_button;
		private Gtk.Button add_button;
		public MainWindow() {
			hbar = new Gtk.HeaderBar();
			hbar.title = "Second Chance";
			hbar.show_close_button = true;

			cancel_button = new Gtk.Button.from_icon_name("sc_cancel");
			hbar.pack_end(cancel_button);
			cancel_button.no_show_all = true;

			add_button = new Gtk.Button.from_icon_name("sc_menu_new");
			hbar.pack_start(add_button);
			add_button.no_show_all = true;

			this.set_application(SecondChanceApp.instance);
			this.set_size_request(500,400);
			this.window_position = Gtk.WindowPosition.CENTER;
			this.set_icon_name(SecondChanceApp.instance.app_icon);
			this.resizable = false;

			Gtk.MenuItem settings = new Gtk.MenuItem.with_label(_("Settings"));
			settings.activate.connect(on_settings);

			var appMenu = SecondChanceApp.instance.get_appMenu();
			appMenu.menu.prepend(new Gtk.SeparatorMenuItem());
			appMenu.menu.prepend(settings);

			hbar.pack_end(appMenu);

			this.set_titlebar(hbar);

			var welcome = new NoTask();

			welcome.activated.connect(on_add_task);
			welcome.enable_item_drag_n_drop(0);
			welcome.drag_event.connect(on_drag_event);

			add(welcome);

			this.show_all();
		}

		private void on_settings() {
			Granite.Services.Logger.notification("on_settings executed.");
		}

		private void on_add_task(int index) {
			get_child().destroy();
			var newtask = new Widgets.NewTaskPanel(null);
			SecondChanceApp.instance.get_appMenu().hide();
			add(newtask);
			hbar.subtitle = "New Task...";
			add_button.show();
			cancel_button.show();
		}

		private void on_drag_event(int index, string pathinfo) {
			get_child().destroy();
			var newtask = new Widgets.NewTaskPanel(pathinfo);
			SecondChanceApp.instance.get_appMenu().hide();
			add(newtask);
			add_button.show();
			cancel_button.show();
		}
	}
}