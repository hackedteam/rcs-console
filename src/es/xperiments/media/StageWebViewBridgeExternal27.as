/*
Copyright 2011 Pedro Casaubon

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
package es.xperiments.media
{
	/*import by.blooddy.crypto.serialization.JSON;*/

	import es.xperiments.utils.Base64;

	import flash.events.EventDispatcher;

	public class StageWebViewBridgeExternal27 extends EventDispatcher
	{
		private var _activeStage:StageWebViewBridge;
		private var _serializeObject:Object;
		private var _callBacks:Array;
		private var _callBackFunction:Function;
		
		/**
		 * Contructor
		 * @param stageWebView The stagewebview instance 
		 */
		public function StageWebViewBridgeExternal27( stageWebView : StageWebViewBridge )
		{
			_activeStage = stageWebView;
			_callBacks = new Array();
		}

		/**
		 * Makes a call to a javascript function
		 * @param functionName Name of the function to call
		 * @param callback The callback function to execute when javascript call is processed
		 * @param arguments Coma separated arguments to pass to Javascript function
		 */
		internal function call(functionName:String, callback:Function = null,  ... arguments):void
		{
			_serializeObject = {};  
			_serializeObject['method'] = functionName;
			_serializeObject['arguments'] = arguments;
			if( callback!=null )
			{
				addCallback('[SWVMethod]'+functionName, callback );
				_serializeObject['callBack'] = '[SWVMethod]'+functionName;
			}	
//			_activeStage.loadURL("javascript:StageWebViewBridge.doCall('"+Base64.encodeString( JSON.encode( _serializeObject ) ) +"')");
		}

		/**
		 * Add a callback function to the current list of avaliable callbacks
		 * @param name the name of the callback function in this format : [SWVMethod]( name )
		 * @param callback The callback function 
		 */
		internal function addCallback( name:String, callback:Function ):void
		{
			_callBacks[ name ] = callback;
		}	


		/**
		 * Proceses a call from javascript
		 * @param base64String Json Object in base64
		 */

		internal function parseCallBack( base64String:String ):void
		{
//			_serializeObject = JSON.decode( Base64.decode( base64String ).toString() );
			_callBackFunction = _callBacks[ _serializeObject['method'] ];
			var returnValue:* = null;

			if( _serializeObject['arguments'].length!=0 )
			{
				returnValue = _callBackFunction.apply(null, _serializeObject.arguments );
			}
			else
			{
				returnValue = _callBackFunction();
			}
			if(_serializeObject['callBack']!=undefined && returnValue!=null )
			{
				call( _serializeObject['callBack'], null, returnValue );
			}	
		}	
	}
}