package it.ht.rcs.console.network.model
{
  import flash.events.MouseEvent;
  
  import it.ht.rcs.console.network.CollectorListRenderer;
  
  import mx.core.DragSource;
  import mx.core.UIComponent;
  import mx.events.DragEvent;
  import mx.managers.DragManager;
  
  import spark.components.Label;
  import it.ht.rcs.console.network.renderers.NetworkObject;
	
	public class oldAnonymizerRenderer extends NetworkObject
	{
	
		public var anonymizer:Anonymizer;
		
		private var textLabel:Label;
		
		public function oldAnonymizerRenderer(anonymizer:Anonymizer)
		{
			super();
			
			this.anonymizer = anonymizer;
			
			buttonMode = true;
			setStyle('backgroundColor', 0xbbbbbb);
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addEventListener(DragEvent.DRAG_ENTER, dragEnter);
			addEventListener(DragEvent.DRAG_EXIT, dragExit);
			addEventListener(DragEvent.DRAG_DROP, dragDrop);
		}
		
		private function dragEnter(event:DragEvent):void
    {
      var accept:Boolean = false;
      if (event.dragInitiator is AnonymizerRenderer) {
  			var dragged:AnonymizerRenderer = event.dragInitiator as AnonymizerRenderer;
  			accept = dragged !== this && anonymizer.nextHop !== dragged.anonymizer;
      } else if (event.dragInitiator is CollectorListRenderer) {
        accept = true;
      }

      if (accept) {
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
      if (event.dragInitiator as AnonymizerRenderer) {
			  var sourceAnon:Anonymizer = (event.dragInitiator as AnonymizerRenderer).anonymizer;
			  var destAnon:Anonymizer = this.anonymizer;
			  sourceAnon.moveAfter(destAnon);
			  (parent as UIComponent).invalidateDisplayList();
      } else if (event.dragInitiator is CollectorListRenderer) {
        //coll = (event.dragInitiator as CollectorListRenderer).data as Collector
        var destAnon:Anonymizer = this.anonymizer;
        sourceAnon.moveAfter(destAnon);
        (parent as UIComponent).invalidateDisplayList();
      }
			
			setStyle('backgroundColor', 0xbbbbbb);
		}
		
		private function mouseDown(event:MouseEvent):void
		{
			if (event.currentTarget is AnonymizerRenderer)
			{
				var dragInitiator:AnonymizerRenderer = event.currentTarget as AnonymizerRenderer;
				var dragSource:DragSource = new DragSource();
				DragManager.doDrag(dragInitiator, dragSource, event, getProxy(dragInitiator));
			}
		}
		
		
	}
	
}