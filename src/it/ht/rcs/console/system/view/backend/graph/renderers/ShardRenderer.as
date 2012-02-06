package it.ht.rcs.console.system.view.backend.graph.renderers
{
  import flash.events.MouseEvent;
  import flash.ui.Mouse;
  import flash.ui.MouseCursor;
  
  import it.ht.rcs.console.shard.model.Shard;
  
  import mx.binding.utils.BindingUtils;
  
  import spark.components.BorderContainer;
  import spark.components.Label;
  import spark.primitives.BitmapImage;

  public class ShardRenderer extends NetworkObject
	{
    
    private static const WIDTH:Number  = 90; // 5*2 (padding) + 80 (width of label)
    private static const HEIGHT:Number = 66 + 26; // 5*2 (padding) + 50 (height of container) + 6 (gap) + 26 (height of label)
    
    private static const NORMAL_COLOR:Number = 0xffffff;
    private static const SELECTED_COLOR:Number = 0xa8c6ee;
	  
		public var shard:Shard;
		
    [Embed(source='/img/NEW/database.png')]
    private const shardIcon:Class;
    
    [Embed(source='/img/NEW/ok.png')]
    private const okIcon:Class;
    [Embed(source='/img/NEW/error.png')]
    private const errorIcon:Class;
    
    private var container:BorderContainer;
    private var icon:BitmapImage;
    private var status:BitmapImage;
    private var textLabel:Label;
		
		public function ShardRenderer()
		{
			super();
      this.width = WIDTH;
      this.height = HEIGHT;
			
      addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
      addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
      addEventListener(MouseEvent.CLICK, onClick);
		}
		
    override protected function createChildren():void
    {
			super.createChildren();

      if (container == null)
      {
        container = new BorderContainer();
        container.width = 50;
        container.height = 50;
        container.setStyle('backgroundColor', NORMAL_COLOR);
        container.setStyle('borderColor', 0xdddddd);
        container.setStyle('cornerRadius', 10);
        
        icon = new BitmapImage();
        icon.horizontalCenter = icon.verticalCenter = 0;
        icon.source = shardIcon;
        container.addElement(icon);
        
        status = new BitmapImage();
        status.top = -6;
        status.right = -6;
        status.source = okIcon;
        container.addElement(status);
        
        addElement(container);
      }
      
      if (textLabel == null)
      {
  			textLabel = new Label();
        BindingUtils.bindProperty(textLabel, 'text', shard, 'host');
        textLabel.setStyle('textAlign', 'center');
        textLabel.width = 80;
        textLabel.maxDisplayedLines = 2;
  			addElement(textLabel);
      }
		}
    
    private function onMouseOver(me:MouseEvent):void
    {
      me.stopPropagation();
      Mouse.cursor = MouseCursor.AUTO;
    }
    
    private function onMouseDown(me:MouseEvent):void
    {
      me.stopPropagation();
    }
    
    private function onClick(me:MouseEvent):void
    {
      me.stopPropagation();
      container.width = 100;
      container.height = 100;
    }
		
	}
	
}