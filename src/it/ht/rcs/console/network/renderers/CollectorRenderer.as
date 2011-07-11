package it.ht.rcs.console.network.renderers
{
  import flash.events.MouseEvent;
  
  import it.ht.rcs.console.network.model.Collector;
  
  import mx.core.DragSource;
  import mx.core.UIComponent;
  import mx.events.DragEvent;
  import mx.managers.DragManager;
  
  import spark.components.Label;

  public class CollectorRenderer extends NetworkObject
	{
    
    private static const WIDTH:Number = 120;
    private static const HEIGHT:Number = 32;
	
		protected var collector:Collector;
		
		private var textLabel:Label;
		
		public function CollectorRenderer(collector:Collector)
		{
			super();
			
			this.collector = collector;
      if (collector.type == 'remote')
			  this.buttonMode = true;
			setStyle('backgroundColor', 0xbbbbbb);
			
      addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addEventListener(DragEvent.DRAG_ENTER, dragEnter);
			addEventListener(DragEvent.DRAG_EXIT, dragExit);
			addEventListener(DragEvent.DRAG_DROP, dragDrop);
		}
		
    private function mouseDown(event:MouseEvent):void
    {
      if ((event.currentTarget as CollectorRenderer).collector.type == 'remote')
      {
        var dragInitiator:CollectorRenderer = event.currentTarget as CollectorRenderer;
        var dragSource:DragSource = new DragSource();
        DragManager.doDrag(dragInitiator, dragSource, event, getProxy(dragInitiator));
      }
    }
    
		private function dragEnter(event:DragEvent):void
    {
			if (collector.nextHop !== (event.dragInitiator as CollectorRenderer).collector)
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
//			var sourceAnon:Anonymizer = (event.dragInitiator as AnonymizerRenderer).anonymizer;
//			var destAnon:Collector = this.collector;
//			
//			sourceAnon.moveAfter(destAnon);
//      (parent as UIComponent).invalidateSize();
//			(parent as UIComponent).invalidateDisplayList();
			
			setStyle('backgroundColor', 0xbbbbbb);
		}

    override protected function createChildren():void
    {
			super.createChildren();

      if (textLabel == null)
      {
  			textLabel = new Label();
  			textLabel.text = collector.address;
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
			
			graphics.beginFill(getStyle('backgroundColor'));
			graphics.drawRoundRect(0, 0, measuredWidth, measuredHeight, 20, 20);
			graphics.endFill();
		}
		
	}
	
}