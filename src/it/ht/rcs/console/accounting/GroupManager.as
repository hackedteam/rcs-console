package it.ht.rcs.console.accounting
{
  import it.ht.rcs.console.accounting.model.Group;
  import it.ht.rcs.console.accounting.model.User;
  import it.ht.rcs.console.events.RefreshEvent;
  import it.ht.rcs.console.model.Manager;
  
  import mx.collections.ArrayCollection;
  import mx.collections.ArrayList;
  import mx.collections.ListCollectionView;
  import mx.collections.Sort;
  import mx.collections.SortField;
  import mx.core.FlexGlobals;
  import mx.events.CollectionEvent;
  import mx.rpc.events.ResultEvent;
  
  public class GroupManager extends Manager
  {                                                     
    /* singleton */
    private static var _instance:GroupManager = new GroupManager();
    public static function get instance():GroupManager { return _instance; } 
    
    public function GroupManager()
    {
      super();
    }

    override protected function onItemRemove(o:*):void
    { 
      console.currentDB.group.destroy(o);
    }
    
    override protected function onItemUpdate(e:*):void
    { 
      var o:Object = new Object;
      if (e.newValue is ArrayCollection)
        o[e.property] = e.newValue.source;
      else
        o[e.property] = e.newValue;
      console.currentDB.group.update(e.source, o);
    }

    override protected function onRefresh(e:RefreshEvent):void
    {
      super.onRefresh(e);
	    console.currentDB.group.all(onGroupIndexResult);
    }
    
    private function onGroupIndexResult(e:ResultEvent):void
    {
      var items:ArrayCollection = e.result as ArrayCollection;
      _items.removeAll();
      items.source.forEach(function toGroupArray(element:*, index:int, arr:Array):void {
        addItem(new Group(element));
      });
    }
    
    public function removeUser(g:Group, u:User):void
    {
      console.currentDB.group.del_user(g, u, function _():void {
        reload(g);
        UserManager.instance.reload(u);
      });
    }
    
    public function addUser(g:Group, u:User):void
    {
      console.currentDB.group.add_user(g, u, function _():void {
        reload(g);
        UserManager.instance.reload(u);
      });
    }
    
    public function reload(g:Group):void
    {
      console.currentDB.group.show(g._id, function (e:ResultEvent):void {
        g.name = e.result.name;
        g.user_ids = e.result.user_ids;
      });
    }
    
    public function newGroup(callback:Function):void
    {
      console.currentDB.group.create(Group.defaultGroup(), function _(e:ResultEvent):void {
        var g:Group = e.result as Group;
        addItem(g);
        callback(g);
      });
    }
    
    public function alertGroup():Group
    {
      var idx:int;
      /* search for the item with alert = true and return it */
      for (idx = 0; idx < _items.length; idx++) {
        var elem:* = _items.getItemAt(idx);
        if (elem.alert == true)
          return elem;
      }
      return null;
    }
    
    public function setalertGroup(g:Group):void
    {
      console.currentDB.group.alert(g);
      if (g != null) 
        g.alert = true;
    }
  }
}