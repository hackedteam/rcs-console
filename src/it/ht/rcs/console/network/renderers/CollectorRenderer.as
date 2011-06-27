package it.ht.rcs.console.network.renderers
{
  import it.ht.rcs.console.network.model.Anonymizer;
  import it.ht.rcs.console.network.model.Collector;
  
  import mx.core.UIComponent;
  import mx.events.DragEvent;
  import mx.managers.DragManager;
  
  import spark.components.Label;

  public class CollectorRenderer extends NetworkObjectRenderer
	{
	
		protected var collector:Collector;
		
		private var textLabel:Label;
		
		public function CollectorRenderer(collector:Collector)
		{
			super();
			
			this.collector = collector;
			
			setStyle('backgroundColor', 0xbbbbbb);
			
			addEventListener(DragEvent.DRAG_ENTER, dragEnter);
			addEventListener(DragEvent.DRAG_EXIT, dragExit);
			addEventListener(DragEvent.DRAG_DROP, dragDrop);
		}
		
		private function dragEnter(event:DragEvent):void
    {
			if (collector.nextHop !== (event.dragInitiator as AnonymizerRenderer).anonymizer)
      {
				var dropTarget:UIComponent = UIComponent(event.currentTarget);					
				DragManager.acceptDragDrop(dropTarget);
				DragManager.showFeedback(DragManager.COPY);
				setStyle('backgroundColor', 0x5555bb);
			}
		}
		
		private function dragExit(event:DragEvent):void
    {
			setStyle('backgroundColor', 0xbbbbbb);
		}
		
		private function dragDrop(event:DragEvent):void
    {
			var sourceAnon:Anonymizer = (event.dragInitiator as AnonymizerRenderer).anonymizer;
			var destAnon:Collector = this.collector;
			
			sourceAnon.moveAfter(destAnon);
			(parent as UIComponent).invalidateDisplayList();
			
			setStyle('backgroundColor', 0xbbbbbb);
		}
		
		override protected function createChildren():void
    {
			super.createChildren();

			textLabel = new Label();
			textLabel.text = collector.ip;
			textLabel.setStyle('fontSize', 18);
			addElement(textLabel);
		}
		
		override protected function measure():void
    {
			super.measure();
			
			measuredWidth = textLabel.measuredWidth + 15;
			measuredHeight = textLabel.measuredHeight + 20;
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