package it.ht.rcs.console.main
{
  import it.ht.rcs.console.accounting.controller.GroupManager;
  import it.ht.rcs.console.accounting.model.User;
  import it.ht.rcs.console.agent.controller.AgentManager;
  import it.ht.rcs.console.alert.controller.AlertManager;
  import it.ht.rcs.console.network.controller.CollectorManager;
  import it.ht.rcs.console.operation.controller.OperationManager;
  import it.ht.rcs.console.search.controller.SearchManager;
  import it.ht.rcs.console.target.controller.TargetManager;
  
  import mx.collections.ArrayList;
  
  public class Initialization
  {
    [Bindable]
    private static var asd:Object;
    
    public static function initialize(mainSections:ArrayList):void
    {
      var user:User = Console.currentSession.user;

      if (user.is_any())                                       mainSections.addItem({label: 'Home',       manager: null});
      if (user.is_admin())                                     mainSections.addItem({label: 'Accounting', manager: null});
      if (user.is_admin() || user.is_tech() || user.is_view()) mainSections.addItem({label: 'Operations', manager: null});
      if (user.is_view())                                      mainSections.addItem({label: 'Dashboard',  manager: null});
      if (user.is_view())                                      mainSections.addItem({label: 'Alerting',   manager: AlertManager, property: 'alertCount'});
      if (user.is_sys() || user.is_tech())                     mainSections.addItem({label: 'System',     manager: null});
      if (user.is_admin())                                     mainSections.addItem({label: 'Audit',      manager: null});
      if (user.is_admin() || user.is_sys())                    mainSections.addItem({label: 'Monitor',    manager: null});
    //if (user.is_any())                                       mainSections.addItem({label: 'Playground', manager: null});
      
      
      // Initialize the managers
      
      if (user.is_any())
      {
        SearchManager.instance.listenRefresh();
        SearchManager.instance.refresh();
        
        CollectorManager.instance.refresh();
        
        //LicenseManager.instance.start();
        
        //DownloadManager.instance.listenRefresh();
        //DownloadManager.instance.refresh();
      }
      
      
      if (user.is_admin())
      {
        GroupManager.instance.refresh();
      }
      
      if (user.is_admin() || user.is_tech() || user.is_view())
      {
        OperationManager.instance.refresh();
        TargetManager.instance.refresh();
      }
      
      if (user.is_tech() || user.is_view())
      {
        AgentManager.instance.refresh();
      }
      
//      if (user.is_admin() || user.is_sys()) {
//        MonitorManager.instance.start_counters();        
//      }
      
//      if (user.is_view()) {
//        AlertController.instance.start_counters();
//      }
      
    }
    
  }
  
}