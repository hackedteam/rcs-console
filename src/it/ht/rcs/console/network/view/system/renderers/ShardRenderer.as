package it.ht.rcs.console.network.view.system.renderers
{
  import it.ht.rcs.console.system.model.Shard;
  
  import spark.components.Group;
  import spark.components.Label;

  public class ShardRenderer extends Group
	{
    
    private static const WIDTH:Number  = 200;
    private static const HEIGHT:Number = 200;
    
    private static const NORMAL_COLOR:Number   = 0xbbbbbb;
    private static const SELECTED_COLOR:Number = 0x8888bb;
	  
		public var shard:Shard;
		
		private var textLabel:Label;
		
		public function ShardRenderer(shard:Shard)
		{
			super();
			
			this.shard = shard;
      
			setStyle('backgroundColor', NORMAL_COLOR);
			
      //addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}

    override protected function createChildren():void
    {
			super.createChildren();

      if (textLabel == null)
      {
  			textLabel = new Label();
        //BindingUtils.bindProperty(textLabel, 'text', stats, 'name');
  			textLabel.setStyle('fontSize', 12);
        textLabel.setStyle('textAlign', 'center');
        textLabel.width = WIDTH - 20;
        textLabel.maxDisplayedLines = 1;
  			addElement(textLabel);
      }
		}
		
		override protected function measure():void
    {
			super.measure();
			
			width = measuredWidth = WIDTH;
			height = measuredHeight = HEIGHT;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			graphics.beginFill(getStyle('backgroundColor'));
			graphics.drawRoundRect(0, 0, measuredWidth, measuredHeight, 20, 20);
			graphics.endFill();
		}
		
	}
	
}