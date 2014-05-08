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
	public class StageWebviewDiskEvent extends Event
	{
		
		/**
		 * Dispatched when disk parsing start
		 * 
		 * @eventType START_DISK_PARSING 
		 */
		public static const START_DISK_PARSING : String = "START_DISK_PARSING";

		/**
		 * Dispatched when disk parsing ends
		 * 
		 * @eventType END_DISK_PARSING 
		 */		
		public static const END_DISK_PARSING : String = "END_DISK_PARSING";

		public function StageWebviewDiskEvent( type : String, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super( type, bubbles, cancelable );
			
		}
	}
}
