package org.un.cava.birdeye.ravis.utils {
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	public class LogUtil {
		private static const _LOG:ILogger = Log.getLogger("ravis");
		
		public static function debug(className:String, message:String):void {
			_LOG.debug(className + ":\n> " + message);
		}
		public static function error(className:String, message:String):void {
			_LOG.error(className + ":\n> " + message);
		}
		public static function fatal(className:String, message:String):void {
			_LOG.fatal(className + ":\n> " + message);
		}
		public static function info(className:String, message:String):void {
			_LOG.info(className + ":\n> " + message);
		}
		public static function warn(className:String, message:String):void {
			_LOG.warn(className + ":\n> " + message);
		}
	}
}