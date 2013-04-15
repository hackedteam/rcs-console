package org.un.cava.birdeye.ravis.enhancedGraphLayout.visual.edgeRenderers
{
	import flash.display.DisplayObject;
	import flash.events.ContextMenuEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import mx.core.Application;
	import mx.core.IDataRenderer;
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	import mx.managers.PopUpManager;
	import mx.utils.UIDUtil;
	
	import org.un.cava.birdeye.ravis.enhancedGraphLayout.event.VGEdgeEvent;
	import org.un.cava.birdeye.ravis.enhancedGraphLayout.ui.dataProperty.EdgeProperty;
	import org.un.cava.birdeye.ravis.enhancedGraphLayout.visual.EnhancedVisualGraph;
	import org.un.cava.birdeye.ravis.graphLayout.data.IEdge;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualEdge;
	import org.un.cava.birdeye.ravis.utils.TypeUtil;
	
	/**
	 * This _image displays the graph edge renderers as
	 * primitive icon or as embedded image
	 * */
	public class EdgeRenderer extends UIComponent implements IDataRenderer
	{
		public var layoutOrientation:int;
		public var fromDistance:Number = 0;
		public var toDistance:Number = 0;
		public var label:TextField = new TextField();
		private var _fromControl:UIComponent;
		private var _toControl:UIComponent;
		
		public var enableLabel:Boolean = true;
		
		public function EdgeRenderer()
		{
			super();
			this.contextMenu = createContextMenu();
		}
		
		protected function createContextMenu():ContextMenu
		{
			var contextMenu:ContextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();
			
			var editEdge:ContextMenuItem = new ContextMenuItem("Edit Line");
			editEdge.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, editEdgeItemClick);
			contextMenu.customItems.push(editEdge);
			
			var insertNode:ContextMenuItem = new ContextMenuItem("Insert Node");
			insertNode.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, insertNodeItemClick);
			contextMenu.customItems.push(insertNode);
			return contextMenu;	
		}
		
		private function editEdgeItemClick(event:ContextMenuEvent):void
		{
			var popUp:EdgeProperty = PopUpManager.createPopUp(root, EdgeProperty, true) as EdgeProperty;
			PopUpManager.centerPopUp(popUp);
			popUp.data = IVisualEdge(this.data).edge;
			
		}
		
		private function insertNodeItemClick(event:ContextMenuEvent):void
		{
			var nodeData:Object = {id:UIDUtil.createUID(), nodeColor:0x8F8FFF, nodeSize:10, nodeClass:"leaf", nodeIcon:15};
			EnhancedVisualGraph(IVisualEdge(this.data).vgraph).addVNodeToEdge(nodeData.id, nodeData, IVisualEdge(this.data).edge, true);	
		}
		
		private function addEventListeners():void
		{
			this.addEventListener(MouseEvent.MOUSE_OVER, internalMouseOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, internalMouseOutHandler);
			
			this.addEventListener(MouseEvent.CLICK, mouseEventHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseEventHandler);
			this.addEventListener(MouseEvent.MOUSE_MOVE, mouseEventHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseEventHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseEventHandler);
			this.addEventListener(MouseEvent.DOUBLE_CLICK, mouseEventHandler);
			this.addEventListener(DragEvent.DRAG_DROP, dragDropEventHandler);
			this.addEventListener(DragEvent.DRAG_ENTER, dragEnterHandler);
			this.addEventListener(DragEvent.DRAG_ENTER, dragDropEventHandler);
			this.addEventListener(DragEvent.DRAG_OVER, dragDropEventHandler);
			this.addEventListener(DragEvent.DRAG_EXIT, dragDropEventHandler);
			
			if (label)
			{
				label.addEventListener(MouseEvent.CLICK, lbMouseEventHandler);
				label.addEventListener(MouseEvent.MOUSE_DOWN, lbMouseEventHandler);
				label.addEventListener(MouseEvent.MOUSE_UP, lbMouseEventHandler);
				label.addEventListener(MouseEvent.MOUSE_MOVE, lbMouseEventHandler);
				label.addEventListener(MouseEvent.MOUSE_OVER, lbMouseEventHandler);
				label.addEventListener(MouseEvent.MOUSE_OUT, lbMouseEventHandler);
				label.addEventListener(MouseEvent.DOUBLE_CLICK, lbMouseEventHandler);
				label.addEventListener(DragEvent.DRAG_DROP, lbDragDropEventHandler);
				label.addEventListener(DragEvent.DRAG_ENTER, lbDragEnterHandler);
				label.addEventListener(DragEvent.DRAG_ENTER, lbDragDropEventHandler);
				label.addEventListener(DragEvent.DRAG_OVER, lbDragDropEventHandler);
				label.addEventListener(DragEvent.DRAG_EXIT, lbDragDropEventHandler);
			}
			
			if (fromControl)
			{
				fromControl.addEventListener(MouseEvent.CLICK, fromControlMouseEventHandler);
				fromControl.addEventListener(MouseEvent.MOUSE_DOWN, fromControlMouseEventHandler);
				fromControl.addEventListener(MouseEvent.MOUSE_UP, fromControlMouseEventHandler);
				fromControl.addEventListener(MouseEvent.MOUSE_MOVE, fromControlMouseEventHandler);
				fromControl.addEventListener(MouseEvent.MOUSE_OVER, fromControlMouseEventHandler);
				fromControl.addEventListener(MouseEvent.MOUSE_OUT, fromControlMouseEventHandler);
				fromControl.addEventListener(MouseEvent.DOUBLE_CLICK, fromControlMouseEventHandler);
			}
			if (toControl)
			{
				toControl.addEventListener(MouseEvent.CLICK, toControlMouseEventHandler);
				toControl.addEventListener(MouseEvent.MOUSE_DOWN, toControlMouseEventHandler);
				toControl.addEventListener(MouseEvent.MOUSE_UP, toControlMouseEventHandler);
				toControl.addEventListener(MouseEvent.MOUSE_MOVE, toControlMouseEventHandler);
				toControl.addEventListener(MouseEvent.MOUSE_OVER, toControlMouseEventHandler);
				toControl.addEventListener(MouseEvent.MOUSE_OUT, toControlMouseEventHandler);
				toControl.addEventListener(MouseEvent.DOUBLE_CLICK, toControlMouseEventHandler);
			}
		}
		
		private function removeEventListeners():void
		{
			this.removeEventListener(MouseEvent.MOUSE_OVER, internalMouseOverHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT, internalMouseOutHandler);
			
			this.removeEventListener(MouseEvent.CLICK, mouseEventHandler);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler);
			this.removeEventListener(MouseEvent.MOUSE_UP, mouseEventHandler);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, mouseEventHandler);
			this.removeEventListener(MouseEvent.MOUSE_OVER, mouseEventHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT, mouseEventHandler);
			this.removeEventListener(MouseEvent.DOUBLE_CLICK, mouseEventHandler);
			this.removeEventListener(DragEvent.DRAG_DROP, dragDropEventHandler);
			this.removeEventListener(DragEvent.DRAG_ENTER, dragEnterHandler);
			this.removeEventListener(DragEvent.DRAG_ENTER, dragDropEventHandler);
			this.removeEventListener(DragEvent.DRAG_OVER, dragDropEventHandler);
			this.removeEventListener(DragEvent.DRAG_EXIT, dragDropEventHandler);
			
			if (label)
			{
				label.removeEventListener(MouseEvent.CLICK, lbMouseEventHandler);
				label.removeEventListener(MouseEvent.MOUSE_DOWN, lbMouseEventHandler);
				label.removeEventListener(MouseEvent.MOUSE_UP, lbMouseEventHandler);
				label.removeEventListener(MouseEvent.MOUSE_MOVE, lbMouseEventHandler);
				label.removeEventListener(MouseEvent.MOUSE_OVER, lbMouseEventHandler);
				label.removeEventListener(MouseEvent.MOUSE_OUT, lbMouseEventHandler);
				label.removeEventListener(MouseEvent.DOUBLE_CLICK, lbMouseEventHandler);
				label.removeEventListener(DragEvent.DRAG_DROP, lbDragDropEventHandler);
				label.removeEventListener(DragEvent.DRAG_ENTER, lbDragEnterHandler);
				label.removeEventListener(DragEvent.DRAG_ENTER, lbDragDropEventHandler);
				label.removeEventListener(DragEvent.DRAG_OVER, lbDragDropEventHandler);
				label.removeEventListener(DragEvent.DRAG_EXIT, lbDragDropEventHandler);
			}
			
			
			if (fromControl)
			{
				fromControl.removeEventListener(MouseEvent.CLICK, fromControlMouseEventHandler);
				fromControl.removeEventListener(MouseEvent.MOUSE_DOWN, fromControlMouseEventHandler);
				fromControl.removeEventListener(MouseEvent.MOUSE_UP, fromControlMouseEventHandler);
				fromControl.removeEventListener(MouseEvent.MOUSE_MOVE, fromControlMouseEventHandler);
				fromControl.removeEventListener(MouseEvent.MOUSE_OVER, fromControlMouseEventHandler);
				fromControl.removeEventListener(MouseEvent.MOUSE_OUT, fromControlMouseEventHandler);
				fromControl.removeEventListener(MouseEvent.DOUBLE_CLICK, fromControlMouseEventHandler);
			}
			if (toControl)
			{	
				toControl.removeEventListener(MouseEvent.CLICK, toControlMouseEventHandler);
				toControl.removeEventListener(MouseEvent.MOUSE_DOWN, toControlMouseEventHandler);
				toControl.removeEventListener(MouseEvent.MOUSE_UP, toControlMouseEventHandler);
				toControl.removeEventListener(MouseEvent.MOUSE_MOVE, toControlMouseEventHandler);
				toControl.removeEventListener(MouseEvent.MOUSE_OVER, toControlMouseEventHandler);
				toControl.removeEventListener(MouseEvent.MOUSE_OUT, toControlMouseEventHandler);
				toControl.removeEventListener(MouseEvent.DOUBLE_CLICK, toControlMouseEventHandler);
			}
		}
		
		private function internalMouseOverHandler(event:MouseEvent):void
		{
			if (fromControl && (fromControl['isDragging'] == false))
				fromControl.visible = true;
				
			if (toControl && (toControl['isDragging'] == false))
				toControl.visible = true;
		}
		
		private function internalMouseOutHandler(event:MouseEvent):void
		{
			if (fromControl && (fromControl['isDragging'] == false))
				fromControl.visible = false;
				
			if (toControl && (toControl['isDragging'] == false))
				toControl.visible = false;
		}
		
		private function mouseEventHandler(event:MouseEvent):void
		{
			var vedge:IVisualEdge = data as IVisualEdge;
			if ((vedge) && (vedge.vgraph))
			{
				var edgeEvent:VGEdgeEvent = new VGEdgeEvent(VGEdgeEvent.VG_EDGE_EVENT_PREFIX + event.type);
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
		
		private function fromControlMouseEventHandler(event:MouseEvent):void
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
		
		private function toControlMouseEventHandler(event:MouseEvent):void
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
				var edgeEvent:VGEdgeEvent = new VGEdgeEvent(VGEdgeEvent.VG_EDGE_EVENT_PREFIX + event.type);
				edgeEvent.originalEvent = event;
				edgeEvent.edge = vedge.edge;
				vedge.vgraph.dispatchEvent(edgeEvent);
			}
		}
		
		private function lbDragEnterHandler(event:DragEvent):void
		{
			var vedge:IVisualEdge = data as IVisualEdge;
			if ((vedge) && (vedge.vgraph))
			{
				var dropTarget:IUIComponent = IUIComponent(event.currentTarget);
				DragManager.acceptDragDrop(dropTarget);
			}
		}
		
		private function lbDragDropEventHandler(event:DragEvent):void
		{
			var vedge:IVisualEdge = data as IVisualEdge;
			if ((vedge) && (vedge.vgraph))
			{
				var edgeEvent:VGEdgeEvent = new VGEdgeEvent(VGEdgeEvent.VG_EDGE_LABEL_EVENT_PREFIX + event.type);
				edgeEvent.originalEvent = event;
				edgeEvent.edge = vedge.edge;
				vedge.vgraph.dispatchEvent(edgeEvent);
			}
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
		}
		
		private var _data:Object;
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
			var edge:IEdge = (data as IVisualEdge).edge;
			var edgeVO:Object = data.data;
			var visible:String = String(edgeVO.visible);
			var fromVisible:String = String(edge.fromNode.data.visible);
			var toVisible:String = String(edge.toNode.data.visible);
			
			
			if (TypeUtil.isFalse(visible) || TypeUtil.isFalse(fromVisible) || TypeUtil.isFalse(toVisible))	
			{

			}
			else
			{
				if (enableLabel)
				{
					label.doubleClickEnabled = true;
					var html:String = '';
					if (edgeVO is XML)
					{
						if (edgeVO.@edgeLabel)
							html = edgeVO.@edgeLabel.toString();
					}
					else
					{
						if (edgeVO.edgeLabel)
							html = edgeVO.edgeLabel;
					}
					
					label.autoSize = TextFieldAutoSize.CENTER;
					label.text = html;
					this.addChild(label);
				}
				
				if (fromControl && (this.contains(fromControl) == false))
					this.addChild(fromControl);
				
				if (toControl && (this.contains(toControl) == false))
					this.addChild(toControl);
				
				if (edgeVO is XML)
				{
					if ((edgeVO.@fromDistance != "") && (edgeVO.@fromDistance != null))
						fromDistance = Number(edgeVO.@fromDistance);
					else
						fromDistance = 0;
				
					if ((edgeVO.@toDistance != "") && (edgeVO.@toDistance != null))
						toDistance = Number(edgeVO.@toDistance);
					else
						fromDistance = 0;
				}
				else
				{
					if (edgeVO.hasOwnProperty("toDistance") && (edgeVO.toDistance != ''))
						toDistance = Number(edgeVO.toDistance);
					else
						toDistance = 0;
						
					if (edgeVO.hasOwnProperty("fromDistance") && (edgeVO.fromDistance != ''))
						fromDistance = Number(edgeVO.fromDistance);
					else
						fromDistance = 0;
				}
						
				addEventListeners();
			}
		}
		
		public function get fromControl():UIComponent
		{
			return _fromControl;
		}
		
		public function set fromControl(value:UIComponent):void
		{
			if (fromControl)
			{
				fromControl.removeEventListener(MouseEvent.CLICK, fromControlMouseEventHandler);
				fromControl.removeEventListener(MouseEvent.MOUSE_DOWN, fromControlMouseEventHandler);
				fromControl.removeEventListener(MouseEvent.MOUSE_UP, fromControlMouseEventHandler);
				fromControl.removeEventListener(MouseEvent.MOUSE_MOVE, fromControlMouseEventHandler);
				fromControl.removeEventListener(MouseEvent.MOUSE_OVER, fromControlMouseEventHandler);
				fromControl.removeEventListener(MouseEvent.MOUSE_OUT, fromControlMouseEventHandler);
				fromControl.removeEventListener(MouseEvent.DOUBLE_CLICK, fromControlMouseEventHandler);
				if (this.contains(fromControl))
					this.removeChild(fromControl);
				fromControl = null;
			}
			_fromControl = value;
			
			if (fromControl)
			{
				fromControl.visible = false;
				this.addChild(fromControl);
				fromControl.addEventListener(MouseEvent.CLICK, fromControlMouseEventHandler);
				fromControl.addEventListener(MouseEvent.MOUSE_DOWN, fromControlMouseEventHandler);
				fromControl.addEventListener(MouseEvent.MOUSE_UP, fromControlMouseEventHandler);
				fromControl.addEventListener(MouseEvent.MOUSE_MOVE, fromControlMouseEventHandler);
				fromControl.addEventListener(MouseEvent.MOUSE_OVER, fromControlMouseEventHandler);
				fromControl.addEventListener(MouseEvent.MOUSE_OUT, fromControlMouseEventHandler);
				fromControl.addEventListener(MouseEvent.DOUBLE_CLICK, fromControlMouseEventHandler);
			}
		}
		
		public function get toControl():UIComponent
		{
			return _toControl;
		}
		
		public function set toControl(value:UIComponent):void
		{
			if (toControl)
			{
				toControl.removeEventListener(MouseEvent.CLICK, toControlMouseEventHandler);
				toControl.removeEventListener(MouseEvent.MOUSE_DOWN, toControlMouseEventHandler);
				toControl.removeEventListener(MouseEvent.MOUSE_UP, toControlMouseEventHandler);
				toControl.removeEventListener(MouseEvent.MOUSE_MOVE, toControlMouseEventHandler);
				toControl.removeEventListener(MouseEvent.MOUSE_OVER, toControlMouseEventHandler);
				toControl.removeEventListener(MouseEvent.MOUSE_OUT, toControlMouseEventHandler);
				toControl.removeEventListener(MouseEvent.DOUBLE_CLICK, toControlMouseEventHandler);
				if (this.contains(toControl))
					this.removeChild(toControl);
				toControl = null;
			}
			_toControl = value;
			
			if (toControl)
			{
				toControl.visible = false;
				this.addChild(toControl);
				toControl.addEventListener(MouseEvent.CLICK, toControlMouseEventHandler);
				toControl.addEventListener(MouseEvent.MOUSE_DOWN, toControlMouseEventHandler);
				toControl.addEventListener(MouseEvent.MOUSE_UP, toControlMouseEventHandler);
				toControl.addEventListener(MouseEvent.MOUSE_MOVE, toControlMouseEventHandler);
				toControl.addEventListener(MouseEvent.MOUSE_OVER, toControlMouseEventHandler);
				toControl.addEventListener(MouseEvent.MOUSE_OUT, toControlMouseEventHandler);
				toControl.addEventListener(MouseEvent.DOUBLE_CLICK, toControlMouseEventHandler);
			}
		}
	}
}