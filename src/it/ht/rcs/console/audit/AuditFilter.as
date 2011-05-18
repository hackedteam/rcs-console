package it.ht.rcs.console.audit {
  import it.ht.rcs.console.utils.DateUtils;
  
  public class AuditFilter extends Object {
    
    public static const RANGE:int = 30; // number of days
    
    public var to:Date = new Date();
    public var from:Date = DateUtils.addDays(to, RANGE);
    
    public var action:String;
    
    public function AuditFilter() {
    }
    
  }
  
}