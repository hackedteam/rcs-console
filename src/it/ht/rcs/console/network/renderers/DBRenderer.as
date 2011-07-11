package it.ht.rcs.console.network.renderers
{
  import spark.components.Label;

  public class DBRenderer extends NetworkObject
	{
	
    private static const WIDTH:Number = 120;
    private static const HEIGHT:Number = 40;
    
    public var collectors:Vector.<CollectorRenderer>;
		
		private var textLabel:Label;

		override protected function createChildren():void {
			super.createChildren();
			
			textLabel = new Label();
			textLabel.text = 'DB';
			textLabel.setStyle('fontSize', 20);
			addElement(textLabel);
		}
		
		override protected function measure():void {
			super.measure();
			
			width = measuredWidth = WIDTH; //textLabel.measuredWidth + 20;
			height = measuredHeight = HEIGHT; //textLabel.measuredHeight + 40;
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