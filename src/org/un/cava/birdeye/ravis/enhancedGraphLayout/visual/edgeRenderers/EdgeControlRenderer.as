package org.un.cava.birdeye.ravis.enhancedGraphLayout.visual.edgeRenderers
{
	
	import flash.events.MouseEvent;
	
	import mx.controls.Button;
	import mx.core.IUIComponent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import org.un.cava.birdeye.ravis.enhancedGraphLayout.event.VGEdgeEvent;
	import org.un.cava.birdeye.ravis.graphLayout.data.IEdge;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualEdge;
	import org.un.cava.birdeye.ravis.utils.TypeUtil;
	
	
	/**
	 * This _image displays the graph edge renderers as
	 * primitive icon or as embedded image
	 * */
	public class EdgeControlRenderer extends Button
	{
		public static const FROM_CONTROL:int = 1;
		public static const TO_CONTROL:int = 2;
		
		public var type:int;
		public var isDragging:Boolean = false;
		public function EdgeControlRenderer()
		{
		}
		
		private function addEventListeners():void
		{
			this.addEventListener(MouseEvent.CLICK, mouseEventHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseEventHandler);
			this.addEventListener(MouseEvent.MOUSE_MOVE, mouseEventHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseEventHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseEventHandler);
			this.addEventListener(MouseEvent.DOUBLE_CLICK, mouseEventHandler);
			this.addEventListener(DragEvent.DRAG_DROP, dragDropEventHandler);
			this.addEventListener(DragEvent.DRAG_ENTER, dragEnterHandler);
		}
		
		private function removeEventListeners():void
		{
			this.removeEventListener(MouseEvent.CLICK, mouseEventHandler);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler);
			this.removeEventListener(MouseEvent.MOUSE_UP, mouseEventHandler);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, mouseEventHandler);
			this.removeEventListener(MouseEvent.MOUSE_OVER, mouseEventHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT, mouseEventHandler);
			this.removeEventListener(MouseEvent.DOUBLE_CLICK, mouseEventHandler);
			this.removeEventListener(DragEvent.DRAG_DROP, dragDropEventHandler);
			this.removeEventListener(DragEvent.DRAG_ENTER, dragEnterHandler);
			
		}
		
		private function internalMouseOverHandler(event:MouseEvent):void
		{
		}
		
		private function internalMouseOutHandler(event:MouseEvent):void
		{
		}
		private function mouseEventHandler(event:MouseEvent):void
		{
			var vedge:IVisualEdge = data as IVisualEdge;
			if ((vedge) && (vedge.vgraph))
			{
				var edgeEvent:VGEdgeEvent = new VGEdgeEvent(VGEdgeEvent.VG_EDGE_CONTROL_EVENT_PREFIX + event.type);
				edgeEvent.originalEvent = event;
				edgeEvent.edge = vedge.edge;
				vedge.vgraph.dispatchEvent(edgeEvent);
			}
		}
		
		private function lbMouseEventHandler(event:MouseEvent):void
		{
			var vedge:IVisualEdge = data as IVisualEdge;
			if ((vedge) && (vedge.vgraph))
			{
				var edgeEvent:VGEdgeEvent = new VGEdgeEvent(VGEdgeEvent.VG_EDGE_CONTROL_EVENT_PREFIX + event.type);
				edgeEvent.originalEvent = event;
				edgeEvent.edge = vedge.edge;
				vedge.vgraph.dispatchEvent(edgeEvent);
			}
		}
		
		private function dragEnterHandler(event:DragEvent):void
		{
			var vedge:IVisualEdge = data as IVisualEdge;
			if ((vedge) && (vedge.vgraph))
			{
				var dropTarget:IUIComponent = IUIComponent(event.currentTarget);
				DragManager.acceptDragDrop(dropTarget);
			}
		}
		
		private function dragDropEventHandler(event:DragEvent):void
		{
			var vedge:IVisualEdge = data as IVisualEdge;
			if ((vedge) && (vedge.vgraph))
			{
				var edgeEvent:VGEdgeEvent = new VGEdgeEvent(VGEdgeEvent.VG_EDGE_CONTROL_EVENT_PREFIX + event.type);
				edgeEvent.originalEvent = event;
				edgeEvent.edge = vedge.edge;
				vedge.vgraph.dispatchEvent(edgeEvent);
			}
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			var edge:IEdge = (data as IVisualEdge).edge;
			var visible:String = String(edge.data.visible);
			var fromVisible:String = String(edge.fromNode.data.visible);
			var toVisible:String = String(edge.toNode.data.visible);
			
			
			if (TypeUtil.isFalse(visible) || TypeUtil.isFalse(fromVisible) || TypeUtil.isFalse(toVisible))	
			{
				this.visible = false;
				this.includeInLayout = false;
				this.enabled = false;
			}
			else
			{
				this.buttonMode = true;
				this.useHandCursor = true;
				this.doubleClickEnabled = true;
				this.width = this.height = 8;
				addEventListeners();
			}
		}
		
	}
}