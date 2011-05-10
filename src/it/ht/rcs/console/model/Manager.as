package it.ht.rcs.console.model
{
  import flash.utils.getQualifiedClassName;
  
  import it.ht.rcs.console.events.RefreshEvent;
  
  import mx.collections.ArrayList;
  import mx.collections.ISort;
  import mx.collections.ListCollectionView;
  import mx.collections.Sort;
  import mx.collections.SortField;
  import mx.core.FlexGlobals;
  import mx.events.CollectionEvent;
  import mx.events.CollectionEventKind;
  
  public class Manager
  {
    [Bindable]
    protected var _items:ArrayList = new ArrayList();
    
    private var _classname:String;
    
    /* singleton */
    private static var _instance:Manager = new Manager();
    public static function get instance():Manager { return _instance; } 
    
    public function Manager()
    {
      _classname = flash.utils.getQualifiedClassName(this).split('::')[1];
      trace(_classname + ' -- Init');
      /* detect changes on the list */
      _items.addEventListener(CollectionEvent.COLLECTION_CHANGE, onItemsChange);
    }
    
    public function start():void
    {
      trace(_classname + ' -- Start');
      /* react to the global refresh event */
      FlexGlobals.topLevelApplication.addEventListener(RefreshEvent.REFRESH, onRefresh);
    }
    
 
    public function stop():void
    {
      trace(_classname + ' -- Start');
      /* after stop, we don't want to refresh anymore */
      FlexGlobals.topLevelApplication.removeEventListener(RefreshEvent.REFRESH, onRefresh);
    }

    protected function onItemsChange(event:CollectionEvent):void 
    { 
      //trace(_classname + ' -- ' + event.toString());
      
      /* all the logic to the db is here, override this method */
      switch (event.kind) { 
        case CollectionEventKind.ADD: 
          onItemAdd();
          break; 
        
        case CollectionEventKind.REMOVE: 
          onItemRemove();
          break; 
        
        case CollectionEventKind.UPDATE: 
          onItemUpdate();
          break; 
        
        case CollectionEventKind.RESET: 
          onReset();
          break; 
      } 
    }
    
    protected function onRefresh(e:RefreshEvent):void
    {
      var classname:String = flash.utils.getQualifiedClassName(this).split('::')[1];
      trace(classname + ' -- Refresh');
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
    
    protected function onItemAdd():void
    {
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

    protected function onItemRemove():void
    { 
    }

    protected function onItemUpdate():void
    { 
    }
    
    protected function onReset():void
    {
    }
    
    public function getView(filterFunction:Function=null, sortCriteria:ISort=null):ListCollectionView
    {
      /* always return updated content when something requests a view */
      onRefresh(null);
      
      /* create the view for the caller */
      var lcv:ListCollectionView = new ListCollectionView();
      lcv.list = _items;
      
      if (sortCriteria == null) {
        /* default sorting is alphabetical */
        var sort:Sort = new Sort();
        sort.fields = [new SortField('name', true, false, false)];
        lcv.sort = sort;
      } else {
        lcv.sort = sortCriteria;
      }
      
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