package it.ht.rcs.console.utils.items
{
  
  import flash.events.Event;
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.ui.Keyboard;
  
  import it.ht.rcs.console.search.controller.SearchManager;
  import it.ht.rcs.console.skins.TextInputSearchSkin;
  
  import mx.collections.ArrayCollection;
  import mx.collections.IViewCursor;
  import mx.collections.ListCollectionView;
  import mx.events.FlexEvent;
  import mx.managers.PopUpManager;
  
  import spark.collections.Sort;
  import spark.collections.SortField;
  import spark.components.TextInput;

  [Event(name="itemSelected", type="it.ht.rcs.console.utils.items.ItemEvent")]
  public class SearchField extends TextInput
  {
    
    private var dropDown:DropDown;
    
    private var _dataProvider:ListCollectionView;
    [Bindable]
    private var _selectedItem:Object;
    private var _kinds:Array;
    private var _path:ArrayCollection;
    
    private static const kindOrder:Array = ['operation', 'target', 'agent'];
    
    public function SearchField()
    {
      super();
      setStyle('skinClass', TextInputSearchSkin);
      
      doubleClickEnabled = true;
      
      dropDown = new DropDown();
      dropDown.addEventListener(ItemEvent.ITEM_SELECTED, onItemSelected);
      
      addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
      addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
      addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
      addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
      addEventListener(FlexEvent.CREATION_COMPLETE, init);
      dataProvider = SearchManager.instance.getView();
      
      _path = new ArrayCollection();
    }
    
    private function init(event:FlexEvent):void
    {
      dropDown.dataProvider = _dataProvider;
    }
    
    public function get dataProvider():ListCollectionView
    {
      return _dataProvider;
    }
    
    public function set dataProvider(source:ListCollectionView):void
    { 
      _dataProvider = source;
      _dataProvider.filterFunction = filter;
      
      var sort:Sort = new Sort();
      var kindSortField:SortField = new SortField('_kind', false, false);
      kindSortField.compareFunction = kindCompareFunction;
      sort.fields = [kindSortField,
                     new SortField('name', false, false)];
      _dataProvider.sort = sort;
      
      _dataProvider.refresh();
    }
    
    private function kindCompareFunction(a:Object, b:Object):int
    {
      if (a._kind == b._kind) return 0;
      var distance:int = kindOrder.indexOf(a._kind) - kindOrder.indexOf(b._kind);
      return distance / Math.abs(distance);
    }
    
    public function set path(item:Object):void
    {
       _path = item.path;
       _path.addItem(item._id);
       trace("_path = " + _path.toArray());
       _dataProvider.refresh();
    }
    
    public function set kinds(value:Array):void
    {
      _kinds = [];
      for each (var k:* in value)
        if (k !== undefined)
          _kinds.push(k);
      if (_dataProvider)
        _dataProvider.refresh();
    }
    
    private function filter(item:Object):Boolean
    {
      if (!isVisibleType(item._kind)) return false;
      if (item.separator) return true;
      if (text == '') return true;
      
      if (_path.length > item.path.length) return true;
      trace(item.path.toArray());
      trace(_path.toArray());
      for (var i:int = 0; i < _path.length; i++) {
        if (item.path[i] != _path[i]) {
          trace(item.path[i] + " == " + _path[i] + "? ... NO!");
          return false;
        }
        trace(item.path[i] + " == " + _path[i] + "? ... YES!");
      }
      
      // check that item path matches filtering path
      var result:Boolean = String(item.name.toLowerCase()).indexOf(text.toLowerCase()) >= 0 || 
                           String(item.desc.toLowerCase()).indexOf(text.toLowerCase()) >= 0;
      return result;
    }
    
    private function isVisibleType(type:String):Boolean
    {
      if (_kinds == null || _kinds.length == 0)
        return true;
      
      for each (var t:String in _kinds)
        if (type == t)
          return true;
      
      return false;
    }
    
    private function showDropDown():void {
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
      } else if (event.keyCode == Keyboard.ENTER) {
      } else if (event.charCode != 0 && _dataProvider) {
        _selectedItem = dropDown.selectedItem = undefined;
        _dataProvider.refresh();
        showDropDown();
      }
    }
    
    private function onDoubleClick(event:MouseEvent):void
    {
      showDropDown();
    }
    
    private function onItemSelected(event:ItemEvent):void
    {
      _selectedItem = dropDown.selectedItem;
      text = dropDown.selectedItem.name;
      dropDown.hide();
      dispatchEvent(event.clone());
      dispatchEvent(new Event("internalItemChange"));
    }
    
    [Bindable(event="internalItemChange")]
    public function get selectedItem():*
    {
      return _selectedItem;
    }
    
    public function set selectedItem(value:*):void
    {
      if (value)
        dropDown.selectedItem = value;
      
      if (dropDown.selectedItem !== undefined) {
        _selectedItem = value;
        text = value.name;
      } else {
        _selectedItem = undefined;
        text = '';
      }
      dispatchEvent(new Event("internalItemChange"));
    }
    
    public function set selectedItemId(id:String):void
    {
      if (!id) {
        selectedItem = null;
        return;
      }
      
      var cursor:IViewCursor = _dataProvider.createCursor();
      while (!cursor.beforeFirst && !cursor.afterLast) {
        var item:Object = cursor.current;
        if (item._id == id) {
          selectedItem = item;
          break;
        }
        cursor.moveNext();
      }
    }
    
    private function onAddedToStage(event:Event):void
    {
      // don't know why, but we must reassing dataProvider, otherwise filtering doesn't work anymore ...
      //dropDown.dataProvider = _dataProvider;
      PopUpManager.addPopUp(dropDown, this, false);
    }
    
    private function onRemovedFromStage(event:Event):void
    {
      PopUpManager.removePopUp(dropDown);
    }
    
  }

}