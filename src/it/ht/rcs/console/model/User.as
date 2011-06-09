package it.ht.rcs.console.model
{
  import mx.controls.Alert;
  import mx.collections.ArrayCollection;
  import mx.resources.ResourceManager;
  import mx.rpc.events.ResultEvent;
  
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
    public var desc:String;
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
        pass = '';
        desc = '';
        contact = '';
        privs = new ArrayCollection();
        locale = 'en_US';
        timezone = 0;
        group_ids = new ArrayCollection();
      } else {
        /* existing user */
        _id = data._id;
        enabled = data.enabled;
        name = data.name;
        pass = data.pass;
        desc = data.desc;
        contact = data.contact;
        privs = data.privs;
        locale = data.locale;
        timezone = data.timezone;
        group_ids = data.group_ids;
      }
    }
    
    public function toHash():Object
    {
      return {enabled: enabled, name: name, contact: contact, desc: desc, privs: privs.source, locale: locale, group_ids: group_ids.source, timezone: timezone};
    }
    
    public function is_admin():Boolean
    {
      return privs.getItemIndex('ADMIN') != -1;
    }
    public function is_tech():Boolean
    {
      return privs.getItemIndex('TECH') != -1;
    }
    public function is_viewer():Boolean
    {
      return privs.getItemIndex('VIEW') != -1;
    }
    public function is_any():Boolean
    {
      return privs.length != 0;
    }
    
    public function change_password(new_pass:String):void
    {
      console.currentDB.user_update(this, {pass: new_pass}, onPasswordChanged);
    }
    
    public function onPasswordChanged(e: ResultEvent):void
    {
      Alert.show(ResourceManager.getInstance().getString('localized_main', 'PASSWORD_CHANGED'));
    }
    
    public function reload():void
    {
      /* reload data from db */      
      console.currentDB.user_show(_id, onReload);
    }
    
    private function onReload(e:ResultEvent):void
    {
      var u:Object = e.result;
      
      enabled = u.enabled;
      name = u.name;
      pass = u.pass;
      desc = u.desc;
      contact = u.contact;
      privs = u.privs;
      locale = u.locale;
      timezone = u.timezone;
      group_ids = u.group_ids;
    }
    
    public function save():void
    {
      console.currentDB.user_update(this, this.toHash());
    }
  }
}