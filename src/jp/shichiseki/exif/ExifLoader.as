package jp.shichiseki.exif {
	import flash.display.Loader;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.events.*;

	/**
	 * The ExifLoader is a sub class of <code>Loader</code> class which is used to load JPG
	 * files with EXIF.
	 * @example A Typical usage is shown in the following code:
	 * <listing version="3.0">
	 * private function loadImage():void {
	 *   var loader:ExifLoader = new ExifLoader();
	 *   loader.addEventListener(Event.COMPLETE, onComplete);
	 *   loader.load(new URLRequest("http://www.example.com/sample.jpg"));
	 * }
	 *
	 * private function onComplete(e:Event):void {
	 *   // display image
	 *   addChild(e.target);
	 *   // display thumbnail image
	 *   var thumbLoader:Loader = new Loader();
	 *   thumbLoader.loadBytes(loader.exif.thumbnailData);
	 *   addChild(thumbLoader);
	 * }
	 * </listing>
	 *
	 * @see flash.display.Loader
	 */
	public class ExifLoader extends Loader {
		private var _exif:ExifInfo;
		/**
		 * Returns a ExifInfo object containing information about loaded JPG image file.
		 */
		public function get exif():ExifInfo { return _exif; }
		private var _urlLoader:URLLoader;
		private var _context:LoaderContext;

		/**
		 * Loads a JPG image file into an object that is a child of this ExifLoader object.
		 */
		override public function load(request:URLRequest, context:LoaderContext=null):void {
			_context = context;

			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlLoader.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, forwardEvent, false, 0, true);
			_urlLoader.addEventListener(ProgressEvent.PROGRESS, forwardEvent, false, 0, true);
			_urlLoader.addEventListener(Event.OPEN, forwardEvent, false, 0, true);
			_urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, forwardEvent, false, 0, true);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, forwardEvent, false, 0, true);
			_urlLoader.load(request);
		}

		private function onComplete(e:Event):void {
			var data:ByteArray = _urlLoader.data as ByteArray;
			_exif = new ExifInfo(data);
			super.loadBytes(data, _context);
			_urlLoader = null;
			dispatchEvent(e);
		}

		private function forwardEvent(e:Event):void {
			dispatchEvent(e);
		}
	}
}
