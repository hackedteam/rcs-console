package it.ht.rcs.console.network.renderers
{
  import flash.events.MouseEvent;
  
  import it.ht.rcs.console.network.model.Anonymizer;
  
  import mx.core.DragSource;
  import mx.core.UIComponent;
  import mx.events.DragEvent;
  import mx.managers.DragManager;
  
  import spark.components.Label;
	
	public class AnonymizerRenderer extends NetworkObjectRenderer
	{
	
		public var anonymizer:Anonymizer;
		
		private var textLabel:Label;
		
		public function AnonymizerRenderer(anonymizer:Anonymizer)
		{
			trace('--- AnonymizerRenderer: constructor()');
			super();
			
			this.anonymizer = anonymizer;
			
			buttonMode = true;
			setStyle('backgroundColor', 0xbbbbbb);
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
//			addEventListener(MouseEvent.CLICK, function(event:Event):void {
//				Alert.show('click');
//			});
			addEventListener(DragEvent.DRAG_ENTER, dragEnter);
			addEventListener(DragEvent.DRAG_EXIT, dragExit);
			addEventListener(DragEvent.DRAG_DROP, dragDrop);
		}
		
		private function dragEnter(event:DragEvent):void {
			var dragged:AnonymizerRenderer = event.dragInitiator as AnonymizerRenderer;
			if (dragged !== this && anonymizer.nextHop !== dragged.anonymizer) {
				var dropTarget:UIComponent = UIComponent(event.currentTarget);					
				DragManager.acceptDragDrop(dropTarget);
				DragManager.showFeedback(DragManager.COPY);
				setStyle('backgroundColor', 0x5555bb);
			}
		}
		
		private function dragExit(event:DragEvent):void {
			setStyle('backgroundColor', 0xbbbbbb);
		}
		
		private function dragDrop(event:DragEvent):void {
			
			var sourceAnon:Anonymizer = (event.dragInitiator as AnonymizerRenderer).anonymizer;
			var destAnon:Anonymizer = this.anonymizer;
			
			sourceAnon.moveAfter(destAnon);
			(parent as UIComponent).invalidateDisplayList();
			
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
		
		override protected function createChildren():void {
			trace('--- AnonymizerRenderer: createChildren()');
			super.createChildren();

			textLabel = new Label();
			textLabel.text = anonymizer.ip;
			textLabel.setStyle('fontSize', 18);
			addElement(textLabel);
		}
		
		override protected function measure():void {
			trace('--- AnonymizerRenderer: measure()');
			super.measure();
			
			measuredWidth = textLabel.measuredWidth + 15;
			measuredHeight = textLabel.measuredHeight + 20;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			trace('--- AnonymizerRenderer: updateDisplayList()');
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			graphics.beginFill(getStyle('backgroundColor'));
			graphics.drawRoundRect(0, 0, measuredWidth, measuredHeight, 20, 20);
			graphics.endFill();
		}
		
	}
	
}