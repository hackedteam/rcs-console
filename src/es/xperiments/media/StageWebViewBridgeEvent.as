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
	import flash.events.Event;

	/**
	 * @author xperiments
	 */
	public class StageWebViewBridgeEvent extends Event
	{
		/**
		 * Dispatched when the snapshot of the StageWebView is done
		 * 
		 * @eventType ON_GET_SNAPSHOT 
		 */		
		public static const ON_GET_SNAPSHOT : String = "ON_GET_SNAPSHOT";
		
		/**
		 * Dispatched when Html DOMContentLoaded gets fired
		 * 
		 * @eventType DOM_LOADED 
		 */		
		public static const DOM_LOADED : String = "DOM_LOADED";
		
		/**
		 * Dispatched when bidirectional connection is stablished and working
		 * 
		 * @eventType DEVICE_READY 
		 */		
		public static const DEVICE_READY : String = "DEVICE_READY";
		public var domLoadedData:Object = null;
		public function StageWebViewBridgeEvent( type : String, data:Object = null, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super( type, bubbles, cancelable );
			domLoadedData = data;
			
		}
	}
}
