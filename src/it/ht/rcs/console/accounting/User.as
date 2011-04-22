package it.ht.rcs.console.accounting
{
  import mx.collections.ArrayCollection;

  public class User
  {
    [Bindable]
    public var username:String;
    [Bindable]
    public var contact:String;
    [Bindable]
    public var privs:Array;
    [Bindable]
    public var locale:String;
    [Bindable]
    public var time_offset:int;
    [Bindable]
    public var groups:Array;
    
    public function User()
    {
      username = 'alor';
      contact = "alor@hackingteam.it";
      privs = ['ADMIN', 'TECH', 'VIEW'];
      locale = 'en_US';
      groups = ['developers', 'investigators', 'lamers', 'a', 'b', 'c', 'd'];
      time_offset = 0;
    }
    
    public function is_admin():Boolean
    {
      return privs.indexOf('ADMIN') != -1
    }
    public function is_tech():Boolean
    {
      return privs.indexOf('TECH') != -1
    }
    public function is_viewer():Boolean
    {
      return privs.indexOf('VIEW') != -1
    }
    public function is_any():Boolean
    {
      return privs.length != 0
    }
    
    public function change_password(new_pass:String):void
    {
      // TODO: save to the db      
    }
    
    public function save():void
    {
      // TODO: save to the db
    }
  }
}