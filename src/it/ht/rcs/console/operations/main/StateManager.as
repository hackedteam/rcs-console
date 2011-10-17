package it.ht.rcs.console.operations.main
{
  import it.ht.rcs.console.agent.controller.AgentManager;
  import it.ht.rcs.console.agent.model.Agent;
  import it.ht.rcs.console.events.DataLoadedEvent;
  import it.ht.rcs.console.operation.controller.OperationManager;
  import it.ht.rcs.console.operation.model.Operation;
  import it.ht.rcs.console.operations.OperationsSection;
  import it.ht.rcs.console.target.controller.TargetManager;
  import it.ht.rcs.console.target.model.Target;
  
  import mx.collections.ListCollectionView;
  import mx.controls.Alert;
  
  import spark.collections.Sort;
  import spark.collections.SortField;

  public class StateManager
  {
    
    [Bindable]
    public var _item_view:ListCollectionView;
    
    [Bindable]
    public var selectedOperation:Operation;
    
    [Bindable]
    public var selectedTarget:Target;
    
    [Bindable]
    public var selectedAgent:Agent;
    
    private var section:OperationsSection;
    
    public function StateManager(section:OperationsSection)
    {
      this.section = section;
      
      customTypeSort = new Sort();
      var customTypeSortField:SortField = new SortField('customType', false, false);
      customTypeSortField.compareFunction = customTypeCompareFunction;
      customTypeSort.fields = [customTypeSortField, new SortField('name', false, false)];
    }
    
    private function manageItemSelection(item:*):void
    {
      if (item is Operation)
      {
        selectedOperation = item;
        setState('singleOperation');
      }
      
      else if (item is Target)
      {
        if (console.currentSession.user.is_tech()) {
          selectedTarget = item;
          setState('singleTarget');
        }
      }
      
      else if (item is Agent)
      {
        selectedAgent = item;
        setState('singleAgent');
      }
      
      else if (item is Object && item.customType == 'evidences')
      {
        Alert.show('Show Evidence Component');
      }
      
      else if (item is Object && item.customType == 'filesystem')
      {
        Alert.show('Show Filesystem Component');
      }
    }
    
    public function setState(state:String):void
    {
      
      stopManagers();
      
      switch (state) {
        case 'allOperations':
          selectedOperation = null; selectedTarget = null; selectedAgent = null;
          CurrentManager = OperationManager;
          currentFilter = searchFilterFunction;
          OperationManager.instance.addEventListener(DataLoadedEvent.DATA_LOADED, onDataLoaded);
          OperationManager.instance.start();
          section.currentState = 'allOperations';
          break;
        case 'singleOperation':
          selectedTarget = null; selectedAgent = null;
          CurrentManager = TargetManager;
          currentFilter = targetFilterFunction;
          TargetManager.instance.addEventListener(DataLoadedEvent.DATA_LOADED, onDataLoaded);
          TargetManager.instance.start();
          section.currentState = 'singleOperation';
          break;
        case 'allTargets':
          if (console.currentSession.user.is_tech()) {
            selectedOperation = null; selectedTarget = null; selectedAgent = null;
            section.currentState = 'allTargets';
            CurrentManager = TargetManager;
            currentFilter = searchFilterFunction;
            TargetManager.instance.addEventListener(DataLoadedEvent.DATA_LOADED, onDataLoaded);
            TargetManager.instance.start();
          }
          break;
        case 'singleTarget':
          if (console.currentSession.user.is_tech()) {
            selectedAgent = null;
            section.currentState = 'singleTarget';
            CurrentManager = AgentManager;
            currentFilter = agentFilterFunction;
            AgentManager.instance.addEventListener(DataLoadedEvent.DATA_LOADED, onDataLoaded);
            AgentManager.instance.start();
          }
          break;
        case 'allAgents':
          if (console.currentSession.user.is_view()) {
            selectedOperation = null; selectedTarget = null; selectedAgent = null;
            section.currentState = 'allAgents';
            CurrentManager = AgentManager;
            currentFilter = searchFilterFunction;
            AgentManager.instance.addEventListener(DataLoadedEvent.DATA_LOADED, onDataLoaded);
            AgentManager.instance.start();
          }
          break;
        case 'singleAgent':
          if (console.currentSession.user.is_view()) {
            section.currentState = 'singleAgent';
            CurrentManager = AgentManager;
            currentFilter = searchFilterFunction;
            AgentManager.instance.addEventListener(DataLoadedEvent.DATA_LOADED, onDataLoaded);
            AgentManager.instance.start();
          }
          break;
        default:
          break;
      }
    }
    
    public function stopManagers():void
    {
      OperationManager.instance.removeEventListener(DataLoadedEvent.DATA_LOADED, onDataLoaded);
      OperationManager.instance.stop();
      
      TargetManager.instance.removeEventListener(DataLoadedEvent.DATA_LOADED, onDataLoaded);
      TargetManager.instance.stop();
      
      AgentManager.instance.removeEventListener(DataLoadedEvent.DATA_LOADED, onDataLoaded);
      AgentManager.instance.stop();
    }
    
    public function resetState():void
    {
      stopManagers();
      selectedOperation = null; selectedTarget = null; selectedAgent = null;
      section.currentState = 'allOperations';
    }
    
    private function onDataLoaded(event:DataLoadedEvent):void
    {
      if (section.currentState == 'singleTarget' || section.currentState == 'singleAgent') {
        _item_view = CurrentManager.instance.getView(customTypeSort, currentFilter);
        _item_view.addItemAt({name: 'File System', customType: 'filesystem'}, 0);
        _item_view.addItemAt({name: 'Evidences',   customType: 'evidences'}, 0);
      } else {
        _item_view = CurrentManager.instance.getView(null, currentFilter);
      }
    }
    
    private var CurrentManager:Class;
    private var currentFilter:Function;
    private var customTypeSort:Sort;
    
    private function customTypeCompareFunction(a:Object, b:Object):int
    {
      var aHas:Boolean = a.hasOwnProperty('customType');
      var bHas:Boolean = b.hasOwnProperty('customType');
      if ((aHas &&  bHas) || (!aHas && !bHas)) return 0;
      if (aHas) return -1 else return 1;
    }
    
    private function searchFilterFunction(item:Object):Boolean
    {
      if (!section.buttonBar || !section.buttonBar.searchField || section.buttonBar.searchField.text == '')
        return true;
      var result:Boolean = String(item.name.toLowerCase()).indexOf(section.buttonBar.searchField.text.toLowerCase()) >= 0;
      return result;
    }
    
    private function targetFilterFunction(item:Object):Boolean
    {
      if (!(item is Target)) return true;
      if (item.path[0] == selectedOperation._id)
        return searchFilterFunction(item);
      else return false;
    }
    
    private function agentFilterFunction(item:Object):Boolean
    {
      if (!(item is Agent)) return true;
      if (item.path[1] == selectedTarget._id)
        return searchFilterFunction(item);
      else return false;
    }
    
  }
  
}