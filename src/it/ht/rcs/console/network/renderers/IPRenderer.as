package it.ht.rcs.console.network.renderers
{
  import spark.components.Label;

  public class IPRenderer extends NetworkObjectRenderer
	{
	
		private var textLabel:Label;
		
		public function IPRenderer()
		{
			super();
		}
		
		override protected function createChildren():void
    {
			super.createChildren();
			
			textLabel = new Label();
			textLabel.text = '255.255.255.255';
			textLabel.setStyle('fontSize', 16);
			addElement(textLabel);
		}
		
		override protected function measure():void
    {
			super.measure();
			
			measuredWidth = textLabel.measuredWidth + 20;
			measuredHeight = textLabel.measuredHeight + 30;
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