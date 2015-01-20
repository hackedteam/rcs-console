package jp.shichiseki.exif {
	/**
	 * The Tags class has some tagset that contain tags will be appeared in IFD of a
	 * JPEG file.
	 */
	public class Tags {
		[Embed(source="assets/0th_ifd_tiff.xml")]
		/**
		 * The 0th IFD tagset.
		 */
		public static const PRIMARY:Class;

		[Embed(source="assets/0th_ifd_exif.xml")]
		/**
		 * The 0th exif IFD tagset.
		 */
		public static const EXIF:Class;

		[Embed(source="assets/0th_ifd_gps.xml")]
		/**
		 * The 0th GPS IFD tagset.
		 */
		public static const GPS:Class;

		[Embed(source="assets/0th_ifd_int.xml")]
		/**
		 * The 0th Interoperability IFD tagset.
		 */
		public static const INTEROPERABILITY:Class;

		[Embed(source="assets/1st_ifd_tiff.xml")]
		/**
		 * The 1st IFD(Thumbnail) tagset.
		 */
		public static const THUMBNAIL:Class;

		private static const levels:Object = {
			"primary": PRIMARY,
			"exif": EXIF,
			"gps": GPS,
			"interoperability": INTEROPERABILITY,
			"thumbnail": THUMBNAIL
		};

		/**
		 * Gets the tagset specified by <code>level</code>
		 */
		public static function getSet(level:String):* {
			if (!levels[level])
				return null;
			return XML(levels[level].data);
		}
	}
}
