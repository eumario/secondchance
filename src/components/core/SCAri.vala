using GLib;
using Archive;
using Posix;
using Gee;

namespace SecondChance {
	// ArchiveFormat:
	//   CD - Create a CD Backup, No Compression, creating ISO9660
	//   UNCOMPRESSED - Creates a TAR File, set_format_pax_restricted(), No Compression
	//   COMPRESSED - Create a TAR File, set_format_pax_restricted(), Compression
	public enum ArchiveFormat {
		CD,
		UNCOMPRESSED,
		COMPRESSED
	}

	// CompressStyle:
	//	NONE - No Compression Used, basic ISO or TAR File
	//  LOW  - GZip compression: add_filter_gzip()
	//  MEDIUM - BZip2 compression: add_filter_bzip2()
	//  HIGH - LZMA compression: add_filter_lzma()

	public enum CompressStyle {
		NONE,
		LOW,
		MEDIUM,
		HIGH
	}

	public class SCAriSettings : GLib.Object {
		private static SCAriSettings _instance;
		public static SCAriSettings instance { get { return _instance; } }

		public ArchiveFormat format;
		public CompressStyle style;

		public static void init() {
			_instance = new SCAriSettings();
		}

		public SCAriSettings() {
			// Start off with a basic TAR file.
			format = ArchiveFormat.UNCOMPRESSED;
			style = CompressStyle.NONE;
		}

		// Sets Compressor and format based upon settings of format and style.
		public void setupCompressor(Write writer) {
			switch(format) {
				case ArchiveFormat.CD:
					writer.set_format_iso9660();
					writer.add_filter_none();
					return;
				case ArchiveFormat.UNCOMPRESSED:
					writer.set_format_pax_restricted();
					writer.add_filter_none();
					return;
				case ArchiveFormat.COMPRESSED:
					writer.set_format_pax_restricted();
					switch(style) {
						case CompressStyle.NONE:
							writer.add_filter_none();
							break;
						case CompressStyle.LOW:
							writer.add_filter_gzip();
							break;
						case CompressStyle.MEDIUM:
							writer.add_filter_bzip2();
							break;
						case CompressStyle.HIGH:
							writer.add_filter_lzma();
							break;
					}
					return;
			}
		}
	}

	public class SCAriWriter : GLib.Object {
		private Write archive;
		private uint8 buffer[4096];

		public SCAriWriter() {
			this.archive = new Write();
		}

		public SCAriWriter.from_file (string filename) throws SCAriError {
			this.archive = new Write();

			SCAriSettings.instance.setupCompressor(this.archive);

			if (this.archive.open_filename(filename) != Result.OK) {
				throw new SCAriError.ARCHIVE_OPEN_ERROR("%s", this.archive.error_string());
			}
		}

		public void add_entry (string fileName) {
			try {
				this.write_archive(fileName);
			} catch	{

			}
		}

		public void write_archive (string fileName) throws SCAriError {
			var entry = new Entry();
			entry.set_pathname(fileName);
			Posix.Stat st;
			Posix.stat(fileName,out st);
			entry.copy_stat(st);
			entry.set_size(st.st_size);

			if (this.archive.write_header(entry) != Result.OK) {
				throw new SCAriError.ARCHIVE_WRITE_HEADER_ERROR("%s", this.archive.error_string());
			}

			try {
				var file = File.new_for_path(fileName);
				var reader = file.read();
				var len = reader.read (this.buffer);
				while (len > 0) {
					this.archive.write_data(this.buffer,len);
					len = reader.read(this.buffer);
				}
			} catch {

			}
		}

		public void close() throws SCAriError {
			if (this.archive.finish_entry() != Result.OK) {
				throw new SCAriError.ARCHIVE_FINISH_ERROR("%s",this.archive.error_string());
			}

			if (this.archive.close() != Result.OK) {
				throw new SCAriError.ARCHIVE_CLOSE_ERROR("%s",this.archive.error_string());
			}
		}
	}

	/*
	public class SCAriReader : GLib.Object {

		private Read archive;
		private uint8 buffer[4096];
		weak Entry e;

		public SCAriReader() {
			this.archive = new Read();
		}

		public SCAriReader.from_file(string fileName) throws SCAriError {
			this.archive = new Read();

			this.archive.support_filter_all();
			this.archive.support_format_all();

			if (this.archive.open_filename(fileName, 4096) != Result.OK) {
				throw new SCAriError.ARCHIVE_OPEN_ERROR("%s",this.archive.error_string());
			}
		}

		public void extract() throws SCAriError {
			while (this.archive.next_header(out e) == Result.OK) {

			}
		}
	}
	*/  // For Later Version, Restoring Backups
}