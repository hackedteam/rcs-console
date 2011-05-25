package it.ht.rcs.console.audit {
  import it.ht.rcs.console.utils.DateUtils;
  
  public dynamic class AuditFilter {
    
    public static const RANGE:int = 30; // number of days
    
    public var to:Date = new Date();
    public var from:Date = DateUtils.addDays(to, -AuditFilter.RANGE);
    
    public var actor:String;
    public var action:String;
    public var user:String;
    public var group:String;
    public var activity:String;
    public var target:String;
    public var backdoor:String;
    public var desc:String;
    
    public function AuditFilter() {
    }
    
  }
  
}