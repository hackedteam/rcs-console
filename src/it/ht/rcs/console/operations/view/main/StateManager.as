package it.ht.rcs.console.operations.view.main
{
  import it.ht.rcs.console.agent.controller.AgentController;
  import it.ht.rcs.console.agent.controller.AgentManager;
  import it.ht.rcs.console.agent.model.Agent;
  import it.ht.rcs.console.controller.ItemManager;
  import it.ht.rcs.console.events.DataLoadedEvent;
  import it.ht.rcs.console.factory.model.Config;
  import it.ht.rcs.console.factory.model.Factory;
  import it.ht.rcs.console.operation.controller.OperationManager;
  import it.ht.rcs.console.operation.model.Operation;
  import it.ht.rcs.console.operations.view.OperationsSection;
  import it.ht.rcs.console.target.controller.TargetManager;
  import it.ht.rcs.console.target.model.Target;
  
  import locale.R;
  
  import mx.collections.ArrayList;
  import mx.collections.IList;
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
    
    public function manageItemSelection(item:*):void
    {
      if (item is Operation)
      {
        selectedOperation = item;
        setState('singleOperation');
      }
      
      else if (item is Target)
      {
        if (Console.currentSession.user.is_tech()) {
          selectedTarget = item;
          setState('singleTarget');
        }
      }
      
      else if (item is Agent)
      {
        if (Console.currentSession.user.is_view()) {
          selectedAgent = item;
          setState('singleAgent');
        }
      }
      
      else if (item is Factory)
      {
        if (Console.currentSession.user.is_tech()) {
          // launch configuration
        }
      }
      
      else if (item is Config)
      {
        if (Console.currentSession.user.is_tech()) {
          selectedTarget = item;
          setState('singleTarget');
        }
      }
      
      else if (item is Object && item.customType == 'evidences')
      {
        Alert.show('Show Evidence Component');
      }
      
      else if (item is Object && item.customType == 'filesystem')
      {
        Alert.show('Show Filesystem Component');
      }
      
      else if (item is Object && item.customType == 'info')
      {
        Alert.show('Show Info Component');
      }
        
      else if (item is Object && item.customType == 'config')
      {
        section.body.currentState = 'configList';
      }
    }
    
    public function setState(state:String):void
    {
      
      stopManagers();
      
      switch (state) {
        case 'allOperations':
          selectedOperation = null; selectedTarget = null; selectedAgent = null;
          section.currentState = 'allOperations';
          section.body.currentState = 'listgrid';
          CurrentManager = OperationManager;
          currentFilter = searchFilterFunction;
          OperationManager.instance.addEventListener(DataLoadedEvent.DATA_LOADED, onDataLoaded);
          OperationManager.instance.start();
          break;
        case 'singleOperation':
          selectedTarget = null; selectedAgent = null;
          section.currentState = 'singleOperation';
          section.body.currentState = 'listgrid';
          CurrentManager = TargetManager;
          currentFilter = targetFilterFunction;
          TargetManager.instance.addEventListener(DataLoadedEvent.DATA_LOADED, onDataLoaded);
          TargetManager.instance.start();
          break;
        case 'allTargets':
          if (Console.currentSession.user.is_tech()) {
            selectedOperation = null; selectedTarget = null; selectedAgent = null;
            section.currentState = 'allTargets';
            section.body.currentState = 'listgrid';
            CurrentManager = TargetManager;
            currentFilter = searchFilterFunction;
            TargetManager.instance.addEventListener(DataLoadedEvent.DATA_LOADED, onDataLoaded);
            TargetManager.instance.start();
          }
          break;
        case 'singleTarget':
          if (Console.currentSession.user.is_tech()) {
            selectedOperation = OperationManager.instance.getItem(selectedTarget.path[0]); selectedAgent = null;
            section.currentState = 'singleTarget';
            section.body.currentState = 'listgrid';
            CurrentManager = AgentController;
            currentFilter = agentFactoryFilterFunction;
            AgentController.instance.addEventListener(DataLoadedEvent.DATA_LOADED, onDataLoaded);
            AgentController.instance.start();
//            _item_view = new ListCollectionView(new ArrayList());
//            addCustomTypes();
//            _item_view.sort = customTypeSort;
//            _item_view.filterFunction = agentFactoryFilterFunction;
//            AgentManager.instance.addEventListener(DataLoadedEvent.DATA_LOADED, onDataLoadedMerge);
//            AgentManager.instance.start();
//            FactoryManager.instance.addEventListener(DataLoadedEvent.DATA_LOADED, onDataLoadedMerge);
//            FactoryManager.instance.start();
          }
          break;
        case 'allAgents':
          if (Console.currentSession.user.is_view()) {
            selectedOperation = null; selectedTarget = null; selectedAgent = null;
            section.currentState = 'allAgents';
            section.body.currentState = 'listgrid';
            CurrentManager = AgentManager;
            currentFilter = searchFilterFunction;
            AgentManager.instance.addEventListener(DataLoadedEvent.DATA_LOADED, onDataLoaded);
            AgentManager.instance.start();
          }
          break;
        case 'singleAgent':
          if (Console.currentSession.user.is_view()) {
            selectedOperation = OperationManager.instance.getItem(selectedAgent.path[0]);
            selectedTarget = TargetManager.instance.getItem(selectedAgent.path[1]);
            section.currentState = 'singleAgent';
            section.body.currentState = 'listgrid';
            CurrentManager = null;
            currentFilter = null;
            _item_view = new ListCollectionView(new ArrayList());
            addCustomTypes();
            _item_view.sort = customTypeSort;
            _item_view.filterFunction = searchFilterFunction;
            _item_view.refresh();
          }
          break;
        default:
          break;
      }
    }
    
    public function resetState():void
    {
      stopManagers();
      selectedOperation = null; selectedTarget = null; selectedAgent = null;
      section.currentState = 'allOperations';
    }
    
    private function addCustomTypes():void
    {
      if (section.currentState == 'singleTarget' || section.currentState == 'singleAgent') {
        _item_view.addItemAt({name: R.get('EVIDENCES'),   customType: 'evidences',  order: 0}, 0);
        _item_view.addItemAt({name: R.get('FILE_SYSTEM'), customType: 'filesystem', order: 1}, 0);
      }
      if (section.currentState == 'singleAgent') {
        _item_view.addItemAt({name: R.get('INFO'),     customType: 'info',     order: 2}, 0);
        _item_view.addItemAt({name: R.get('CONFIG'),   customType: 'config',   order: 3}, 0);
        _item_view.addItemAt({name: R.get('UPLOAD'),   customType: 'upload',   order: 4}, 0);
        _item_view.addItemAt({name: R.get('DOWNLOAD'), customType: 'download', order: 5}, 0);
      }
    }
    
    private function onDataLoaded(event:DataLoadedEvent = null):void
    {
      _item_view = CurrentManager.instance.getView(null, currentFilter);
    }
    
    private function onDataLoadedMerge(event:DataLoadedEvent = null):void
    {
      var list:IList = (event.manager as ItemManager).getView().list;
      list.toArray().forEach(function(element:*, index:int, arr:Array):void {
        _item_view.addItem(element);
      });
      _item_view.refresh();
    }
    
    public function stopManagers():void
    {
      OperationManager.instance.removeEventListener(DataLoadedEvent.DATA_LOADED, onDataLoaded);
      OperationManager.instance.stop();
      
      TargetManager.instance.removeEventListener(DataLoadedEvent.DATA_LOADED, onDataLoaded);
      TargetManager.instance.stop();
      
      AgentController.instance.removeEventListener(DataLoadedEvent.DATA_LOADED, onDataLoaded);
      AgentController.instance.stop();
    }
    
    private var CurrentManager:Class;
    private var currentFilter:Function;
    private var customTypeSort:Sort;
    
    private function customTypeCompareFunction(a:Object, b:Object):int
    {
      if (!a && b) return  0;
      if (!a && b) return  1;
      if (!b && a) return -1;
      var aHas:Boolean = a.hasOwnProperty('customType');
      var bHas:Boolean = b.hasOwnProperty('customType');
      if (!aHas && !bHas) return 0;
      if (aHas && bHas) {
        var distance:int = a.order - b.order;
        return distance / Math.abs(distance);
      }
      if (aHas) return -1 else return 1;
    }
    
    private function searchFilterFunction(item:Object):Boolean
    {
      if (!section.buttonBar || !section.buttonBar.searchField || section.buttonBar.searchField.text == '')
        return true;
      var result:Boolean = String(item.name.toLowerCase()).indexOf(section.buttonBar.searchField.text.toLowerCase()) >= 0;
      if (!result && item.instance)
        result = String(item.instance.toLowerCase()).indexOf(section.buttonBar.searchField.text.toLowerCase()) >= 0;
      return result;
    }
    
    private function targetFilterFunction(item:Object):Boolean
    {
      if (!(item is Target) || !(selectedOperation)) return true;
      if (item.path[0] == selectedOperation._id)
        return searchFilterFunction(item);
      else return false;
    }
    
    private function agentFactoryFilterFunction(item:Object):Boolean
    {
      if (!(item is Agent || item is Factory) || !(selectedTarget)) return true;
      if (item.path[1] == selectedTarget._id)
        return searchFilterFunction(item);
      else return false;
    }
    
  }
  
}