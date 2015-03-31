/**
 * @author	Copyright (c) 2008 shichiseki.jp
 * @version	1.0
 * @link		http://code.shichiseki.jp/as3/ExifInfo/
 */
package jp.shichiseki.exif {
	import flash.utils.ByteArray;

	/**
  * The ExifInfo class contains information about a JPEG file. It includes some IFD
  * which contain some tags. The ExifInfo class also contains the thumbnail image of
  * the JPEG file. The ExifInfo class is loosely based on Exif Version 2.2.
  * See <a href="http://www.exif.org/Exif2-2.PDF">http://www.exif.org/Exif2-2.PDF</a>
  * for more detail of Exif specification.
  */
	public class ExifInfo {
		private const SOI_MAKER:Array = [0xff, 0xd8];
		private const APP1_MAKER:Array = [0xff, 0xe1];
		private const EXIF_HEADER:Array = [0x45, 0x78, 0x69, 0x66, 0x00, 0x00];
		private const JFIF_MAKER:Array = [0xff, 0xe0];

		private var _tiffHeader:TIFFHeader;
		/**
		 * An TIFF header of the JPEG APP1.
		 *
		 * @see jp.shichiseki.exif.TIFFHeader;
		 */
		public function get tiffHeader():TIFFHeader { return _tiffHeader; }

		private var _ifds:IFDSet;
		/**
		 * A set of IFD that read from a JPEG file.
		 *
		 * @see jp.shichiseki.exif.IFDSet
		 */
		public function get ifds():IFDSet { return _ifds; }

		private var _thumbnailData:ByteArray;
		/**
		 * A thumbnail data extracted from a JPEG file.
		 *
		 * @example The following example shows the thumbnail image.
		 * <listing version="3.0">
		 * private var loadImage(jpeg:ByteArray):void {
		 *	 var exif:ExifInfo = new ExifInfo(jpeg);
		 *   var loader:Loader = new Loader();
		 *	 loader.loadBytes(exif.thumbnailData);
		 *   appendChild(loader);
		 * }
		 * </listing>
		 */
		public function get thumbnailData():ByteArray { return _thumbnailData; }

		/**
		 * Create the Exif information instance from a JPEG file.
		 * @param stream	JPEG file stored in a ByteArray object.
		 */
		public function ExifInfo(stream:ByteArray) {
			if (!validate(stream)) {
				return;
			}
			_tiffHeader = new TIFFHeader(stream);
			readIFDs(stream);
			readThumbnail(stream);
		}

		private function validate(stream:ByteArray):Boolean {
			var app1DataSize:uint;
			// JPG format check
			if (!hasSoiMaker(stream) ) {
				return false;
			}
			if(hasJFIFMaker(stream)) { // Skip the JFIF marker, if present. CWW
				stream.position += 16;
			} else {
				stream.position -=2; // Set position back to start of APP1 marker
			}
			
			if ( !hasAPP1Maker(stream)) {
				return false;
			}
			// handle app1 data size
			app1DataSize = stream.readUnsignedShort();
			if (!hasExifHeader(stream)) {
				return false;
			}
			return true;
		}

		private function readIFDs(stream:ByteArray):void {
			_ifds = new IFDSet();

			// primary ifd
			ifds._primary = new IFD(stream, Tags.getSet("primary"), tiffHeader.position);
			// 1st ifd (for thumbnail) 
			var nextIFDPointer:uint = stream.readUnsignedInt();
			if (nextIFDPointer != 0) {
				stream.position = nextIFDPointer + tiffHeader.position;
				ifds._thumbnail = new IFD(stream, Tags.getSet("thumbnail"), tiffHeader.position);
			}
			// Exif ifd
			if (ifds.primary.ExifIFDPointer) {
				stream.position = ifds.primary.ExifIFDPointer + tiffHeader.position;
				ifds._exif = new IFD(stream, Tags.getSet("exif"), tiffHeader.position);
				delete ifds._primary.ExifIFDPointer;
			}
			// GPS ifd
			if (ifds.primary.GPSInfoIFDPointer) {
				stream.position = ifds.primary.GPSInfoIFDPointer + tiffHeader.position;
				ifds._gps = new IFD(stream, Tags.getSet("gps"), tiffHeader.position);
				delete ifds._primary.GPSInfoIFDPointer;
			}
			// Interoperability ifd
			if (ifds.exif && ifds.exif.InteroperabilityIFDPointer) {
				stream.position = ifds.exif.InteroperabilityIFDPointer + tiffHeader.position;
				ifds._interoperability = new IFD(stream, Tags.getSet("interoperability"), tiffHeader.position);
				delete ifds._exif.InteroperabilityIFDPointer;
			}
		}

		private function readThumbnail(stream:ByteArray):void {
			// read thumbnail
			if (ifds.thumbnail &&
					ifds.thumbnail.JPEGInterchangeFormat &&
					ifds.thumbnail.JPEGInterchangeFormatLength) {
				_thumbnailData = new ByteArray();
				stream.position = ifds.thumbnail.JPEGInterchangeFormat + tiffHeader.position;
				stream.readBytes(_thumbnailData, 0, ifds.thumbnail.JPEGInterchangeFormatLength);
				delete ifds._thumbnail.JPEGInterchangeFormat;
				delete ifds._thumbnail.JPEGInterchangeFormatLength;
			}
		}

		private function hasSoiMaker(stream:ByteArray):Boolean {
			return compareStreamBytes(stream, SOI_MAKER);
		}

		private function hasJFIFMaker(stream:ByteArray):Boolean {
			return compareStreamBytes(stream, JFIF_MAKER);
		}
		
		private function hasAPP1Maker(stream:ByteArray):Boolean {
			return compareStreamBytes(stream, APP1_MAKER);
		}

		private function hasExifHeader(stream:ByteArray):Boolean {
			return compareStreamBytes(stream, EXIF_HEADER);
		}

		private function compareStreamBytes(stream:ByteArray, data:Array, offset:uint=0):Boolean {
			var b:uint;
			if (offset > 0)
				stream.position = offset;
			for (var i:int = 0; i < data.length; i++) {
				b = stream.readUnsignedByte();
				if (b != data[i]) return false;
			}
			return true;
		}
	}
}
