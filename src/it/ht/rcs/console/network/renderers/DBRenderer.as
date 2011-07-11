package it.ht.rcs.console.network.renderers
{
  import it.ht.rcs.console.network.model.DBModel;
  
  import spark.components.Label;

  public class DBRenderer extends NetworkObject
	{
	
		private var db:DBModel;
		
		private var textLabel:Label;

		public function DBRenderer(db:DBModel)
		{
			super();
			
			this.db = db;
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			textLabel = new Label();
			textLabel.text = '255.255.255.255';
			textLabel.setStyle('fontSize', 20);
			addElement(textLabel);
		}
		
		override protected function measure():void {
			super.measure();
			
			measuredWidth = textLabel.measuredWidth + 20;
			measuredHeight = textLabel.measuredHeight + 40;
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