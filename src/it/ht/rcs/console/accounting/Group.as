package it.ht.rcs.console.accounting
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
    
    public function save():void
    {
      // TODO: save to the db
      // TODO: updated the local id from the db
    }
  }
}