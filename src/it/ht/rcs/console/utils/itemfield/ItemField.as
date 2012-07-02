package it.ht.rcs.console.utils.itemfield
{
  import flash.events.Event;
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.ui.Keyboard;
  
  import it.ht.rcs.console.search.controller.SearchManager;
  import it.ht.rcs.console.search.model.SearchItem;
  import it.ht.rcs.console.skins.TextInputSearchSkin;
  
  import mx.collections.ArrayCollection;
  import mx.collections.IList;
  import mx.collections.ListCollectionView;
  import mx.collections.Sort;
  import mx.collections.SortField;
  import mx.events.FlexEvent;
  import mx.managers.PopUpManager;
  
  import spark.components.TextInput;

  [Event(name="itemSelected", type="it.ht.rcs.console.utils.itemfield.ItemFieldEvent")]
  public class ItemField extends TextInput
  {

    private var dropDown:ItemFieldDropDown;
    private var _dataProvider:ListCollectionView;
    
    private var _kinds:Array;
    private var _path:ArrayCollection;
    
    private var _selectedItem:SearchItem;
    
    private static const kindOrder:Array = ['operation', 'target', 'factory', 'agent'];
    
    public function ItemField()
    {
      super();
      setStyle('skinClass', TextInputSearchSkin);
      
      buildDataProvider();
      
      doubleClickEnabled = true;
      
      dropDown = new ItemFieldDropDown();
      dropDown.itemField = this;
      dropDown.addEventListener(ItemFieldEvent.ITEM_SELECTED, onDropDownItemSelected);
      
      addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
      addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
      addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
      
      addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
      addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
      addEventListener(FlexEvent.CREATION_COMPLETE, init);
      
      addEventListener(Event.CHANGE, onTextChange);
      
      _path = new ArrayCollection();
    }
    
    private function onAddedToStage(event:Event):void
    {
      PopUpManager.addPopUp(dropDown, this, false);
    }
    
    private function onRemovedFromStage(event:Event):void
    {
      PopUpManager.removePopUp(dropDown);
    }
    
    private function init(event:FlexEvent):void
    {
      dropDown.dataProvider = _dataProvider;
    }
    
    public function get dataProvider():IList {
      return _dataProvider;
    }
    
    private function buildDataProvider():void
    {
      _dataProvider = SearchManager.instance.getView();
      
      var sort:Sort = new Sort();
      var kindSortField:SortField = new SortField('_kind', true);
      kindSortField.compareFunction = kindCompareFunction;
      sort.fields = [kindSortField,
                     new SortField('name', true)];

      _dataProvider.sort = sort;
      _dataProvider.filterFunction = filter;
      
      _dataProvider.refresh();
    }
    
    private function kindCompareFunction(a:Object, b:Object):int
    {
      if (!a || !b) return 0;
      if (a._kind == b._kind) return 0;
      var distance:int = kindOrder.indexOf(a._kind) - kindOrder.indexOf(b._kind);
      return distance / Math.abs(distance);
    }
    
    public function set kinds(value:Array):void
    {
      _kinds = [];
      for each (var k:* in value)
        _kinds.push(k);
      
      if (_dataProvider != null)
        _dataProvider.refresh();
    }
    
    public function set path(item:Object):void
    {
       if (item == null) return;
       
       _path = item.path;
       _path.addItem(item._id);
       _dataProvider.refresh();
    }
    
    private function filter(item:Object):Boolean
    {
      if (!isVisibleType(item._kind)) return false;
      
      if (_path && _path.length > 0) {
        for (var i:int = 0; i < item.path.length; i++) {
         
          if (item.path[i] != _path[i])
            return false;
        }
      }
      
      if (text == '') return true;
      
      var toMatch:String = item.name.toLowerCase() + ' ' + item.desc.toLowerCase();
      if (item.ident)
        toMatch = toMatch + ' ' + item.ident.toLowerCase();
      
      return toMatch.indexOf(text.toLowerCase()) >= 0;
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
    
    private function onDoubleClick(event:MouseEvent):void
    {
      showDropDown();
    }
    
    private function showDropDown():void {
      var point:Point = localToGlobal(new Point(x, y));
      dropDown.x = point.x - x;
      dropDown.y = point.y - y + height + 5;
      if (dropDown.x + dropDown.width > owner.width)
        dropDown.x = point.x - x - (dropDown.width - width);
      
      dropDown.show();
    }
    
    private function onKeyUp(event:KeyboardEvent):void
    {
      if (event.keyCode == Keyboard.ESCAPE ||
          event.keyCode == Keyboard.ENTER) {}
      
      else if (event.keyCode == Keyboard.DOWN ||
               event.keyCode == Keyboard.UP) {
        showDropDown();
        dropDown.setFocus();
      }
      
      else if (event.charCode != 0 && _dataProvider != null) {
        _dataProvider.refresh();
        showDropDown();
      }
    }
    
    private function onKeyDown(event:KeyboardEvent):void
    {
      if (event.keyCode == Keyboard.ESCAPE && dropDown.visible)
        dropDown.hide();

      else if (event.keyCode == Keyboard.ENTER && dropDown.selectedItem)
        selectItem(dropDown.selectedItem);
    }
    
    private function onDropDownItemSelected(event:ItemFieldEvent):void
    {
      selectItem(event.selectedItem);
    }
    
    private function selectItem(item:SearchItem, interactive:Boolean=true):void
    {
      _selectedItem = item;
      text = _selectedItem ? _selectedItem.name : null;
      
      if (interactive)
      {
        dropDown.hide();
        setFocus();
        selectAll();
        
        _dataProvider.refresh();
        
        var event:ItemFieldEvent = new ItemFieldEvent(ItemFieldEvent.ITEM_SELECTED, item);
        dispatchEvent(event);
      }
    }
    
    public function get selectedItem():SearchItem
    {
      return _selectedItem;
    }
    
    public function set selectedItemId(id:String):void
    {
      if (id == null) selectItem(null, false);
      for each (var item:SearchItem in _dataProvider)
        if (item._id == id)
          selectItem(item, false);
    }
    
    private function onTextChange(e:Event):void
    {
      trace("changed "+this.text);
      _selectedItem=null;
      
      for(var i:int=0;i<this.dataProvider.length;i++)
      {
        var item:SearchItem=dataProvider[i] as SearchItem;
        
        if(item.name==this.text)
        {
          _selectedItem=item;
          break;
        }
      }
    }
    
  }

}