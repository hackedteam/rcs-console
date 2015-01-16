package jp.shichiseki.exif {
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * The TIFFHeader represents TIFF Header.
	 */
	public class TIFFHeader {
		private const INTEL_ENDIAN:uint = 0x4949;
		private const MARK:uint = 0x002a;
		private const OFFSET:uint = 0x0008;

		private var _endian:String;
		/**
		 * Indicates the endian of the TIFF data.
		 */
		public function get endian():String { return _endian; }

		private var _position:uint;
		/**
		 * Indicates the start position of the TIFF header.
		 */
		public function get position():uint { return _position; }

		/**
		 * Constructor.
		 */
		public function TIFFHeader(stream:ByteArray) {
			var mark:uint;
			var offset:uint;
			var endianType:uint;

			_position = stream.position;
			endianType = stream.readUnsignedShort();
			if (endianType == INTEL_ENDIAN) {
				// little endian
				_endian = Endian.LITTLE_ENDIAN;
			} else {
				// big endian
				_endian = Endian.BIG_ENDIAN;
			}
			stream.endian = _endian;
			mark = stream.readUnsignedShort();
			offset = stream.readUnsignedInt();
			if (mark != MARK || offset != OFFSET) {
				trace("error");
			}
		}
	}
}
