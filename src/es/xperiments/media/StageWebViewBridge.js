(function(window)
{
	window.StageWebViewBridge = (function()
	{         
	/* PROPIERTIES */
		
		/* Stores callBack functions */
		var callBacks = [];
		
		/* Stores StageWebViewBridge.ready() functions */
		var onReadyHandlers = [];
		
		/* Stores the extensions parsed with the cache System */
		var cached_extensions = [];
		
		/* Stores the default function called on DOMContentLoaded */ 
		var DOMContentLoadedCallBack =function(){ return null };
		
		/* Stores the default function called on deviceReady */
		var devicereadyCallBack = function(){};
		
		/* Stores the default root path of filesystem */
		var rootPath = "";
		
		/* Stores the documentsDirectory path of filesystem */
		var docsPath = "";
		
		/* Stores the default sourceFolder path of filesystem */
		var sourcePath = "";
		
		/* Stores the regexp used to filter files by extension */
		var fileRegex;
		
		/* Used by the .ready method to store temporally callback function called in fakeEvent Dispathch */
		var currentReadyHandler;
		
		/* Used to determine OS */
		var checker =
		{
		  iphone: navigator.userAgent.match(/(iPhone|iPod|iPad)/) === null ? false:true,
		  android: navigator.userAgent.match(/Android/) === null ? false: navigator.platform.match(/Linux/) == null ? false:true
		};		
		
		/* Used to determine if the paths has been initialized */
		var pathsReady = false;
		
		/* Used to determine last time call to AS3 was made */
		var lastCallTime = new Date().getTime();
		
		/* Used to determine the delay between calls to AS3 */
		var aggregatedCallDelay = 0;
		
		/* Used to determine the minimun consecutive delay between calls to AS3 */
		/* AT YOUR RISK!!!!! Use StageWebViewBridge.setCallDelay( ms ), to change the default value. */
		var defaultCallDelay = 500;
		
		/* Used to determine the "protocol" to do the comm with AS3 */
		var sendingProtocol = checker.iphone ? 'about:':'tuoba:';		

	/* METHODS */	
		
		/* Used internally to parse call funcions from AS3 */
		var doCall = function( jsonArgs )
		{
			setTimeout(function() { deferredDoCall(jsonArgs); },0 );
		};
	    
		/* Used internally to parse call funcions from AS3 */
		var deferredDoCall = function( jsonArgs )
		{
			var _serializeObject = JSON.parse( atob( jsonArgs ) );
			var method = _serializeObject.method;
			var returnValue = true;
			if( method.indexOf('[SWVMethod]')==-1 )
			{			
				var targetFunction;
				if( method.indexOf('.')==-1)
				{
					targetFunction = window[ method ];
				}
				else
				{
					var splitedPath = method.split('.');
					targetFunction=window;
					for( var i=0; i<splitedPath.length; i++ )
					{
						targetFunction = targetFunction[ splitedPath[ i ] ];
					};
				};
				returnValue = targetFunction.apply(null, _serializeObject.arguments );
			}
			else
			{
				var targetFunction = callBacks[ method ];
				returnValue = targetFunction.apply(null, _serializeObject.arguments );
			};

			if( _serializeObject.callBack !=undefined  )
			{	
				call( _serializeObject.callBack, null, returnValue );  		
			};							
		};
		
		/* Used to call an AS3 function. */
		/* Usage: StageWebViewBridge.call( 'as3FunctionToCall', jsCallBack, ...restParams ) */
		var call = function( )
		{
			
			aggregatedCallDelay = ( new Date().getTime()  - lastCallTime < defaultCallDelay ) ? aggregatedCallDelay+defaultCallDelay:0;
			
			var argumentsArray = [];
			var _serializeObject = {};
				_serializeObject.method = arguments[ 0 ];
			if( arguments[ 1 ] !=null ) _serializeObject.callBack = '[SWVMethod]'+arguments[ 0 ];

			if( arguments.length>2)
			{
				for (var i = 2; i < arguments.length; i++)
				{
					argumentsArray.push( arguments[ i ] );
				};
			};

			_serializeObject.arguments = argumentsArray;
			if( _serializeObject.callBack !=undefined ) { addCallback('[SWVMethod]'+arguments[ 0 ], arguments[ 1 ] ); };
			setTimeout( function(){ window.location.href=sendingProtocol+'[SWVData]'+btoa( JSON.stringify( _serializeObject ) );},aggregatedCallDelay );			
			
			lastCallTime = new Date().getTime();
			
		};

		/* Used to change the defaultCallDelay value. */
		var setCallDelay = function( ms )
		{
			defaultCallDelay = ms;
		};
		
		
		/* Used internally to store callback functions for call methods */
		var addCallback = function( name, fn )
		{
			callBacks[ name ] = fn;
		};
		
		/* Use it to get the path to a file from JS */
		var getFilePath = function( fileName )
		{
			if( !pathsReady )
			{
				throw "StageWebViewBridge.getFilePath('"+fileName+"').Paths still not set. Listen to document.deviceready event before access this method.";
			}
			else
			{	
				if( fileName.indexOf('jsfile:') !=-1 )
				{	
					if( fileRegex.exec(fileName) != null )
					{
						return rootPath+'/'+fileName.split('jsfile:/')[1];
					}
					else
					{
						return sourcePath+'/'+fileName.split('jsfile:/')[1];
					};
				};
				if( fileName.indexOf('jsdocfile:') !=-1 )
				{	
					return docsPath+'/'+fileName.split('jsdocfile:/')[1];
				};
			}
		};
		/* fakeEventDispatcher */
		var dispatchFakeEvent = function( name )
		{
			var fakeEvent = document.createEvent("UIEvents");
			fakeEvent.initEvent( name , false,false );
			document.dispatchEvent(fakeEvent);
		};		
		
		/*[Event("ready")]*/
		var ready = function( handler )
		{
			onReadyHandlers.push( handler );
		};
		
		/* Fired on DOMContentLoaded */
		var onReady = function( )
		{
			document.addEventListener('SWVBReady', function()
			{
				currentReadyHandler();
			}, false );
	
			for (var i=0; i<onReadyHandlers.length; i++)
			{
				currentReadyHandler = onReadyHandlers[ i ];
				dispatchFakeEvent("SWVBReady");
			};
		
		};
		
		/* Called from AS3 on loadComplete. */
		var onGetFilePaths = function( data )
		{          
			document.title = new Date().getTime();
			sourcePath = data.sourcePath;
			rootPath = data.rootPath;
			docsPath = data.docsPath;
			cached_extensions =  data.extensions;
			fileRegex =new RegExp(( "\(jsfile:\/\)\(\[\\w\-\\\.\\\/%\]\+\("+cached_extensions.join('\|')+"\)\)" ),"gim");
			pathsReady = true;
			devicereadyCallBack();
			setTimeout( function(){ call('___onDeviceReady'); }, 1);
		};
		
		/* Assign a callback function that executes the on deviceready */
		var deviceReady = function( fn )
		{
			devicereadyCallBack = fn;
		};
		
		/* Assign a callback function that returns an object to the DOMContentLoaded event */
		var domLoaded = function( fn )
		{
			DOMContentLoadedCallBack = fn;
		};
		
		/* Call AS3 to fire StageWebViewBridgeEvent.DOM_LOADED */
		var callDOMContentLoaded = function()
		{          
			document.removeEventListener( 'DOMContentLoaded', callDOMContentLoaded, false );
			call( '___onDomReady', onReady,  DOMContentLoadedCallBack() );
		};
		
		/* Fired on page load complete */
		var loadComplete = function()
		{
			document.removeEventListener('load', loadComplete, false );
			call('___getFilePaths', onGetFilePaths );		
		};
		
		/* Listen for page load complete */
		window.addEventListener( 'load', loadComplete, false );
		
		/* Listen for DOMContentLoaded */
		document.addEventListener('DOMContentLoaded', callDOMContentLoaded, false );
		
		/* Return public methods */
		return {
			doCall: doCall,
            call: call,
			getFilePath:getFilePath,
			ready:ready,
			deviceReady:deviceReady,
			domLoaded:domLoaded,
			setCallDelay:setCallDelay
		};
	})();
})(window);