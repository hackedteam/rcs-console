package jp.shichiseki.exif {
	import flash.utils.ByteArray;
	/**
	 * The IFDEntry class is an entry in an IFD. The IFDEntry class contains type, name, id
	 * and data of the entry.
	 */
	public class IFDEntry {
		private static const TAG_TYPES:Object = {
			1: {name:"BYTE", size:1, reader: readByteHandler},
			2: {name:"ASCII", size:1, reader: readStringHandler},
			3: {name:"SHORT", size:2, reader: readShortHandler},
			4: {name:"LONG", size:4, reader: readLongHandler},
			5: {name:"RATIONAL", size:8, reader: readRationalHandler},
			7: {name:"UNDEFINED", size:1, reader: readByteHandler},
			9: {name:"SLONG", size:4, reader: readSLongHandler},
			10: {name:"SRATIONAL", size:8, reader: readSRationalHandler}
		};

		private var _tagID:uint;

		/**
		 * Indicates the tagID of this entry.
		 */
		public function get tagID():uint { return _tagID; }

		private var _tag:XMLList;
		/**
		 *Indicates the tag of this entry.
		 */
		public function get tag():XMLList { return _tag; }

		private var _tagName:String;
		/**
		 * Indicates the tag name of this entry.
		 */
		public function get tagName():String { return tag.@field_name.toString() || _tagName }

		private var _typeID:uint;
		/**
		 * Indicates the type ID of this entry.
		 */
		public function get typeID():uint { return _typeID; }

		private var _type:Object;
		/**
		 * Indicates the type of this entry.
		 */
		public function get type():Object { return _type; }

		private var _data:Object;
		/**
		 * Indicates the data of this entry.
		 */
		public function get data():Object { return _data; }
		private var _numData:uint;

		/**
		 * Constructor.
		 */
		public function IFDEntry(stream:ByteArray, tagSet:XML, offset:uint) {
			var nextPosition:uint;

			_tagID = stream.readUnsignedShort();
			_tag = tagSet.tag.(parseInt(@id, 16) == tagID);
			_tagName = "0x" + _tagID.toString(16);
			if (!tag.@field_name.toString())
				_tagName = "UnknownTag_" + _tagName;
			_typeID = stream.readUnsignedShort();
			_type = TAG_TYPES[_typeID];
			_numData = stream.readUnsignedInt();
			nextPosition = stream.position + 4;

			if (!type) {
				trace("unrecognizable tag id=" + tagID + " type=" + typeID);
				_data = null;
			} else {
				if (_numData * type.size > 4)
					stream.position = stream.readUnsignedInt() + offset;
				readContent(stream);
			}
				
			stream.position = nextPosition;
		}

		private function readContent(stream:ByteArray):void {
			if (_typeID == 2) {
				_data = readStringHandler(stream, _numData);
			} else if (_numData == 1) {
				_data = type.reader(stream);
			} else {
				_data = new Array();
				for (var i:uint = 0; i < _numData; i++) {
					_data.push(type.reader(stream));
				}
			}
		}
	
		private static function readStringHandler(stream:ByteArray, length:uint):String {
      return stream.readUTFBytes(length);
    }

    private static function readByteHandler(stream:ByteArray):uint {
      return stream.readUnsignedByte();
    }

    private static function readShortHandler(stream:ByteArray):uint {
      return stream.readUnsignedShort();
    }

    private static function readLongHandler(stream:ByteArray):uint {
      return stream.readUnsignedInt();
    }

    private static function readSLongHandler(stream:ByteArray):int {
      return stream.readInt();
    }

    private static function readRationalHandler(stream:ByteArray):Number {
      var denominator:uint = stream.readUnsignedInt();
      var numerator:uint = stream.readUnsignedInt();
      return Number(denominator) / Number(numerator);
    }

    private static function readSRationalHandler(stream:ByteArray):Number {
      var denominator:int = stream.readInt();
      var numerator:int = stream.readInt();
      return Number(denominator) / Number(numerator);
    }
	}
}
