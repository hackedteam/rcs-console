package it.ht.rcs.console.utils.items
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
  import mx.collections.ArrayList;
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
    private var _selectedItem:Object;
    private var _types:Array;
    
    //private var numberOfCategories:int = 0;
    
    private var categories:ArrayList = new ArrayList([
      {name: 'Operations', separator: true, _kind: 'operation'},
      {name: 'Targets', separator: true, _kind: 'target'},
      {name: 'Backdoors', separator: true, _kind: 'backdoor'}
    ]);
    
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
    }
    
    private function init(event:FlexEvent):void
    {
      dataProvider = SearchManager.instance.getView();
      dropDown.dataProvider = _dataProvider;
    }
    
    public function get dataProvider():ListCollectionView
    {
      return _dataProvider;
    }
    
    public function set dataProvider(source:ListCollectionView):void
    { 
      _dataProvider = source;
      //_dataProvider.addAllAt(categories, 0);
      _dataProvider.filterFunction = filter;
      
      var sort:Sort = new Sort();
      sort.fields = [new SortField('_kind', false, false),
                     //new SortField('separator', true, false),
                     new SortField('name', false, false)];
      _dataProvider.sort = sort;
      
//      for each (var o:Object in _dataProvider)
//        if (o.separator)
//          numberOfCategories++;
//      numberOfCategories = (_types == null || _types.length == 0) ? numberOfCategories : _types.length;
      
      _dataProvider.refresh();
    }
    
    public function set kinds(t:Array):void
    {
      _types = t;
      _dataProvider.refresh();
    }
    
    private function filter(item:Object):Boolean
    {
      if (!isVisibleType(item._kind)) return false;
      if (item.separator) return true;
      if (this.text == '') return true;
      
      var result:Boolean = String(item.name.toLowerCase()).indexOf(this.text.toLowerCase()) >= 0 || String(item.desc.toLowerCase()).indexOf(this.text.toLowerCase()) >= 0;
      return result;
    }
    
    private function isVisibleType(type:String):Boolean
    {
      if (_types == null || _types.length == 0)
        return true;
      
      for each (var t:String in _types)
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
      //dropDown.selectedItem = _selectedItem;
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
    }
    
    public function get selectedItem():*
    {
      return _selectedItem;
    }
    
    public function set selectedItem(value:*):void
    {
      if (value) dropDown.selectedItem = value;
      if (dropDown.selectedItem !== undefined) {
        _selectedItem = value;
        text = value.name;
      } else {
        _selectedItem = undefined;
        text = '';
      }
    }
    
    private function onAddedToStage(event:Event):void
    {
      // don't know why, but we must reassing dataProvider, otherwise filtering doesn't work anymore ...
      dropDown.dataProvider = _dataProvider;
      PopUpManager.addPopUp(dropDown, this, false);
    }
    
    private function onRemovedFromStage(event:Event):void
    {
      PopUpManager.removePopUp(dropDown);
    }
    
  }

}