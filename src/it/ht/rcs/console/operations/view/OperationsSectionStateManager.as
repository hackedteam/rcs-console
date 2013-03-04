package it.ht.rcs.console.operations.view
{
  import flash.utils.Dictionary;
  
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
  import it.ht.rcs.console.monitor.controller.LicenseManager;
  
  import locale.R;
  
  import mx.collections.ArrayList;
  import mx.collections.ListCollectionView;
  
  import spark.collections.Sort;
  import spark.collections.SortField;
  import spark.components.TextInput;
  import spark.globalization.SortingCollator;

  public class OperationsSectionStateManager
  {
    
    [Bindable]
    public var view:ListCollectionView;
    
    [Bindable]
    public var tableView:ListCollectionView;

    [Bindable] public var selectedOperation:Operation;
    [Bindable] public var selectedTarget:Target; 
    [Bindable] public var selectedAgent:Agent;
    [Bindable] public var selectedFactory:Agent;
    [Bindable] public var selectedConfig:Config;
    
    private var section:OperationsSection;
    
    private var customTypeSort:Sort;
    private var tableSort:Sort;
    private var collator:SortingCollator;
    
    public static var currInstance:OperationsSectionStateManager;
    
    public function OperationsSectionStateManager(section:OperationsSection)
    {
      this.section = section;
      currInstance = this;
      
      collator = new SortingCollator();
      collator.ignoreCase = true;
      collator.numericComparison=true;
      
      customTypeSort = new Sort();
      customTypeSort.compareFunction = customTypeCompareFunction;
      
      tableSort = new Sort();
      tableSort.compareFunction = customTypeCompareFunction;
    }
    
    private function getItemFromEvent(event:SectionEvent):*
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
          return null;
      }
    }
    
    public function manageItemSelection(i:*, event:SectionEvent=null):void
    {
      var item:* = i || getItemFromEvent(event);
      if (!item) return;
      
      if (CurrentManager) {
        CurrentManager.instance.removeEventListener(DataLoadedEvent.DATA_LOADED, onDataLoaded);
        CurrentManager.instance.unlistenRefresh();
      }
      
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
      
      else if (item is Agent && item._kind == 'factory' && Console.currentSession.user.is_tech_config())
      {
        selectedFactory = item;
        selectedConfig = null;
        setState('config');
        UserManager.instance.add_recent(Console.currentSession.user, new SearchItem(item));
      }
      
      else if (item is Config && Console.currentSession.user.is_tech_config())
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
        EvidenceManager.instance.refresh();
      }
      
      else if (item is Object && item.hasOwnProperty('customType') && item.customType == 'filesystem')
      {
        section.currentState = 'filesystem';
      }
      
      else if (item is Object && item.hasOwnProperty('customType') && item.customType == 'info')
      {
        section.currentState = 'info';
      }
      
      else if (item is Object && item.hasOwnProperty('customType') && item.customType == 'filetransfer')
      {
        section.currentState = 'filetransfer';
      }
      else if (item is Object && item.hasOwnProperty('customType') && item.customType == 'commands')
      {
        section.currentState = 'commands';
      }
      else if (item is Object && item.hasOwnProperty('customType') && item.customType == 'ipaddresses')
      {
        section.currentState = 'ipaddresses';
      }
      
      if (event && event.subsection == 'evidence')
      {
        section.currentState = 'evidence';
       
        if (event.evidenceTypes)
          EvidenceManager.instance.evidenceFilter.type = event.evidenceTypes;
        else delete(EvidenceManager.instance.evidenceFilter.type);
        
        if (event.evidenceIds) {
          EvidenceManager.instance.evidenceFilter.date = 'dr';
          EvidenceManager.instance.evidenceFilter.from = event.from; //0
          EvidenceManager.instance.evidenceFilter.to = event.to; //0
          EvidenceManager.instance.evidenceFilter._id = event.evidenceIds;
        }
        else delete(EvidenceManager.instance.evidenceFilter._id);
        
        if(event.info)
        {
          EvidenceManager.instance.evidenceFilter.info=event.info;
        }
        else
        {
          delete(EvidenceManager.instance.evidenceFilter.info);
        }
        if(event.from)
        {
          EvidenceManager.instance.evidenceFilter.date = 'da';
          EvidenceManager.instance.evidenceFilter.from = event.from;
          EvidenceManager.instance.evidenceFilter.to = event.to;
        }
        else
        {
          delete (EvidenceManager.instance.evidenceFilter.date);
          delete (EvidenceManager.instance.evidenceFilter.from);
          delete (EvidenceManager.instance.evidenceFilter.to);
        }
        section.evidenceView.refreshData();
      }
    }
    
    private function clearVars():void
    {
      selectedOperation = null; selectedTarget = null; selectedAgent = null; selectedFactory = null; selectedConfig = null;
    }
    
    private var currentState:String;
    public function setState(state:String):void
    {
      if (!state) return;
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
          if(searchField) searchField.text='';
          currentFilter = searchFilterFunction;
          update();
          break;
        case 'allTargets':
          clearVars();
          section.currentState = 'allTargets';
          CurrentManager = TargetManager;
          if(searchField) searchField.text='';
          currentFilter = searchFilterFunction;
          update();
          break;
        case 'allAgents':
          clearVars();
          section.currentState = 'allAgents';
          CurrentManager = AgentManager;
          if(searchField) searchField.text='';
          currentFilter = searchFilterFunction;
          prepareAgentsDictionary();
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
          prepareAgentsDictionary();
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
          selectedConfig = null;
          section.currentState = 'agentConfigList';
          break;
        
        case 'config':
          var agent:Agent;
          if (selectedFactory) {
            agent = selectedFactory;
            selectedAgent = null;
          } else {
            agent = selectedAgent;
            selectedFactory = null;
          }
          selectedOperation = OperationManager.instance.getItem(agent.path[0]);
          if(agent.path.length>1)
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
      if (view)
        view.refresh();
      
      if (CurrentManager != null) {
        tableView = CurrentManager.instance.getView(tableSort, tableFilterFunction);
        tableView.refresh();
      }
    }
    
    private function tableFilterFunction(item:Object):Boolean
    {
      if (item.hasOwnProperty('customType')) return false;
      else if (currentFilter != null)
        return currentFilter(item);
      else return true;
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
        if(Console.currentSession.user.is_view_filesystem())
        {
        list.addItemAt({name: R.get('FILE_SYSTEM'), customType: 'filesystem',   order: 1}, 0);
        }
      }
      if (currentState == 'singleAgent') {
        list.addItemAt({name: R.get('INFO'),        customType: 'info',         order: 3}, 0);
        if(LicenseManager.instance.modify)
        {
          list.addItemAt({name: R.get('COMMANDS'),        customType: 'commands',         order: 4}, 0);
        }
        list.addItemAt({name: R.get('IP_ADDRESS'),        customType: 'ipaddresses',         order: 5}, 0);
        if (Console.currentSession.user.is_tech()) {
          list.addItemAt({name: R.get('CONFIG'),        customType: 'configlist',   order: 2}, 0);
          list.addItemAt({name: R.get('FILE_TRANSFER'), customType: 'filetransfer', order: 6}, 0);
         
        }
      }
    }
    
    private function getView():ListCollectionView
    {
      var lcv:ListCollectionView;
      if(currentState == 'singleOperation')
      {
 
        lcv=new ListCollectionView()
        var targets:ListCollectionView=TargetManager.instance.getView(customTypeSort, currentFilter);
        var factories:ListCollectionView=AgentManager.instance.getFactoriesForOperation(selectedOperation._id);
        var items:Array=new Array()
        var i:int=0;
          for(i=0;i<targets.length;i++)
          {
            items.push(targets.getItemAt(i))
          }
          for(i=0;i<factories.length;i++)
          {
            items.push(factories.getItemAt(i))
          }
        lcv.list=new ArrayList(items);
        lcv.filterFunction = currentFilter;
        lcv.refresh();
     
      }
      
      else if (CurrentManager != null) {
        lcv = CurrentManager.instance.getView(customTypeSort, currentFilter);
      } 
     
      
      else if (currentState == 'singleAgent') {
        lcv = new ListCollectionView(new ArrayList());
        lcv.sort = customTypeSort;
        lcv.filterFunction = currentFilter;
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
      if ( a && !b) return -1;
      if (!a &&  b) return  1;
      
      var aIsCustom:Boolean  = a.hasOwnProperty('customType');
      var bIsCustom:Boolean  = b.hasOwnProperty('customType');
      
      if (aIsCustom && bIsCustom) {
        var distance:int = a.order - b.order;
        return distance / Math.abs(distance);
      }
      if (aIsCustom) return -1;
      if (bIsCustom) return  1;
      
      var aIsAgent:Boolean = a is Agent;
      var bIsAgent:Boolean = b is Agent;
      //agent
      if (aIsAgent && bIsAgent) {
        
        var aIsFactory:Boolean = a._kind == 'factory';
        var bIsFactory:Boolean = b._kind == 'factory';
        
        if (aIsFactory && bIsFactory)
          return collator.compare(a.name, b.name);
        
        if (!aIsFactory && !bIsFactory) {
          if (a.ident == b.ident)
            return collator.compare(a.name, b.name);
          return collator.compare(getFactory(a.ident).name, getFactory(b.ident).name);
        }
        
        if (aIsFactory && !bIsFactory) {
          if (a.ident == b.ident) return -1;
          return collator.compare(a.name, getFactory(b.ident).name);
        }
        
        if (!aIsFactory && bIsFactory) {
          if (a.ident == b.ident) return 1;
          return collator.compare(getFactory(a.ident).name, b.name);
        }
        
      }
      //end agent
      return collator.compare(a.name, b.name);
      
    }
    
    private var agentsDict:Dictionary;
    private function prepareAgentsDictionary():void {
      agentsDict = new Dictionary(true);
      for each (var agent:Object in AgentManager.instance.getView())
        if (agent is Agent && agent._kind == 'factory')
          agentsDict[agent.ident] = agent;
    }
    
    private function getFactory(ident:String):Object {
      var f:Agent = agentsDict[ident];
      return f ? f : {name: ''};
    }
    
    // This reference is injected by the action bars, when they are displayed
    public var searchField:TextInput;
    private function searchFilterFunction(item:Object):Boolean
    {
      if(item is Agent)// show factory to tech users only
      {
        if (!(Console.currentSession.user.is_tech_factories()) && item._kind == 'factory')
          return false;
      }
      
      if (!searchField || searchField.text == '')
        return true;
      
      var result:Boolean = false;
      if (item && item.hasOwnProperty('name') && item.name)
        result = result || String(item.name.toLowerCase()).indexOf(searchField.text.toLowerCase()) >= 0;
      
      if (item && item.hasOwnProperty('instance') && item.instance)
        result = result || String(item.instance.toLowerCase()).indexOf(searchField.text.toLowerCase()) >= 0;
      
      if (item && item.hasOwnProperty('desc') && item.desc)
        result = result || String(item.desc.toLowerCase()).indexOf(searchField.text.toLowerCase()) >= 0;
      
      if (item && item.hasOwnProperty('ident') && item.ident)
        result = result || String(item.desc.toLowerCase()).indexOf(searchField.text.toLowerCase()) >= 0;
      //
     
      return result;
    }
    
    private function singleOperationFilterFunction(item:Object):Boolean
    {
      if (selectedOperation && ((item is Target && item.path[0] == selectedOperation._id) || ( item is Agent && item._kind == 'factory' && item.path.length==1 && item.path[0] == selectedOperation._id)))
      {
        return searchFilterFunction(item);
      }
      return false;
    }
    
    
    
    private function singleTargetFilterFunction(item:Object):Boolean
    {
      if (item.hasOwnProperty('customType'))
        return true;//return searchFilterFunction(item);
     if(selectedTarget && item.path && item.path.length>1)
     {
       if (selectedTarget && item is Agent && item.path[1] == selectedTarget._id)
         if (!(Console.currentSession.user.is_tech_factories()) && item._kind == 'factory')
           return false;
         else
           return searchFilterFunction(item);
         else return false;
     }
     return false;
    }
    
  
    
  }
  
}