package it.ht.rcs.console.network
{
  import spark.components.Label;

  public class IPRenderer extends NetworkObject
	{
    
    private static const WIDTH:Number = 120;
    private static const HEIGHT:Number = 40;
	
		private var textLabel:Label;
		
		public function IPRenderer()
		{
			super();
		}
		
		override protected function createChildren():void
    {
			super.createChildren();
			
      if (textLabel == null)
      {
			  textLabel = new Label();
			  textLabel.text = '255.255.255.255';
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
			
      width = measuredWidth = WIDTH; //textLabel.measuredWidth + 12;
      height = measuredHeight = HEIGHT; //textLabel.measuredHeight + 14;
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