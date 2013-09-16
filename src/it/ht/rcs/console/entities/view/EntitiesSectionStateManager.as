package it.ht.rcs.console.entities.view
{
	import flash.utils.Dictionary;
	
	import it.ht.rcs.console.accounting.controller.UserManager;
	import it.ht.rcs.console.agent.controller.AgentManager;
	import it.ht.rcs.console.agent.model.Agent;
	import it.ht.rcs.console.agent.model.Config;
	import it.ht.rcs.console.entities.controller.EntityManager;
	import it.ht.rcs.console.entities.model.Entity;
	import it.ht.rcs.console.entities.model.Link;
	import it.ht.rcs.console.events.DataLoadedEvent;
	import it.ht.rcs.console.events.SectionEvent;
	import it.ht.rcs.console.evidence.controller.EvidenceManager;
	import it.ht.rcs.console.monitor.controller.LicenseManager;
	import it.ht.rcs.console.operation.controller.OperationManager;
	import it.ht.rcs.console.operation.model.Operation;
	import it.ht.rcs.console.search.model.SearchItem;
	
	import locale.R;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.ListCollectionView;
	
	import spark.collections.Sort;
	import spark.collections.SortField;
	import spark.components.TextInput;
	import spark.globalization.SortingCollator;

	public class EntitiesSectionStateManager
	{

		[Bindable]
		public var view:ListCollectionView;

		[Bindable]
		public var tableView:ListCollectionView;

		[Bindable]
		public var selectedOperation:Operation;
		[Bindable]
		public var selectedEntity:Entity;
		//multiple selection
		[Bindable]
		public var selectedEntities:ArrayCollection;


		private var section:EntitiesSection;

		private var sort:Sort;

		public static var currInstance:EntitiesSectionStateManager;

		public function EntitiesSectionStateManager(section:EntitiesSection)
		{
      selectedEntities=new ArrayCollection();
      
			this.section=section;
			currInstance=this;

			sort=new Sort();
			sort.fields=[new SortField("type", true), new SortField("name", false)]

		}

		private function getItemFromEvent(event:SectionEvent):*
		{
			var item:SearchItem=event ? event.item : null;
			if (!item)
				return null;

			switch (item._kind)
			{
				case 'operation':
					return OperationManager.instance.getItem(item._id);

				case 'target':
					return EntityManager.instance.getEntityByTarget(item._id);

				case 'entity':
					return EntityManager.instance.getItem(item._id);

				default:
					return null;
			}
		}

		public function manageItemSelection(i:*, event:SectionEvent=null):void
		{
			var item:*=i || getItemFromEvent(event);
			if (!item)
				return;

			if (CurrentManager)
			{
				CurrentManager.instance.removeEventListener(DataLoadedEvent.DATA_LOADED, onDataLoaded);
				CurrentManager.instance.unlistenRefresh();
			}

			if (item is Operation)
			{
				selectedOperation=item;
				setState('singleOperation');
				UserManager.instance.add_recent(Console.currentSession.user, {id: selectedOperation._id, type: "operation", section: "intelligence"});
			}
			if (item is Entity) //&& event.subsection == "links") //event can be null
			{
				trace("is a link")
			/*	selectedOperation=OperationManager.instance.getItem(item.path[0]);
        currentFilter=singleOperationFilterFunction;
				setState("links")*/
			}

			else if (item is Entity)
			{
				selectedEntity=item;
				setState('singleEntity');
				UserManager.instance.add_recent(Console.currentSession.user, {id: selectedEntity._id, type: "entity", section: "intelligence"});

			}



		}

		private function clearVars():void
		{
			selectedOperation=null;
			selectedEntity=null;
		}

		private var currentState:String;

		public function setState(state:String):void
		{
			if (!state)
				return;
			currentState=state;
			if (CurrentManager)
			{
				CurrentManager.instance.removeEventListener(DataLoadedEvent.DATA_LOADED, onDataLoaded);
				CurrentManager.instance.unlistenRefresh();
			}
			switch (currentState)
			{
				case 'allOperations':
					clearVars();
					section.currentState='allOperations';
					CurrentManager=OperationManager;
					if (searchField)
						searchField.text='';
					currentFilter=searchFilterFunction;
					update();
					break;
				case 'singleOperation':
					selectedEntity=null;
					//selectedTarget = null; selectedAgent = null; selectedFactory = null; selectedConfig = null;
					section.currentState='singleOperation';
					CurrentManager=EntityManager;
					currentFilter=singleOperationFilterFunction;
					update();
					break;

				case 'singleEntity':
					//selectedTarget = null; selectedAgent = null; selectedFactory = null; selectedConfig = null;
					selectedOperation=OperationManager.instance.getItem(selectedEntity.path[0]);
					section.currentState='singleEntity';
					CurrentManager=EntityManager;
					currentFilter=singleOperationFilterFunction;
					update();
					break;

				case 'allEntities':
					clearVars();
					section.currentState='allEntities';
					CurrentManager=EntityManager;
					if (searchField)
						searchField.text='';
					currentFilter=searchFilterFunction;
					currentFilter=singleOperationFilterFunction;
					update();
					break;

        case 'links':
          section.currentState = 'links';
          CurrentManager = EntityManager;
          update();
          break;
				case 'map':
					section.currentState='map';
					CurrentManager=EntityManager;
					update();
					break;
				default:
					break;
			}
			if (CurrentManager)
			{
				CurrentManager.instance.addEventListener(DataLoadedEvent.DATA_LOADED, onDataLoaded);
				CurrentManager.instance.listenRefresh();
			}
		}

		private function onDataLoaded(e:DataLoadedEvent):void
		{
			setState(section.currentState);
		}

		private function update():void
		{

			view=getView();

			if (view)
				view.refresh();

			if (CurrentManager != null)
			{
				tableView=CurrentManager.instance.getView(null, currentFilter); //Sort + filter
				tableView.refresh();
			}
		}

		private function tableFilterFunction(item:Object):Boolean
		{
			if (item.hasOwnProperty('customType'))
				return false;
			else if (currentFilter != null)
				return currentFilter(item);
			else
				return true;
		}

		private function getView():ListCollectionView
		{
			var lcv:ListCollectionView;
			if (currentState == 'singleOperation')
			{
				trace("singleOperation")
				lcv=new ListCollectionView()
				var entities:ListCollectionView=EntityManager.instance.getView(null, currentFilter) //sort + filter

				var items:Array=new Array()
				var i:int=0;
				for (i=0; i < entities.length; i++)
				{
					items.push(entities.getItemAt(i))
				}

				lcv.list=new ArrayList(items);

			}

			else if (CurrentManager != null)
			{
				lcv=CurrentManager.instance.getView(sort, currentFilter);

			}

			lcv.filterFunction=currentFilter;
			lcv.sort=sort;
			lcv.refresh()
			return lcv;
		}

		private var CurrentManager:Class;
		private var currentSort:Sort;
		private var currentFilter:Function;

		// This reference is injected by the action bars, when they are displayed
		public var searchField:TextInput;

		private function searchFilterFunction(item:Object):Boolean
		{
			if (item is Entity)
			{
				if (!(Console.currentSession.user.is_view_profiles()))
					return false;
			}

			if (!searchField || searchField.text == '')
				return true;

			var result:Boolean=false;
			if (item && item.hasOwnProperty('name') && item.name)
				result=result || String(item.name.toLowerCase()).indexOf(searchField.text.toLowerCase()) >= 0;


			if (item && item.hasOwnProperty('desc') && item.desc)
				result=result || String(item.desc.toLowerCase()).indexOf(searchField.text.toLowerCase()) >= 0;


			return result;
		}

		private function singleOperationFilterFunction(item:Object):Boolean
		{
			if (selectedOperation && item is Entity && item.path[0] == selectedOperation._id)
				return searchFilterFunction(item);
			else
				return false;
		}

	}

}
