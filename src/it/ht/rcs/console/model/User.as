package it.ht.rcs.console.model
{
  import mx.collections.ArrayCollection;
  import mx.resources.ResourceManager;
  
  public class User
  {
    [Bindable]
    public var _id:String;
    [Bindable]
    public var enabled:Boolean;
    [Bindable]
    public var name:String;
    [Bindable]
    public var pass:String;
    [Bindable]
    public var description:String;
    [Bindable]
    public var contact:String;
    [Bindable]
    public var privs:ArrayCollection;
    [Bindable]
    public var locale:String;
    [Bindable]
    public var timezone:int;
    [Bindable]
    public var group_ids:ArrayCollection;
    
    public function User(data:Object = null)
    {
      /* default user (when creating new user) */
      if (data == null) {
        _id = "";
        enabled = false;
        name = ResourceManager.getInstance().getString('localized_main', 'NEW_USER');
        contact = '';
        pass = 'rcs';
        privs = new ArrayCollection();
        locale = 'en_US';
        group_ids = new ArrayCollection();
        timezone = 0;
      } else {
        /* existing user */
        _id = data._id;
        enabled = data.enabled;
        name = data.name;
        contact = data.contact;
        privs = data.privs;
        pass = '';
        locale = data.locale;
        group_ids = data.group_ids;
        timezone = data.timezone;
      }
    }
    
    public function toHash():Object
    {
      return {_id: _id, enabled: enabled, name: name, contact: contact, privs: privs.source, pass: pass, locale: locale, group_ids: group_ids.source, timezone: timezone}
    }
    
    public function is_admin():Boolean
    {
      return privs.getItemIndex('ADMIN') != -1
    }
    public function is_tech():Boolean
    {
      return privs.getItemIndex('TECH') != -1
    }
    public function is_viewer():Boolean
    {
      return privs.getItemIndex('VIEW') != -1
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
      group_ids.addItem(g._id);
    }
    
    public function removeGroup(g:Group):void
    {
      var idx:int = group_ids.getItemIndex(g._id);
      if (idx >= 0)
        group_ids.source.splice(idx, 1);
    }
    
    public function save():void
    {
      // TODO: save to the db
      // TODO: updated the local id from the db
    }
  }
}