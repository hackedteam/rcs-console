package it.ht.rcs.console.operations.view
{
  import it.ht.rcs.console.accounting.controller.UserManager;
  import it.ht.rcs.console.agent.controller.AgentManager;
  import it.ht.rcs.console.agent.model.Agent;
  import it.ht.rcs.console.agent.model.Config;
  import it.ht.rcs.console.events.DataLoadedEvent;
  import it.ht.rcs.console.events.SectionEvent;
  import it.ht.rcs.console.evidence.controller.EvidenceManager;
  import it.ht.rcs.console.operation.controller.OperationManager;
  import it.ht.rcs.console.operation.model.Operation;
  import it.ht.rcs.console.search.model.SearchItem;
  import it.ht.rcs.console.target.controller.TargetManager;
  import it.ht.rcs.console.target.model.Target;
  
  import locale.R;
  
  import mx.collections.ArrayList;
  import mx.collections.ListCollectionView;
  import mx.controls.Alert;
  
  import spark.collections.Sort;
  import spark.components.TextInput;
  import spark.globalization.SortingCollator;

  public class OperationsSectionStateManager
  {
    
    [Bindable]
    public var view:ListCollectionView;

    [Bindable] public var selectedOperation:Operation;
    [Bindable] public var selectedTarget:Target;
    [Bindable] public var selectedAgent:Agent;
    [Bindable] public var selectedFactory:Agent;
    [Bindable] public var selectedConfig:Config;
    
    private var section:OperationsSection;
    
    private var customTypeSort:Sort;
    private var collator:SortingCollator;
    
    public static var currInstance:OperationsSectionStateManager;
    
    public function OperationsSectionStateManager(section:OperationsSection)
    {
      this.section = section;
      currInstance = this;
      
      collator = new SortingCollator();
      collator.ignoreCase = true;
      
      customTypeSort = new Sort();
      customTypeSort.compareFunction = customTypeCompareFunction;
    }
    
    public function goToEvidenceView(item:*):void
    {
      //EvidenceManager.instance.evidenceFilter;
    }
    
    private function getRealItem(event:SectionEvent):*
    {
      var item:SearchItem = event ? event.item : null;
      if (!item) return null;
      
      switch (item._kind) {
        case 'operation':
          return OperationManager.instance.getItem(item._id);
        case 'target':
          return TargetManager.instance.getItem(item._id);
        case 'agent':
        case 'factory':
          return AgentManager.instance.getItem(item._id);
        default:
          return null;;
      }
    }
    
    public function manageItemSelection(i:*, event:SectionEvent=null):void
    {
      var item:* = i || getRealItem(event);
      if (!item) return;
      
      if (item is Operation)
      {
        selectedOperation = item;
        setState('singleOperation');
        UserManager.instance.add_recent(Console.currentSession.user, new SearchItem(item));
      }
      
      else if (item is Target && (Console.currentSession.user.is_view() || Console.currentSession.user.is_tech()))
      {
        selectedTarget = item;
        setState('singleTarget');
        UserManager.instance.add_recent(Console.currentSession.user, new SearchItem(item));
      }
      
      else if (item is Agent && item._kind == 'agent')
      {
        selectedAgent = item;
        setState('singleAgent');
        UserManager.instance.add_recent(Console.currentSession.user, new SearchItem(item));
      }
      
      else if (item is Agent && item._kind == 'factory')
      {
        selectedFactory = item;
        setState('config');
        UserManager.instance.add_recent(Console.currentSession.user, new SearchItem(item));
      }
      
      else if (item is Config)
      {
        selectedConfig = item;
        setState('config');
      }
      
      else if (item is Object && item.hasOwnProperty('customType') && item.customType == 'configlist')
      {
        setState('agentConfigList');
      }
      
      else if (item is Object && item.hasOwnProperty('customType') && item.customType == 'evidence')
      {
        section.currentState = 'evidence';
      }
      
      else if (item is Object && item.hasOwnProperty('customType') && item.customType == 'filesystem')
      {
        section.currentState = 'filesystem';
        section.filesystem.showTree();
      }
      
      else if (item is Object && item.hasOwnProperty('customType') && item.customType == 'info')
      {
        section.currentState = 'info';
      }
      
      else if (item is Object && item.hasOwnProperty('customType') && item.customType == 'filetransfer')
      {
        section.currentState = 'filetransfer';
      }
      
      if (event && event.evidenceType)
      {
        section.currentState = 'evidence';
        EvidenceManager.instance.evidenceFilter.type = [event.evidenceType];
      }
    }
    
    private function clearVars():void
    {
      selectedOperation = null; selectedTarget = null; selectedAgent = null; selectedFactory = null; selectedConfig = null;
    }
    
    private var currentState:String;
    public function setState(state:String):void
    {
      
      currentState = state;
      if (CurrentManager) {
        CurrentManager.instance.removeEventListener(DataLoadedEvent.DATA_LOADED, onDataLoaded);
        CurrentManager.instance.unlistenRefresh();
      }
      switch (currentState) {
        case 'allOperations':
          clearVars();
          section.currentState = 'allOperations';
          CurrentManager = OperationManager;
          currentFilter = searchFilterFunction;
          update();
          break;
        case 'allTargets':
          clearVars();
          section.currentState = 'allTargets';
          CurrentManager = TargetManager;
          currentFilter = searchFilterFunction;
          update();
          break;
        case 'allAgents':
          clearVars();
          section.currentState = 'allAgents';
          CurrentManager = AgentManager;
          currentFilter = searchFilterFunction;
          update();
          break;
        
        case 'singleOperation':
          selectedTarget = null; selectedAgent = null; selectedFactory = null; selectedConfig = null;
          section.currentState = 'singleOperation';
          CurrentManager = TargetManager;
          currentFilter = singleOperationFilterFunction;
          update();
          break;
        case 'singleTarget':
          selectedAgent = null; selectedFactory = null; selectedConfig = null;
          selectedOperation = OperationManager.instance.getItem(selectedTarget.path[0]);
          section.currentState = 'singleTarget';
          CurrentManager = AgentManager;
          currentFilter = singleTargetFilterFunction;
          update();
          break;
        case 'singleAgent':
          selectedFactory = null; selectedConfig = null;
          selectedOperation = OperationManager.instance.getItem(selectedAgent.path[0]);
          selectedTarget = TargetManager.instance.getItem(selectedAgent.path[1]);
          section.currentState = 'singleAgent';
          CurrentManager = null;
          currentFilter = searchFilterFunction;
          update();
          break;
        
        case 'agentConfigList':
          section.currentState = 'agentConfigList';
          break;
        
        case 'config':
          var agent:Agent = selectedAgent ? selectedAgent : selectedFactory;
          selectedOperation = OperationManager.instance.getItem(agent.path[0]);
          selectedTarget = TargetManager.instance.getItem(agent.path[1]);
          if(section.configView)
            section.configView.currentState = 'blank';
          section.currentState = 'config';
          section.configView.getConfig();
          CurrentManager = null;
          currentFilter = searchFilterFunction;
          update();
          break;
	
        default:
          clearVars();
          CurrentManager = null;
          currentFilter = null;
          break;
      }
      if (CurrentManager) {
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
      removeCustomTypes(view);
      view = getView();
      removeCustomTypes(view);
      addCustomTypes(view);
    }
    
    private function removeCustomTypes(list:ListCollectionView):void
    {
      if (list != null && list.length > 0)
      for (var i:int = 0; i < list.length; i++)
        if (list.getItemAt(i).hasOwnProperty('customType')) {
          list.removeItemAt(i);
          i--;
        }
    }
    
    private function addCustomTypes(list:ListCollectionView):void
    {
      if (list == null) return;
      if ((currentState == 'singleTarget' || currentState == 'singleAgent') && (Console.currentSession.user.is_view())) {
        list.addItemAt({name: R.get('EVIDENCE'),    customType: 'evidence',     order: 0}, 0);
        list.addItemAt({name: R.get('FILE_SYSTEM'), customType: 'filesystem',   order: 1}, 0);
      }
      if (currentState == 'singleAgent') {
        list.addItemAt({name: R.get('INFO'),        customType: 'info',         order: 2}, 0);
        if (Console.currentSession.user.is_tech()) {
          list.addItemAt({name: R.get('CONFIG'),        customType: 'configlist',   order: 3}, 0);
          list.addItemAt({name: R.get('FILE_TRANSFER'), customType: 'filetransfer', order: 4}, 0);
        }
      }
    }
    
    private function getView():ListCollectionView
    {
      var lcv:ListCollectionView;
      if (CurrentManager != null) {
        lcv = CurrentManager.instance.getView(customTypeSort, currentFilter);
      } else if (currentState == 'singleAgent') {
        lcv = new ListCollectionView(new ArrayList());
        lcv.sort = customTypeSort;
        lcv.filterFunction = currentFilter;
        lcv.refresh();
      }
      return lcv;
    }
    
    private var CurrentManager:Class;
    private var currentSort:Sort;
    private var currentFilter:Function;
    
    // First, custom types, custom order
    // Second, factories, alphabetical oder
    // Third, agents, alphabetical order
    private function customTypeCompareFunction(a:Object, b:Object, fields:Array=null):int
    {
      if (!a && !b) return  0;
      if ( a && !b) return  1;
      if (!a &&  b) return -1;
      
      var aIsCustom:Boolean  = a.hasOwnProperty('customType');
      var aIsFactory:Boolean = a._kind == 'factory';
      var bIsCustom:Boolean  = b.hasOwnProperty('customType');
      var bIsFactory:Boolean = b._kind == 'factory';

      if (aIsCustom && bIsCustom) {
        var distance:int = a.order - b.order;
        return distance / Math.abs(distance);
      }
      if (aIsCustom) return -1;
      if (bIsCustom) return  1;
      
      if ((aIsFactory && bIsFactory) || (!aIsFactory && !bIsFactory))
        return collator.compare(a.name, b.name); // 0
      
      return aIsFactory ? -1 : 1;
    }
    
    // This reference is injected by the action bars, when they are displayed
    public var searchField:TextInput;
    private function searchFilterFunction(item:Object):Boolean
    {
      if (!searchField || searchField.text == '')
        return true;
      
      var result:Boolean = false;
      if (item && item.hasOwnProperty('name') && item.name)
        result = result || String(item.name.toLowerCase()).indexOf(searchField.text.toLowerCase()) >= 0;
      
      if (item && item.hasOwnProperty('instance') && item.instance)
        result = result || String(item.instance.toLowerCase()).indexOf(searchField.text.toLowerCase()) >= 0;
      
      if (item && item.hasOwnProperty('desc') && item.desc)
        result = result || String(item.desc.toLowerCase()).indexOf(searchField.text.toLowerCase()) >= 0;
      
      return result;
    }
    
    private function singleOperationFilterFunction(item:Object):Boolean
    {
      if (selectedOperation && item is Target && item.path[0] == selectedOperation._id)
        return searchFilterFunction(item);
      else return false;
    }
    
    private function singleTargetFilterFunction(item:Object):Boolean
    {
      if (item.hasOwnProperty('customType'))
        return searchFilterFunction(item);
      if (selectedTarget && item is Agent && item.path[1] == selectedTarget._id)
        if (!(Console.currentSession.user.is_tech()) && item._kind == 'factory')
          return false;
        else
          return searchFilterFunction(item);
      else return false;
    }
    
  }
  
}