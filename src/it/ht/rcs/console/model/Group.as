package it.ht.rcs.console.model
{
  import mx.collections.ArrayCollection;
  import mx.resources.ResourceManager;
  
  public class Group
  {
    [Bindable]
    public var id:Number;
    [Bindable]
    public var name:String;
    [Bindable]
    public var users:Array;
  
    
    public function Group(data:Object = null)
    {
      /* default group (when creating new group) */
      if (data == null) {
        id = 0;
        name = ResourceManager.getInstance().getString('localized_main', 'NEW_GROUP');
        users = [];
      } else {
        /* existing group */
        id = data.id;
        name = data.name;
        users = data.users;
      }
    }
    
    public function addUser(u:User):void
    {
      users.push(u.id);
    }
    
    public function removeUser(u:User):void
    {
      var idx:int = users.indexOf(u.id);
      if (idx >= 0)
        users.splice(idx, 1);
    }
    
    public function save():void
    {
      trace('save group');
      // TODO: save to the db
      // TODO: updated the local id from the db
    }
  }
}