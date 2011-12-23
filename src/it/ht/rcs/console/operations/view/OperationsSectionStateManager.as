package it.ht.rcs.console.operations.view
{
  import it.ht.rcs.console.agent.controller.AgentManager;
  import it.ht.rcs.console.agent.model.Agent;
  import it.ht.rcs.console.agent.model.Config;
  import it.ht.rcs.console.operation.controller.OperationManager;
  import it.ht.rcs.console.operation.model.Operation;
  import it.ht.rcs.console.target.controller.TargetManager;
  import it.ht.rcs.console.target.model.Target;
  
  import locale.R;
  
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
    [Bindable] public var selectedConfig:Config;
    
    private var section:OperationsSection;
    
    private var customTypeSort:Sort;
    private var collator:SortingCollator;
    public function OperationsSectionStateManager(section:OperationsSection)
    {
      this.section = section;
      
      collator = new SortingCollator();
      collator.ignoreCase = true;
      
      customTypeSort = new Sort();
      customTypeSort.compareFunction = customTypeCompareFunction;
    }
    
    public function manageItemSelection(item:*):void
    {
      
      if (item is Operation)
      {
        selectedOperation = item;
        setState('singleOperation');
      }
      
      else if (item is Target)
      {
        selectedTarget = item;
        setState('singleTarget');
      }
      
      else if (item is Agent /* && item._kind == 'agent' */)
      {
        selectedAgent = item;
        setState('singleAgent');
      }
      
      else if (item is Agent /* && item._kind == 'factory' */)
      {
        selectedAgent = item;
        setState('factoryConfig');
      }
            
      else if (item is Config)
      {
        selectedConfig = item;
        setState('agentConfig');
      }
      
      else if (item is Object && item.customType == 'config')
      {
        section.currentState = 'configList';
      }
      
      else if (item is Object && item.customType == 'evidences')
      {
        section.currentState = 'evidences';
      }
      
      else if (item is Object && item.customType == 'filesystem')
      {
        Alert.show('Show Filesystem Component');
      }
      
      else if (item is Object && item.customType == 'info')
      {
        Alert.show('Show Info Component');
      }
      
    }
    
    private var currentState:String;
    public function setState(state:String):void
    {
      
      currentState = state;
      
      switch (currentState) {
        case 'allOperations':
          selectedOperation = null; selectedTarget = null; selectedAgent = null;
          section.currentState = 'allOperations';
          CurrentManager = OperationManager;
          currentFilter = searchFilterFunction;
          update();
          break;
        case 'allTargets':
          selectedOperation = null; selectedTarget = null; selectedAgent = null;
          section.currentState = 'allTargets';
          CurrentManager = TargetManager;
          currentFilter = searchFilterFunction;
          update();
          break;
        case 'allAgents':
          selectedOperation = null; selectedTarget = null; selectedAgent = null;
          section.currentState = 'allAgents';
          CurrentManager = AgentManager;
          currentFilter = searchFilterFunction;
          update();
          break;
        
        case 'singleOperation':
          selectedTarget = null; selectedAgent = null;
          section.currentState = 'singleOperation';
          CurrentManager = TargetManager;
          currentFilter = singleOperationFilterFunction;
          update();
          break;
        case 'singleTarget':
          selectedOperation = OperationManager.instance.getItem(selectedTarget.path[0]);
          selectedAgent = null;
          section.currentState = 'singleTarget';
          CurrentManager = AgentManager;
          currentFilter = singleTargetFilterFunction;
          update();
          break;
        case 'singleAgent':
          selectedOperation = OperationManager.instance.getItem(selectedAgent.path[0]);
          selectedTarget = TargetManager.instance.getItem(selectedAgent.path[1]);
          section.currentState = 'singleAgent';
          CurrentManager = null;
          currentFilter = searchFilterFunction;
          update();
          break;
        default:
          break;
      }
      
    }
    
    private function update():void
    {
      //stopManagers();
      
//      var originalData:ListCollectionView = CurrentManager ? CurrentManager.instance.getView() : null;
//      
//      var currentData:ListCollectionView = new ListCollectionView(new ArrayList());
//      if (originalData)
//        currentData.addAll(originalData);
//      
//      currentData.sort = customTypeSort;
//      currentData.filterFunction = currentFilter;
//      
//      if (currentState == 'singleTarget' || currentState == 'singleAgent')
//        addCustomTypes(currentData);
//
//      currentData.refresh();
//      
//      _item_view = currentData;
      view = CurrentManager.instance.getView(customTypeSort, currentFilter);
      addCustomTypes(view);
    }
    
    private function addCustomTypes(list:ListCollectionView):void
    {
      if (currentState == 'singleTarget' || currentState == 'singleAgent') {
        list.addItemAt({name: R.get('EVIDENCES'),   customType: 'evidences',  order: 0}, 0);
        list.addItemAt({name: R.get('FILE_SYSTEM'), customType: 'filesystem', order: 1}, 0);
      }
      if (currentState == 'singleAgent') {
        list.addItemAt({name: R.get('INFO'),     customType: 'info',     order: 2}, 0);
        list.addItemAt({name: R.get('CONFIG'),   customType: 'config',   order: 3}, 0);
        list.addItemAt({name: R.get('UPLOAD'),   customType: 'upload',   order: 4}, 0);
        list.addItemAt({name: R.get('DOWNLOAD'), customType: 'download', order: 5}, 0);
      }
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
      var aIsFactory:Boolean = a._kind == 'factory';// is Factory;
      var bIsCustom:Boolean  = b.hasOwnProperty('customType');
      var bIsFactory:Boolean = b._kind == 'factory';// is Factory;

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
        return searchFilterFunction(item);
      else return false;
    }
    
  }
  
}