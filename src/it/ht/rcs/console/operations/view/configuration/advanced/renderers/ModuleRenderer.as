package it.ht.rcs.console.operations.view.configuration.advanced.renderers
{
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.ui.Mouse;
  import flash.ui.MouseCursor;
  import flash.utils.getDefinitionByName;
  
  import it.ht.rcs.console.operations.view.configuration.advanced.ConfigurationGraph;
  import it.ht.rcs.console.operations.view.configuration.advanced.forms.modules.AllModuleForms;
  import it.ht.rcs.console.operations.view.configuration.advanced.forms.modules.ModuleForm;
  
  import mx.managers.PopUpManager;
  
  import spark.components.BorderContainer;
  import spark.components.Group;
  import spark.primitives.BitmapImage;
  
  public class ModuleRenderer extends Group implements Linkable
  {
    private static const WIDTH:Number  = 45;
    private static const HEIGHT:Number = 45;
    
    private static const NORMAL_COLOR:uint = 0xffffff;
    private static const ACCEPT_COLOR:uint   = 0x99bb99;
    private static const REJECT_COLOR:uint   = 0xbb9999;
    
    private var container:BorderContainer;
    private var icon:BitmapImage;
    
    private var inBound:Vector.<Connection> = new Vector.<Connection>();
    public function inBoundConnections():Vector.<Connection>  { return inBound; }
    public function outBoundConnections():Vector.<Connection> { return null; }
    
    private var graph:ConfigurationGraph;
    
    public var module:Object;
    
    private static const packagePrefix:String = 'it.ht.rcs.console.operations.view.configuration.advanced.forms.modules.';
    private static const forms:AllModuleForms = null; // This reference is just to force the import of the form classes
    
    public function ModuleRenderer(module:Object, graph:ConfigurationGraph)
    {
      super();
      layout = null;
      doubleClickEnabled = true;
      width = WIDTH;
      height = HEIGHT;
      
      this.module = module;
      this.graph = graph;
      
      addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
      addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
      addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
      addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
      addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
    }
    
    private function onMouseDown(me:MouseEvent):void
    {
      me.stopPropagation();
    }
    
    private function onMouseOver(me:MouseEvent):void
    {
      me.stopPropagation();
      Mouse.cursor = MouseCursor.AUTO;
      
      if (graph.mode == ConfigurationGraph.CONNECTING) {
        var pin:Pin = graph.currentConnection.from as Pin;
        var origin:Object = pin.parent;
        if (origin is ActionRenderer && ( pin.type == 'start' || pin.type == 'stop' )) { // Accept only inbound connections from actions
          graph.currentTarget = this;
          container.setStyle('backgroundColor', ACCEPT_COLOR);
        } else {
          graph.currentTarget = null;
          container.setStyle('backgroundColor', REJECT_COLOR);
        }
      }
    }
    
    private function onMouseOut(me:MouseEvent):void
    {
      if (graph.mode == ConfigurationGraph.CONNECTING) {
        graph.currentTarget = null;
        container.setStyle('backgroundColor', NORMAL_COLOR);
      }
    }
    
    private function onMouseUp(me:MouseEvent):void
    {
      if (graph.mode == ConfigurationGraph.CONNECTING)
        container.setStyle('backgroundColor', NORMAL_COLOR);
    }
    
    private function onDoubleClick(me:MouseEvent):void
    {
      try {
        var Form:Class = getDefinitionByName(packagePrefix + module.module) as Class;
        var popup:ModuleForm = PopUpManager.createPopUp(root, Form, true) as ModuleForm;
        popup.module = module;
        PopUpManager.centerPopUp(popup);
      } catch (e:Error) {}
    }
    
    override protected function createChildren():void
    {
      super.createChildren();
      
      if (container == null)
      {
        
        container = new BorderContainer();
        container.width = width;
        container.height = height;
        container.toolTip = module.module;
        container.setStyle('backgroundColor', NORMAL_COLOR);
        container.setStyle('borderColor', 0xdddddd);
        container.setStyle('cornerRadius', 10);
        
        icon = new BitmapImage();
        icon.horizontalCenter = icon.verticalCenter = 0;
        icon.source = ModuleIcons[module.module];
        container.addElement(icon);
        
        addElement(container);
        
      }
      
    }

    public function getLinkPoint():Point
    {
      return new Point(x + width/2, y - 5);
    }
    
  }
  
}