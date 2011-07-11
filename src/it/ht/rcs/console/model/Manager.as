package it.ht.rcs.console.model
{
  
  import flash.utils.getQualifiedClassName;
  
  import it.ht.rcs.console.events.SessionEvent;
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
    protected var _classname:String;
    
    public function Manager()
    {
      _classname = flash.utils.getQualifiedClassName(this).split('::')[1];
      trace(_classname + ' (manager) -- Init');
      
      FlexGlobals.topLevelApplication.addEventListener(SessionEvent.LOGGING_IN, onLoggingIn);
      FlexGlobals.topLevelApplication.addEventListener(SessionEvent.LOGGING_OUT, onLoggingOut);
      FlexGlobals.topLevelApplication.addEventListener(SessionEvent.FORCE_LOG_OUT, onForceLogOut);
    }
    
    protected function onLoggingIn(e:SessionEvent):void
    {
      trace(_classname + ' (manager) -- Logging In');
    }
    
    protected function onLoggingOut(e:SessionEvent):void
    {
      trace(_classname + ' (manager) -- Logging Out');
    }
    
    protected function onForceLogOut(e:SessionEvent):void
    {
      trace(_classname + ' (manager) -- Force Log Out');
    }
    
    public function start():void
    {
      trace(_classname + ' (manager) -- Start');
      /* react to the global refresh event */
      FlexGlobals.topLevelApplication.addEventListener(RefreshEvent.REFRESH, onRefresh);
      /* always get new data upon startup */
      onRefresh(null);
    }
    
    public function stop():void
    {
      trace(_classname + ' (manager) -- Stop');
      /* after stop, we don't want to refresh anymore */
      FlexGlobals.topLevelApplication.removeEventListener(RefreshEvent.REFRESH, onRefresh);
    }

    protected function onRefresh(e:RefreshEvent):void
    {
      trace(_classname + ' (manager) -- Refresh');
      /* get the new items from the DB, override this function */
    }
    
  }
  
}