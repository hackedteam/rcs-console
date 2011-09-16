package it.ht.rcs.console.system.view.backend.renderers
{
  import flash.events.Event;
  
  import spark.components.Group;
  import spark.components.Label;
  import spark.filters.DropShadowFilter;
  import spark.layouts.HorizontalLayout;

  public class DBRenderer extends Group
	{
	
    private static const WIDTH:Number  = 120;
    private static const HEIGHT:Number = 40;
    
    public var shards:Vector.<ShardRenderer>;
    
		private var textLabel:Label;
    
    public function DBRenderer()
    {
      var hl:HorizontalLayout = new HorizontalLayout();
      hl.horizontalAlign = 'center';
      hl.verticalAlign = 'middle';
      hl.paddingTop = 2;
      layout = hl;
      
      filters = [new DropShadowFilter(3, 45, 0x333333, 1, 3, 3, 1, 2, false, false, false)];
    }
    
		override protected function createChildren():void
    {
			super.createChildren();
			
      if (textLabel == null)
      {
        textLabel = new Label();
        textLabel.text = 'RCS';
        textLabel.setStyle('fontSize', 20);
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
			
			graphics.beginFill(0xdddddd);
			graphics.drawEllipse(0, 0, measuredWidth, measuredHeight);
			graphics.endFill();
		}
		
	}
	
}