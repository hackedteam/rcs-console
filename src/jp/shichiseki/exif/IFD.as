package jp.shichiseki.exif {
	import flash.utils.ByteArray;

/**
 * The IFD class represents an IFD in the Exif.
 * The IFD contains some IFDEntry which contain the information about the JPEG file.
 * You can get all IFDEntry information using following an example:
 * <listing version="3.0">
 * public function showEntries(ifd:IFD):void {
 *   for (var name:String in ifd) {
 *     log(name + ": " + ifd[name]);
 *   }
 * }
 * </listing>
 */
	dynamic public class IFD {
		private var entries:Array;
		private var numEnt:uint;
		private var _tagSet:XML;
		/**
		 * A set of tags represented as a XML that may be included in this IFD.
		 */
		public function get tagSet():XML { return _tagSet; }

		/**
		 * Constructor.
		 */
		public function IFD(stream:ByteArray, tagSet:XML, offset:uint) {
			_tagSet = tagSet;
			numEnt = stream.readUnsignedShort();
			readIFDEntries(stream, offset);
		}

		/**
		 * Indicates the level of this IFD.
		 */
		public function get level():String { 
			return tagSet.@level.toString();
		}

		/**
		 * Searches for an IFD by using <code>tagID</code>, and returns
		 * the IFD which matched the ID.
		 * @param	tagID		A tagID.
		 */
		public function getEntryByTagID(tagID:uint):IFDEntry {
			for each (var e:IFDEntry in entries) {
				if (e.tagID == tagID)
					return e;
			}
			return null;
		}

		/**
		 * Searches for an IFD by using <code>tagName</code>, and returns
		 * the IFD which mached the name.
		 * @param	tagName	A tag name.
		 */
		public function getEntryByTagName(tagName:String):IFDEntry {
			for each (var e:IFDEntry in entries) {
				if (e.tagName == tagName)
					return e;
			}
			return e;
		}

		private function readIFDEntries(stream:ByteArray, offset:uint):void {
			entries = new Array();
			for (var i:uint = 0; i < numEnt; i++) {
				var entry:IFDEntry = new IFDEntry(stream, tagSet, offset);
				if (entry.data) {
					this[entry.tagName] = entry.data;
				}
				entries.push(entry);
			}
		}
	}
}
