package it.ht.rcs.console.model
{
  import it.ht.rcs.console.events.RefreshEvent;
  
  import mx.collections.ArrayList;
  import mx.collections.ListCollectionView;
  import mx.collections.Sort;
  import mx.collections.SortField;
  import mx.core.FlexGlobals;
  import mx.events.CollectionEvent;
  
  public class Manager
  {
    [Bindable]
    protected var _items:ArrayList = new ArrayList();
    
    /* singleton */
    private static var _instance:Manager = new Manager();
    public static function get instance():Manager { return _instance; } 
    
    public function Manager()
    {
      /* detect changes on the list */
      _items.addEventListener(CollectionEvent.COLLECTION_CHANGE, onItemsChange);
    }
    
    protected function onItemsChange(event:CollectionEvent):void 
    { 
      /* all the logic to the db is here, override this method */
    }
    
    public function start():void
    {
      /* react to the global refresh event */
      FlexGlobals.topLevelApplication.addEventListener(RefreshEvent.REFRESH, onRefresh);
    }
    
 
    public function stop():void
    {
      /* after stop, we don't want to refresh anymore */
      FlexGlobals.topLevelApplication.removeEventListener(RefreshEvent.REFRESH, onRefresh);
    }
    
    protected function onRefresh(e:RefreshEvent):void
    {
      /* get the new items from the DB, override this function */
    }
    
    /* SPECIALIZE THIS: to specialize the type of object returned  */
    public function newItem():Object
    {
      var obj:Object = new Object();
      _items.addItem(obj);
      return obj;
    }
    
    public function addItem(o:Object):void
    {
      _items.addItem(o);
    }
    
    public function removeItem(o:Object):void
    {
      /* remove an item from the list */
      if (o == null)
        return;
      
      var idx : int = _items.getItemIndex(o);
      if (idx >= 0) 
        _items.removeItemAt(idx);
    }

    
    public function getView(filterFunction:Function=null):ListCollectionView
    {
      /* always return updated content when something requests a view */
      onRefresh(null);
      
      /* create the view for the caller */
      var lcv:ListCollectionView = new ListCollectionView();
      lcv.list = _items;
      
      /* default sorting is alphabetical */
      var sort:Sort = new Sort();
      sort.fields = [new SortField('name', true, false, false)];
      lcv.sort = sort;
      lcv.filterFunction = filterFunction;
      lcv.refresh();
      
      return lcv;
    }
    
    public function getViewIds(ids:Array):ListCollectionView
    {
      /* set the filter on the ids */
      var ff:Function = function filter(o:Object):Boolean {
        if (ids.indexOf(o.id) != -1)
          return true;
        
        return false;
      };
      
      /* create the view for the caller */
      return getView(ff);
    }
  }
}