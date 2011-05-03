package it.ht.rcs.console.accounting
{
  import mx.collections.ArrayCollection;
  import mx.resources.ResourceManager;
  
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
    
    public function User(data:Object = null)
    {
      /* default user (when creating new user) */
      if (data == null) {
        username = ResourceManager.getInstance().getString('localized_main', 'NEW_USER');
        contact = '';
        privs = [];
        locale = 'en_US';
        groups = [];
        time_offset = 0;
      } else {
        /* existing user */        
        username = data.username;
        contact = data.contact;
        privs = data.privs;
        locale = data.locale;
        groups = data.groups;
        time_offset = data.time_offset;
      }
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