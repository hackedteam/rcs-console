package it.ht.rcs.console.main
{
  import it.ht.rcs.console.agent.controller.AgentManager;
  import it.ht.rcs.console.factory.controller.FactoryManager;
  import it.ht.rcs.console.operation.controller.OperationManager;
  import it.ht.rcs.console.search.controller.SearchManager;
  import it.ht.rcs.console.target.controller.TargetManager;
  import it.ht.rcs.console.task.controller.DownloadManager;
  
  import mx.collections.ArrayList;
  
  public class Initialization
  {
    
    public function Initialization()
    {
    }
    
    public static function initialize(mainSections:ArrayList):void
    {
      
      if (Console.currentSession.user.is_any()) mainSections.addItem('Home');
      if (Console.currentSession.user.is_admin()) mainSections.addItem('Accounting');
      if (Console.currentSession.user.is_admin() || Console.currentSession.user.is_tech() || Console.currentSession.user.is_view()) mainSections.addItem('Operations');
      if (Console.currentSession.user.is_view()) mainSections.addItem('Dashboard');
      if (Console.currentSession.user.is_view()) mainSections.addItem('Alerting');
      //if (console.currentSession.user.is_view()) main_sections.addItem('Correlation');
      if (Console.currentSession.user.is_sys() || Console.currentSession.user.is_tech()) mainSections.addItem('System');
      if (Console.currentSession.user.is_admin()) mainSections.addItem('Audit');
      if (Console.currentSession.user.is_admin() || Console.currentSession.user.is_sys()) mainSections.addItem('Monitor');
      if (Console.currentSession.user.is_any()) mainSections.addItem('Playground');
      
      /* initialize the managers */
      
      if (Console.currentSession.user.is_any()) {
        SearchManager.instance.start();
        //LicenseManager.instance.start();
        DownloadManager.instance.start();
      }
      
      if (Console.currentSession.user.is_admin() || Console.currentSession.user.is_tech() || Console.currentSession.user.is_view()) {
        OperationManager.instance.refresh();
        TargetManager.instance.refresh();
      }
      
      if (Console.currentSession.user.is_tech() || Console.currentSession.user.is_view()) {
        AgentManager.instance.refresh();
        FactoryManager.instance.refresh();
      }
      
//      if (Console.currentSession.user.is_admin() || Console.currentSession.user.is_sys()) {
//        //MonitorManager.instance.start_counters();        
//      }
//      
//      if (Console.currentSession.user.is_view()) {
//        AlertController.instance.start_counters();
//      }
      
    }
    
  }
  
}