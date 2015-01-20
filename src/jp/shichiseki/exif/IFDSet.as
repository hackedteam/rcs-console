package jp.shichiseki.exif {
	/**
	 * The IFDSet is a set of IFD which are included in a JPEG file.
	 */
	public class IFDSet extends Object {
		/**
		 * @private
		 */
		internal var _primary:IFD;
		/**
		 * Indicates the 0th IFD for Primary Image Data.
		 */
		public function get primary():IFD { return _primary; }

		/**
		 * @private
		 */
		internal var _exif:IFD;
		/**
		 * Indicates the Exif IFD (Exif Private Tag).
		 */
		public function get exif():IFD { return _exif; }

		/**
		 * @private
		 */
		internal var _gps:IFD;
		/**
		 * Indicates the GPS IFD (GPS Info Tag).
		 */
		public function get gps():IFD { return _gps; }

		/**
		 * @private
		 */
		internal var _thumbnail:IFD;
		/**
		 * Indicates the 1st IFD for Thumbnail Data.
		 */
		public function get thumbnail():IFD { return _thumbnail; }

		/**
		 * @private
		 */
		internal var _interoperability:IFD;
		/**
		 * Indicates the Interoperability IFD.
		 */
		public function get interoperability():IFD { return _interoperability; }

		/**
		 * Constructor.
		 */
		public function IFDSet() {
		}
	}
}
