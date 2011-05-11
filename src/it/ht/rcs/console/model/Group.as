package it.ht.rcs.console.model
{
  import mx.collections.ArrayCollection;
  import mx.resources.ResourceManager;
  
  public class Group
  {
    [Bindable]
    public var _id:String;
    [Bindable]
    public var name:String;
    [Bindable]
    public var user_ids:ArrayCollection;
  
    
    public function Group(data:Object = null)
    {
      /* default group (when creating new group) */
      if (data == null) {
        _id = "";
        name = ResourceManager.getInstance().getString('localized_main', 'NEW_GROUP');
        user_ids = new ArrayCollection();
      } else {
        /* existing group */
        _id = data._id;
        name = data.name;
        user_ids = data.user_ids;
      }
    }
    
    public function toHash():Object
    {
      return {name: name, user_ids: user_ids.source}
    }
    
    public function addUser(u:User):void
    {
      user_ids.addItem(u._id);
    }
    
    public function removeUser(u:User):void
    {
      var idx:int = user_ids.getItemIndex(u._id);
      if (idx >= 0)
        user_ids.source.splice(idx, 1);
    }
    
    public function save():void
    {
      trace('save group');
      // TODO: save to the db
      // TODO: updated the local id from the db
    }
  }
}