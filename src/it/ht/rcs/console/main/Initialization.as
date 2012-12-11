package it.ht.rcs.console.main
{
  import flash.events.Event;
  import flash.events.EventDispatcher;
  
  import it.ht.rcs.console.accounting.controller.GroupManager;
  import it.ht.rcs.console.accounting.controller.UserManager;
  import it.ht.rcs.console.accounting.model.User;
  import it.ht.rcs.console.agent.controller.AgentManager;
  import it.ht.rcs.console.alert.controller.AlertManager;
  import it.ht.rcs.console.controller.Manager;
  import it.ht.rcs.console.dashboard.controller.DashboardController;
  import it.ht.rcs.console.events.DataLoadedEvent;
  import it.ht.rcs.console.monitor.controller.LicenseManager;
  import it.ht.rcs.console.monitor.controller.MonitorManager;
  import it.ht.rcs.console.network.controller.CollectorManager;
  import it.ht.rcs.console.network.controller.InjectorManager;
  import it.ht.rcs.console.operation.controller.OperationManager;
  import it.ht.rcs.console.search.controller.SearchManager;
  import it.ht.rcs.console.shard.controller.ShardManager;
  import it.ht.rcs.console.target.controller.TargetManager;
  import it.ht.rcs.console.update.controller.CoreManager;
  import it.ht.rcs.console.utils.UpdateManager;
  
  import mx.collections.ArrayList;
  import mx.controls.ProgressBar;
  
  public class Initialization extends EventDispatcher
  {
    
    private static var _instance:Initialization = new Initialization();
    public static function get instance():Initialization { return _instance; }
    
    private var maxGreenLights:int;
    private var currentGreenLights:int;
    
    private var progress:ProgressBar;
    
    public var mainSections:ArrayList;
    
    public function initialize(loading:ProgressBar):void
    {
      progress = loading;
      
      maxGreenLights = 0;
      currentGreenLights = 0;
      mainSections = new ArrayList();
      
      var user:User = Console.currentSession.user;

      if (user.is_any())                                       mainSections.addItem({label: 'Home',       manager: null});
      if (user.is_admin_users())                               mainSections.addItem({label: 'Accounting', manager: null});
      if (user.is_admin() || user.is_tech() || user.is_view()) mainSections.addItem({label: 'Operations', manager: null});
      if (user.is_view_profiles() || user.is_admin_profiles()) mainSections.addItem({label: 'Intelligence',   manager: null});
      if (user.is_view())                                      mainSections.addItem({label: 'Dashboard',  manager: null});
      if (user.is_view_alerts())                               mainSections.addItem({label: 'Alerting',   manager: AlertManager, property: 'alertCounter'});
      if (user.is_sys_backend() || 
        user.is_sys_backup() || 
        user.is_sys_connectors() || 
        user.is_sys_frontend()  || 
        user.is_sys_injectors() ||
        user.is_tech_ni_rules())                               mainSections.addItem({label: 'System',     manager: null});
      if (user.is_admin_audit())                               mainSections.addItem({label: 'Audit',      manager: null});
      if (user.is_admin() || user.is_tech() || user.is_sys())  mainSections.addItem({label: 'Monitor',    manager: MonitorManager, property: 'monitorCounter'});
      //if (user.is_any())                                       mainSections.addItem({label: 'Playground', manager: null});
      

      /* check for console update */
      UpdateManager.instance.start();
      
      var managers:Array = [];
      
      if (user.is_any())
      {
        SearchManager.instance.listenRefresh();
        managers.push(SearchManager.instance);
       
        
      }
      
      if(user.is_admin() || user.is_tech() || user.is_sys())
      {
        managers.push(MonitorManager.instance);
        managers.push(LicenseManager.instance);
      }
      
      if (user.is_admin_users())
      {
        managers.push(UserManager.instance);
      }
      
      if (user.is_admin_users() || user.is_admin_operations())
      {

        managers.push(GroupManager.instance);
      }
     
      if (user.is_sys_backend())
      {
        managers.push(ShardManager.instance);        
      }

      if (user.is_sys_frontend() || user.is_tech_config())
      {
        managers.push(CollectorManager.instance);
       
      }
      
      if (user.is_sys_injectors() || user.is_tech_ni_rules())
      {
        managers.push(InjectorManager.instance);
      }
      
      if (user.is_admin() || user.is_tech() || user.is_view())
      {
        managers.push(OperationManager.instance);
        managers.push(TargetManager.instance);
      }
      
      if (user.is_tech() || user.is_view())
      {
        managers.push(AgentManager.instance);
      }

      if (user.is_tech())
      {
        CoreManager.instance.listenRefresh();
        managers.push(CoreManager.instance);
      }
      
      if (user.is_view_alerts())
      {

        managers.push(AlertManager.instance);
      }
      
      if(user.is_view())
      {
        DashboardController.instance;
      }
      
      maxGreenLights = managers.length;
      if (maxGreenLights == 0)
        dispatchEvent(new Event("initialized"));
      else
        for each (var manager:Manager in managers) {
          manager.addEventListener(DataLoadedEvent.DATA_LOADED, onDataLoaded);
          manager.refresh();
        }
    }
    
    private function onDataLoaded(event:DataLoadedEvent):void
    {
      event.manager.removeEventListener(DataLoadedEvent.DATA_LOADED, onDataLoaded);
      currentGreenLights++;
      progress.setProgress(currentGreenLights, maxGreenLights);
      if (currentGreenLights == maxGreenLights)
        dispatchEvent(new Event("initialized"));
    }
    
  }
  
}