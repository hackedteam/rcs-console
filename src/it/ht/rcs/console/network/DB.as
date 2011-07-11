package it.ht.rcs.console.network
{
  import it.ht.rcs.console.model.Collector;
  
  import spark.components.Label;

  public class DB extends NetworkObject
	{
	
    public var collectors:Vector.<Collector>;
		
		private var textLabel:Label;

		public function DB()
		{
			super();
		}
		
		override protected function createChildren():void
    {
			super.createChildren();
			
			textLabel = new Label();
			textLabel.text = '255.255.255.255';
			textLabel.setStyle('fontSize', 16);
      textLabel.setStyle('fontWeight', 'bold');
			addElement(textLabel);
		}
		
		override protected function measure():void
    {
			super.measure();
			
			measuredWidth = textLabel.measuredWidth + 18;
			measuredHeight = textLabel.measuredHeight + 32;
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