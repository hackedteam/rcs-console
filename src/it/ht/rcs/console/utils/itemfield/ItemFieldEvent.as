package it.ht.rcs.console.utils.itemfield
{
  import flash.events.Event;
  
  import it.ht.rcs.console.search.model.SearchItem;
  
  public class ItemFieldEvent extends Event
  {
    public static const ITEM_SELECTED:String = 'itemSelected';
    
    public var selectedItem:SearchItem;
    
    public function ItemFieldEvent(type:String, item:SearchItem, bubbles:Boolean=true, cancelable:Boolean=false)
    {
      super(type, bubbles, cancelable);
      selectedItem = item;
    }
    
    override public function clone():Event
    {
      return new ItemFieldEvent(type, selectedItem, bubbles, cancelable);
    }
    
  }
  
}