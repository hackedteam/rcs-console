package it.ht.rcs.console.utils.items
{
  
  import flash.events.Event;
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.ui.Keyboard;
  
  import mx.collections.ArrayCollection;
  import mx.collections.ArrayList;
  import mx.events.FlexEvent;
  import mx.managers.PopUpManager;
  
  import spark.collections.Sort;
  import spark.collections.SortField;
  import spark.components.TextInput;

  [Event(name="itemSelected", type="it.ht.rcs.console.utils.items.ItemEvent")]
  public class SearchField extends TextInput
  {
    
    private var dropDown:DropDown;
    
    private var _dataProvider:ArrayCollection;
    private var _selectedItem:Object;

    public var types:Array;
    
    private var numberOfCategories:int = 0;

    private var categories:ArrayList = new ArrayList([
      {label: 'Targets', separator: true, type: 'target'},
      {label: 'Backdoors', separator: true, type: 'backdoor'},
      {label: 'Evidences', separator: true, type: 'evidence'},
      {label: 'Operations', separator: true, type: 'operation'}
    ]);
    
    public function SearchField()
    {
      super();
      
      doubleClickEnabled = true;
      
      dropDown = new DropDown();
      dropDown.addEventListener(ItemEvent.ITEM_SELECTED, itemSelected);
      
      addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
      addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
      addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
      addEventListener(FlexEvent.CREATION_COMPLETE, init);
    }
    
    private function init(event:FlexEvent):void
    {
      dropDown.dataProvider = _dataProvider;
      PopUpManager.addPopUp(dropDown, this, false);
    }
    
    public function set dataProvider(dp:ArrayCollection):void
    {
      _dataProvider = dp;
      _dataProvider.addAllAt(categories, 0);
      _dataProvider.filterFunction = filter;
      
      var sort:Sort = new Sort();
      sort.fields = [new SortField('type', false, false),
                     new SortField('separator', false, false),
                     new SortField('label', false, false)];
      _dataProvider.sort = sort;
      
      for each (var o:Object in _dataProvider)
        if (o.separator)
          numberOfCategories++;
      numberOfCategories = (types == null || types.length == 0) ? numberOfCategories : types.length;
      
      _dataProvider.refresh();
    }
    
    private function filter(item:Object):Boolean
    {
      if (!isVisibleType(item.type)) return false;
      if (item.separator) return true;
      if (text == '') return true;
      
      var result:int = String(item.label.toLowerCase()).indexOf(text.toLowerCase());
      return result >= 0;
    }
    
    private function isVisibleType(type:String):Boolean
    {
      if (types == null || types.length == 0)
        return true;
      
      for each (var t:String in types)
        if (type == t)
          return true;
      
      return false;
    }
    
    private function showDropDown():void {
      // _dataProvider ? _dataProvider.length > numberOfCategories : false;
      var point:Point = localToGlobal(new Point(x, y));
      dropDown.x = point.x - x;
      dropDown.y = point.y - y + height + 5;
       if (dropDown.x + dropDown.width > owner.width)
         dropDown.x = point.x - x - (dropDown.width - width);
      dropDown.visible = true;
    }
    
    private function onKeyUp(event:KeyboardEvent):void
    {
      if (event.keyCode == Keyboard.DOWN) {
        showDropDown();
        dropDown.setFocus();
      } else if (event.keyCode == Keyboard.ESCAPE) {
        text = '';
        dropDown.hide();
      } else if (event.keyCode == Keyboard.ENTER) {
      } else if (event.charCode != 0 && _dataProvider) {
        _dataProvider.refresh();
        showDropDown();
      }
    }
    
    private function onDoubleClick(event:MouseEvent):void
    {
      showDropDown();
    }
    
    private function itemSelected(event:ItemEvent):void
    {
      _selectedItem = event.selectedItem;
      text = _selectedItem.label;
      dropDown.hide();
      dispatchEvent(event.clone());
    }
    
    public function get selectedItem():Object
    {
      return _selectedItem;
    }
    
    private function onRemovedFromStage(event:Event):void
    {
      PopUpManager.removePopUp(dropDown);
    }
    
  }

}