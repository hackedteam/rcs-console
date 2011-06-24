package it.ht.rcs.console.network.renderers
{
  import spark.components.Label;

  public class IPRenderer extends NetworkObjectRenderer
	{
	
		private var textLabel:Label;
		
		public function IPRenderer()
		{
			trace('--- IPRenderer: constructor()');
			super();
		}
		
		override protected function createChildren():void {
			trace('--- IPRenderer: createChildren()');
			super.createChildren();
			
			textLabel = new Label();
			textLabel.text = '255.255.255.255';
			textLabel.setStyle('fontSize', 16);
			addElement(textLabel);
		}
		
		override protected function measure():void {
			trace('--- IPRenderer: measure()');
			super.measure();
			
			measuredWidth = textLabel.measuredWidth + 20;
			measuredHeight = textLabel.measuredHeight + 30;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			trace('--- IPRenderer: updateDisplayList()');
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			graphics.beginFill(0xdddddd);
			graphics.drawEllipse(0, 0, measuredWidth, measuredHeight);
			graphics.endFill();
		}
		
	}
	
}