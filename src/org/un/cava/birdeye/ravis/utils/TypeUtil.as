package org.un.cava.birdeye.ravis.utils
{
	import flash.xml.XMLDocument;
	
	import mx.rpc.xml.SimpleXMLDecoder;
	import mx.utils.ObjectProxy;
	import mx.utils.ObjectUtil;
	
	public class TypeUtil
	{
		public function TypeUtil()
		{
		}
		
		public static function isFalse(str:String):Boolean
		{
			if ((str == null) || (str == 'undefined') || (str == ''))
			{
				return false;
			}
				
			var upper:String = str.toUpperCase();
			if (upper == 'FALSE' || upper == 'NO' || upper == 'F' || upper == 'N' || upper == '0')
				return true;
				
			return false;
		}
		
		public static function isTrue(str:String):Boolean
		{
			if ((str == null) || (str == 'undefined') || (str == ''))
			{
				return false;
			}
				
			var upper:String = str.toUpperCase();
			if (upper == 'TRUE' || upper == 'YES' || upper == 'T' || upper == 'Y' || upper == '1')
				return true;

			return false;	
		}
		
		public static function getDataTypeFromObject(obj:Object):uint
	    {
	        if (obj is Number)
	        	return NUMBER_TYPE;
	        else if (obj is Boolean)
	        	return BOOLEAN_TYPE;
	        else if (obj is String)
	        	return STRING_TYPE;
	        else if (obj is XMLDocument)
				return XML_TYPE;
			else if (obj is Date)
				return DATE_TYPE;
			else if (obj is Array)
				return ARRAY_TYPE;
	        else if (obj is Function)
	            return FUNCTION_TYPE;
			else if (obj is Object)
	            return OBJECT_TYPE;
	        else
	            // Otherwise force it to string
	        	return STRING_TYPE;
	    }
		
		public static function cloneSimpleObject(obj:Object):Object
		{
			var retObj:Object = new Object();
			var classInfo:Object = ObjectUtil.getClassInfo(obj, null, {includeReadOnly:false, includeTransient:false});
			var properties:Array = classInfo.properties;
			var pCount:uint = properties.length;
			
			for (var p:uint = 0; p < pCount; p++)
			{
				var fieldName:String = properties[p];
				var fieldValue:Object = obj[fieldName];
				
				if (fieldValue != null)
				{
					if (getDataTypeFromObject(fieldValue) == OBJECT_TYPE ||
						getDataTypeFromObject(fieldValue) == ARRAY_TYPE ||
						getDataTypeFromObject(fieldValue) == FUNCTION_TYPE)
						continue;
				}
				retObj[fieldName] = fieldValue;
			}
			
			return retObj;
		}
		
		public static function cloneSimpleAttributeToObject(source:Object, target:Object):void
		{
			if (target && source) {
				var retObj:Object = target;
				var classInfo:Object;
				if (source is ObjectProxy)
				{
					classInfo = ObjectUtil.getClassInfo(source, null, null);
				}
				else
				{
					classInfo = ObjectUtil.getClassInfo(source, null, {includeReadOnly:false, includeTransient:false});
				}
				var properties:Array = classInfo.properties;
				var pCount:uint = properties.length;
				
				for (var p:uint = 0; p < pCount; p++)
				{
					var fieldName:String = properties[p];
					var fieldValue:Object = source[fieldName];
					
					if (fieldValue != null)
					{
						if (getDataTypeFromObject(fieldValue) == OBJECT_TYPE ||
							getDataTypeFromObject(fieldValue) == ARRAY_TYPE ||
							getDataTypeFromObject(fieldValue) == FUNCTION_TYPE)
							continue;
					}
					else
					{
						continue;
					}
					//if (retObj.hasOwnProperty(fieldName))
					retObj[fieldName] = fieldValue;
				}
			}
		}
		
		public static function objectPropertyToXMLAttributeString(obj:Object):String 
		{
			var retStr:String = '';
			var classInfo:Object = ObjectUtil.getClassInfo(obj, null, {includeReadOnly:false, includeTransient:false});
			var properties:Array = classInfo.properties;
			var pCount:uint = properties.length;
			
			for (var p:uint = 0; p < pCount; p++)
			{
				var fieldName:String = properties[p];
				var fieldValue:Object = obj[fieldName];
				
				if (fieldValue == null)
					continue;
				if (getDataTypeFromObject(fieldValue) == OBJECT_TYPE ||
					getDataTypeFromObject(fieldValue) == ARRAY_TYPE ||
					getDataTypeFromObject(fieldValue) == FUNCTION_TYPE)
					continue;
				var fieldString:String = fieldValue.toString();
				retStr += (fieldName + '="' + fieldString + '" ');
			}
            return retStr;
        }
        
        public static function deserializeXMLString(xmlStr:String):Object
        {
        	var xmlDoc:XMLDocument = new XMLDocument(xmlStr);
        	xmlDoc.ignoreWhite = true;
       		var decoder:SimpleXMLDecoder = new SimpleXMLDecoder(false);
        	var decoded:Object = decoder.decodeXML(xmlDoc.lastChild);
        	return decoded;
        }
        
		public static function encodeDate(rawDate:Date, dateType:String):String
	    {
	        var s:String = new String();
	        var n:Number;
	
	        if (dateType == "dateTime" || dateType == "date")
	        {
	            s = s.concat(rawDate.getUTCFullYear(), "-");
	
	            n = rawDate.getUTCMonth()+1;
	            if (n < 10) s = s.concat("0");
	            s = s.concat(n, "-");
	
	            n = rawDate.getUTCDate();
	            if (n < 10) s = s.concat("0");
	            s = s.concat(n);
	        }
	
	        if (dateType == "dateTime")
	        {
	            s = s.concat("T");
	        }
	
	        if (dateType == "dateTime" || dateType == "time")
	        {
	            n = rawDate.getUTCHours();
	            if (n < 10) s = s.concat("0");
	            s = s.concat(n, ":");
	
	            n = rawDate.getUTCMinutes();
	            if (n < 10) s = s.concat("0");
	            s = s.concat(n, ":");
	
	            n = rawDate.getUTCSeconds();
	            if (n < 10) s = s.concat("0");
	            s = s.concat(n, ".");
	
	            n = rawDate.getUTCMilliseconds();
	            if (n < 10) s = s.concat("00");
	            else if (n < 100) s = s.concat("0");
	            s = s.concat(n);
	        }
	
	        s = s.concat("Z");
	
	        return s;
	    }	
	    public static const NUMBER_TYPE:uint   = 0;
	    public static const STRING_TYPE:uint   = 1;
	    public static const OBJECT_TYPE:uint   = 2;
	    public static const DATE_TYPE:uint     = 3;
	    public static const BOOLEAN_TYPE:uint  = 4;
	    public static const XML_TYPE:uint      = 5;
	    public static const ARRAY_TYPE:uint    = 6;  // An array with a wrapper element
	    public static const MAP_TYPE:uint      = 7;
	    public static const ANY_TYPE:uint      = 8;
	    // We don't appear to use this type anywhere, commenting out
	    //private static const COLL_TYPE:uint     = 10; // A collection (no wrapper element, just maxOccurs)
	    public static const ROWSET_TYPE:uint   = 11;
	    public static const QBEAN_TYPE:uint    = 12; // CF QueryBean
	    public static const DOC_TYPE:uint      = 13;
	    public static const SCHEMA_TYPE:uint   = 14;
	    public static const FUNCTION_TYPE:uint = 15; // We currently do not serialize properties of type function
	    public static const ELEMENT_TYPE:uint  = 16;
	    public static const BASE64_BINARY_TYPE:uint = 17;
	    public static const HEX_BINARY_TYPE:uint = 18;
	
	    /**
	     * @private
	     */
	    public static const CLASS_INFO_OPTIONS:Object = {includeReadOnly:false, includeTransient:false};
	}
}