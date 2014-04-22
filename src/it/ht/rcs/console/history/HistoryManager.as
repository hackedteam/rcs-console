package it.ht.rcs.console.history
{
	import flash.events.EventDispatcher;
	
	import it.ht.rcs.console.events.SectionEvent;
	
	import mx.core.FlexGlobals;

	[Bindable]
	public class HistoryManager extends EventDispatcher
	{

		private static var _instance:HistoryManager=new HistoryManager();

		public var numItems:int; //????
		public var history:Array;

		public var currentIndex:int=0;
    public var currentItem:HistoryItem;


		public function HistoryManager()
		{
			super();

		}


		public function get length():int
		{
      if(!history)
        return 0;
			return history.length
		}

		public function init():void
		{
			trace("HISTORY MANAGER INIT");
			history=new Array();
			var item:HistoryItem=new HistoryItem();
			item.section="Home"
			item.subSection=0;

			history.push(item);
			numItems=history.length;
			currentIndex=0;

			FlexGlobals.topLevelApplication.addEventListener(SectionEvent.CHANGE_SECTION, onSectionChange)
        
      currentItem=history[currentIndex] as HistoryItem
			dumpHistory()
		}

		private function onSectionChange(e:SectionEvent):void
		{

			var start:int=currentIndex + 1;
			var end:int=history.length - 1
			//var count:int=end-start

			if (end > start)
				history.splice(start)

			trace("SECTION CHANGE: " + e.section);
			var item:HistoryItem=new HistoryItem();
			item.section=e.section
			item.subSection=0;
			history.push(item);
			currentIndex=history.length - 1
			numItems=history.length
      currentItem=history[currentIndex] as HistoryItem
			//dump history for debugging

			//put at the end of array



			dumpHistory()
		}

		public function back():void
		{
			trace("BACK")
			currentIndex--
			FlexGlobals.topLevelApplication.removeEventListener(SectionEvent.CHANGE_SECTION, onSectionChange)
			var sectionEvent:SectionEvent=new SectionEvent(SectionEvent.CHANGE_SECTION);
			sectionEvent.section=history[currentIndex].section;
			//history.pop()
			FlexGlobals.topLevelApplication.dispatchEvent(sectionEvent);
			FlexGlobals.topLevelApplication.addEventListener(SectionEvent.CHANGE_SECTION, onSectionChange)
			numItems=history.length
      currentItem=history[currentIndex] as HistoryItem
			dumpHistory()
		}


		private function dumpHistory():void
		{
			trace("==============")
			trace("HISTORY")
			trace("==============")

			for (var i:int=0; i < history.length; i++)
			{
				var item:HistoryItem=history[i] as HistoryItem
				trace("[" + i + "]")
				trace("section: " + item.section)
				trace("sub:     " + item.subSection)
			}
			trace("==============")
			trace("index:   " + currentIndex)
		}


		public function forward():void
		{
			trace("FORWARD")
      currentIndex++
      FlexGlobals.topLevelApplication.removeEventListener(SectionEvent.CHANGE_SECTION, onSectionChange)
      var sectionEvent:SectionEvent=new SectionEvent(SectionEvent.CHANGE_SECTION);
      sectionEvent.section=history[currentIndex].section;
      FlexGlobals.topLevelApplication.dispatchEvent(sectionEvent);
      FlexGlobals.topLevelApplication.addEventListener(SectionEvent.CHANGE_SECTION, onSectionChange)
      numItems=history.length
      currentItem=history[currentIndex] as HistoryItem
			dumpHistory()
		}


		public static function get instance():HistoryManager
		{
			return _instance;
		}
	}
}
