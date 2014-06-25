package it.ht.rcs.console.history
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import it.ht.rcs.console.events.SectionEvent;
	import it.ht.rcs.console.main.Sections;
	import it.ht.rcs.console.operations.view.OperationsSection;
	import it.ht.rcs.console.operations.view.OperationsSectionStateManager;

	import mx.core.FlexGlobals;

	[Bindable]
	public class HistoryManager extends EventDispatcher
	{

		private static var _instance:HistoryManager=new HistoryManager();

		public var numItems:int; //????
		public var history:Array;

		public var currentIndex:int=0;
		public var currentItem:HistoryItem;
		public var currentSection:String; //???
		public var sections:Sections


		public function HistoryManager()
		{
			super();

		}


		public function get length():int
		{
			if (!history)
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

		public function addItem(item:HistoryItem):void
		{
      var start:int=currentIndex ;  //TODO CHECK !
      var end:int=history.length - 1
      //var count:int=end-start
      
      if (end > start)
        history.splice(start+1)
          
			history.push(item);
			currentIndex=history.length - 1;
			numItems=history.length;
			currentItem=history[currentIndex] as HistoryItem;
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
			item.section=e.section;
			item.subSection=0;
			if (e.section == "Operations")
			{
				var section:OperationsSection=sections.Operations
          if(!section)
            return;
				item.state="allOperations"
				if (section.stateManager)
				{
					if (section.stateManager.selectedOperation)
					{
						item.state="singleOperation"
						item.operation=section.stateManager.selectedOperation
					}
					if (section.stateManager.selectedTarget)
					{
						item.state="singleTarget"
						item.target=section.stateManager.selectedTarget
					}
					if (section.stateManager.selectedAgent)
					{
						item.state="singleAgent"
						item.agent=section.stateManager.selectedAgent

					}
					if (section.stateManager.selectedFactory)
					{
						item.state="config"
						item.factory=section.stateManager.selectedFactory
					}
					if (section.stateManager.selectedConfig)
					{
						item.state="config"
						item.config=section.stateManager.selectedConfig
					}
				}
        else
        {
        trace("NO SECTION STATE MANAGER!!") //???
        }
			}
			addItem(item)
			dumpHistory()
		}

		public function back():void
		{
			trace("BACK");
			currentIndex--;
			FlexGlobals.topLevelApplication.removeEventListener(SectionEvent.CHANGE_SECTION, onSectionChange);
			var sectionEvent:SectionEvent=new SectionEvent(SectionEvent.CHANGE_SECTION);
			sectionEvent.section=history[currentIndex].section;
			//history.pop()
			FlexGlobals.topLevelApplication.dispatchEvent(sectionEvent);
			FlexGlobals.topLevelApplication.addEventListener(SectionEvent.CHANGE_SECTION, onSectionChange);
			numItems=history.length;
			currentItem=history[currentIndex] as HistoryItem;
			dumpHistory();
			dispatchEvent(new Event("change"))
		}


		public function dumpHistory():void
		{
			trace("==============")
			trace("HISTORY")
			trace("==============")

			for (var i:int=0; i < history.length; i++)
			{
				var item:HistoryItem=history[i] as HistoryItem
				trace("[" + i + "]")
				trace("section:   " + item.section)
				trace("sub:       " + item.subSection)
				trace("state:     " + item.state)
				if (item.operation)
					trace("operation: " + item.operation.name);
				if (item.target)
					trace("target:    " + item.target.name);
        if (item.entity)
          trace("entity:    " + item.entity.name);
				if (item.agent)
					trace("agent:     " + item.agent.name);
				if (item.config)
					trace("config:    " + item.config.config);

			}
			trace("==============")
			trace("index:   " + currentIndex)
		}


		public function forward():void
		{
			trace("FORWARD")
			currentIndex++
			FlexGlobals.topLevelApplication.removeEventListener(SectionEvent.CHANGE_SECTION, onSectionChange);
			var sectionEvent:SectionEvent=new SectionEvent(SectionEvent.CHANGE_SECTION);
			sectionEvent.section=history[currentIndex].section;
			FlexGlobals.topLevelApplication.dispatchEvent(sectionEvent);
			FlexGlobals.topLevelApplication.addEventListener(SectionEvent.CHANGE_SECTION, onSectionChange);
			numItems=history.length;
			currentItem=history[currentIndex] as HistoryItem;
			dumpHistory();
			dispatchEvent(new Event("change"))
		}


		public static function get instance():HistoryManager
		{
			return _instance;
		}
	}
}
