package it.ht.rcs.console.main
{
  import it.ht.rcs.console.accounting.controller.GroupManager;
  import it.ht.rcs.console.accounting.model.User;
  import it.ht.rcs.console.agent.controller.AgentManager;
  import it.ht.rcs.console.operation.controller.OperationManager;
  import it.ht.rcs.console.search.controller.SearchManager;
  import it.ht.rcs.console.target.controller.TargetManager;
  
  import mx.collections.ArrayList;
  
  public class Initialization
  {
    
    public static function initialize(mainSections:ArrayList):void
    {
      var user:User = Console.currentSession.user;
      
      if (user.is_any())                                       mainSections.addItem('Home');
      if (user.is_admin())                                     mainSections.addItem('Accounting');
      if (user.is_admin() || user.is_tech() || user.is_view()) mainSections.addItem('Operations');
      if (user.is_view())                                      mainSections.addItem('Dashboard');
      if (user.is_view())                                      mainSections.addItem('Alerting');
      if (user.is_sys() || user.is_tech())                     mainSections.addItem('System');
      if (user.is_admin())                                     mainSections.addItem('Audit');
      if (user.is_admin() || user.is_sys())                    mainSections.addItem('Monitor');
      if (user.is_any())                                       mainSections.addItem('Playground');
      
      
      // Initialize the managers
      
      if (user.is_any())
      {
        SearchManager.instance.listenRefresh();
        SearchManager.instance.refresh();
        
        //LicenseManager.instance.start();
        
        //DownloadManager.instance.listenRefresh();
        //DownloadManager.instance.refresh();
      }
      
      
      if (user.is_admin() || user.is_tech() || user.is_view())
      {
        GroupManager.instance.refresh();
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