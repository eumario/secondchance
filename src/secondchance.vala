
// project version=0.0.1

using GLib;
using Granite;
using Gtk;
using Archive;


namespace SecondChance {
	public class SecondChanceApp : Granite.Application {
		private MainWindow window;
		private Widgets.AppMenu appMenu;

		static SecondChanceApp _instance;
		public static SecondChanceApp instance { get { return _instance; } }

		construct {
			application_id = "org.pantheon.SecondChance";
			flags = ApplicationFlags.FLAGS_NONE;

			program_name = Constants.RELEASE_NAME;
			app_years = "2016";

			build_version = Constants.VERSION;
			app_icon = "secondchance";
			main_url = "https://github.com/eumario/secondchance";
			bug_url = "https://github.com/eumario/secondchance/issues";
			help_url = "https://github.com/eumario/secondchance/wiki";
			translate_url = "https://github.com/eumario/secondchance/wiki/Translations";

			about_documenters = { null };
			about_artists = { "Vlad Merk <13i@list.ru>" };
			about_authors = { "Mario Steele <mario@ruby-im.net>" };

			about_comments = "Backup & Restore Personal files.";
			about_translators = "Github Translators...";
			about_license_type = Gtk.License.GPL_3_0;
		}

		public SecondChanceApp() {
			Granite.Services.Logger.initialize(Constants.RELEASE_NAME);
			Granite.Services.Logger.DisplayLevel = Granite.Services.LogLevel.DEBUG;
		}

		public override void activate() {
			if (get_windows() == null) {
				window = new MainWindow();
				window.show_all();
			} else {
				window.present();
			}
		}

		public Widgets.AppMenu get_appMenu() {
			if (appMenu == null) {
				appMenu = create_appmenu(new Gtk.Menu());
			}
			return appMenu;
		}

		public static int main(string[] args) {
			_instance = new SecondChanceApp();
			return _instance.run(args);
		}
	}
}