package it.ht.rcs.console.model
{
  import mx.collections.ArrayCollection;
  import mx.resources.ResourceManager;
  
  public class User
  {
    [Bindable]
    public var id:Number;
    [Bindable]
    public var enabled:Boolean;
    [Bindable]
    public var name:String;
    [Bindable]
    public var description:String;
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
        id = 0;
        enabled = false;
        name = ResourceManager.getInstance().getString('localized_main', 'NEW_USER');
        contact = '';
        privs = [];
        locale = 'en_US';
        groups = [];
        time_offset = 0;
      } else {
        /* existing user */
        id = data.id;
        enabled = data.enabled;
        name = data.name;
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
    
    public function addGroup(g:Group):void
    {
      groups.push(g.id);
    }
    
    public function removeGroup(g:Group):void
    {
      var idx:int = groups.indexOf(g.id);
      if (idx >= 0)
        groups.splice(idx, 1);
    }
    
    public function save():void
    {
      // TODO: save to the db
      // TODO: updated the local id from the db
    }
  }
}