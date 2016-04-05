using Gtk;
using Granite;
using Granite.Widgets;

namespace SecondChance {
	class MainWindow : Gtk.Window {
		public MainWindow() {
			var hbar = new Gtk.HeaderBar();
			hbar.title = "Second Chance";
			hbar.show_close_button = true;

			this.set_application(SecondChanceApp.instance);
			this.set_size_request(500,400);
			this.window_position = Gtk.WindowPosition.CENTER;
			this.set_icon_name(SecondChanceApp.instance.app_icon);
			this.resizable = false;

			Gtk.MenuItem settings = new Gtk.MenuItem.with_label("Settings");
			settings.activate.connect(on_settings);

			var appMenu = SecondChanceApp.instance.get_appMenu();
			appMenu.menu.prepend(new Gtk.SeparatorMenuItem());
			appMenu.menu.prepend(settings);

			hbar.pack_end(appMenu);

			this.set_titlebar(hbar);

			Welcome welcome;
			welcome = new NoTask();

			welcome.activated.connect(on_add_task);

			add(welcome);

			this.show_all();
		}

		private void on_settings() {
			Granite.Services.Logger.notification("on_settings executed.");
		}

		private void on_add_task(int index) {
			Granite.Services.Logger.notification("on_add_task() executed.");
		}
	}
}