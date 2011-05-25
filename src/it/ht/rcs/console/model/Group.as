package it.ht.rcs.console.model
{
  import mx.collections.ArrayCollection;
  import mx.resources.ResourceManager;
  import mx.rpc.events.ResultEvent;
  
  import it.ht.rcs.console.accounting.UserManager;
  
  public class Group
  {
    [Bindable]
    public var _id:String;
    [Bindable]
    public var name:String;
    [Bindable]
    public var alert:Boolean;
    [Bindable]
    public var user_ids:ArrayCollection;
  
    
    public function Group(data:Object = null)
    {
      /* default group (when creating new group) */
      if (data == null) {
        _id = "";
        name = ResourceManager.getInstance().getString('localized_main', 'NEW_GROUP');
        alert = false;
        user_ids = new ArrayCollection();
      } else {
        /* existing group */
        _id = data._id;
        name = data.name;
        alert = data.alert;
        user_ids = data.user_ids;
      }
    }
    
    public function toHash():Object
    {
      return {name: name, user_ids: user_ids.source}
    }
    
    public function addUser(u:User):void
    {
      var g:Group = this;
      console.currentDB.group_add_user(g, u, function _():void {
        g.reload();
        u.reload();
      });
    }
    
    public function removeUser(u:User):void
    {
      var g:Group = this;
      console.currentDB.group_del_user(g, u, function _():void {
        g.reload();
        u.reload();
      });
    }
    
    public function reload():void
    {
      /* reload data from db */      
      console.currentDB.group_show(_id, onReload);
    }
    
    private function onReload(e:ResultEvent):void
    {
      var g:Object = e.result;
      
      name = g.name;
      user_ids = g.user_ids;
    }
    
    public function save():void
    {
      // TODO: save to the db
    }
  }
}