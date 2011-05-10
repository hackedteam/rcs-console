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
    public var user_ids:ArrayCollection;
  
    
    public function Group(data:Object = null)
    {
      /* default group (when creating new group) */
      if (data == null) {
        id = 0;
        name = ResourceManager.getInstance().getString('localized_main', 'NEW_GROUP');
        user_ids = new ArrayCollection();
      } else {
        /* existing group */
        id = data._id;
        name = data.name;
        user_ids = data.user_ids;
      }
    }
    
    public function addUser(u:User):void
    {
      user_ids.addItem(u.id);
    }
    
    public function removeUser(u:User):void
    {
      var idx:int = user_ids.getItemIndex(u.id);
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