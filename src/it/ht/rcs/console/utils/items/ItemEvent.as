package it.ht.rcs.console.utils.items
{
  import flash.events.Event;
  
  public class ItemEvent extends Event
  {
    
    public static const ITEM_SELECTED:String = "itemSelected";
    
    public var selectedItem:Object;
    
    public function ItemEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
    {
      super(type, bubbles, cancelable);
    }
    
    override public function clone():Event
    {
      var e:ItemEvent = new ItemEvent(type, bubbles, cancelable);
      e.selectedItem = selectedItem;
      return e;
    }
    
  }
  
}