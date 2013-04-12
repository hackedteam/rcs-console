package org.un.cava.birdeye.ravis.enhancedGraphLayout.visual.nodeRenderers
{
	import flash.display.DisplayObject;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.utils.ObjectUtil;
	import mx.utils.UIDUtil;
	
	import org.un.cava.birdeye.ravis.components.renderers.RendererIconFactory;
	import org.un.cava.birdeye.ravis.enhancedGraphLayout.event.VGNodeEvent;
	import org.un.cava.birdeye.ravis.enhancedGraphLayout.ui.dataProperty.NodeProperty;
	import org.un.cava.birdeye.ravis.enhancedGraphLayout.visual.EnhancedVisualGraph;
	import org.un.cava.birdeye.ravis.enhancedGraphLayout.visual.INodeRenderer;
	import org.un.cava.birdeye.ravis.graphLayout.layout.HierarchicalLayouter;
	import org.un.cava.birdeye.ravis.graphLayout.layout.ILayoutAlgorithm;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualNode;

	public class EnhancedIconNodeRenderer extends Container implements INodeRenderer
	{
		private var size:Number = 32;
		public function EnhancedIconNodeRenderer()
		{
			super();
			this.width = this.height = size;
			this.addEventListener(FlexEvent.CREATION_COMPLETE, initComponent);
		}
		/**
		 * @inheritDoc
		 * */
		protected function initComponent(e:Event):void {
			
			this.removeEventListener(FlexEvent.CREATION_COMPLETE, initComponent);
			var img:UIComponent;
			
			if (this.data.data is XML)
			{
				img = RendererIconFactory.createIcon(this.data.data.@nodeIcon,size);
				img.toolTip = this.data.data.@desc; // needs check
			}
			else
			{
				img = RendererIconFactory.createIcon(this.data.data.nodeIcon,size - 2*this.getStyle("borderThickness"));
				img.toolTip = this.data.data.desc; // needs check
			}
			this.addChild(img);
			this.contextMenu = createContextMenu();
			addEventListeners();
		}
		
		public override function set data(value:Object):void
		{
			var vo:Object = value.data;
			var img:UIComponent;
			if (vo is XML)
			{
				img = RendererIconFactory.createIcon(vo.@nodeIcon,size);
				img.toolTip = vo.@desc; // needs check
				this.setStyle('backgroundColor', vo.@nodeColor);
			}
			else
			{
				img = RendererIconFactory.createIcon(vo.nodeIcon,size - 2*this.getStyle("borderThickness"));
				img.toolTip = vo.desc; // needs check
				this.setStyle('backgroundColor', vo.nodeColor); 
			}
			this.addChild(img); 
			
			if (this.data != value)
			{
				removeEventListeners();
				addEventListeners();
			}
			super.data = value;
		}
		
		protected function createContextMenu():ContextMenu 
		{
			var contextMenu:ContextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();
			
			var editNode:ContextMenuItem = new ContextMenuItem("Edit Node");
			editNode.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, editNodeItemClick);
			contextMenu.customItems.push(editNode);
			
			var newChild:ContextMenuItem = new ContextMenuItem("New Child");
			newChild.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, newChildItemClick);
			contextMenu.customItems.push(newChild);
			
			var delNode:ContextMenuItem = new ContextMenuItem("Delete Node");
			delNode.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, deleteNodeItemClick);
			contextMenu.customItems.push(delNode);
			
			var delTree:ContextMenuItem = new ContextMenuItem("Delete Sub Tree");
			delTree.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, deleteTreeItemClick);
			contextMenu.customItems.push(delTree);
			
			var delStationChildren:ContextMenuItem = new ContextMenuItem("Delete Child");
			delStationChildren.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, deleteNodeChildrenItemClick);
			contextMenu.customItems.push(delStationChildren);
			
			var delNodeAndRebindChild:ContextMenuItem = new ContextMenuItem("Delete Node and Rebind Child");
			delNodeAndRebindChild.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, deleteNodeAndRebindChildItemClick);
			contextMenu.customItems.push(delNodeAndRebindChild);
			
			return contextMenu;	
		}
		
		private function editNodeItemClick(event:ContextMenuEvent):void
		{
			var popUp:NodeProperty = PopUpManager.createPopUp(root, NodeProperty, true) as NodeProperty;
			PopUpManager.centerPopUp(popUp);
			popUp.data = IVisualNode(this.data).node;
			
		}
		
		private function newChildItemClick(event:ContextMenuEvent):void
		{
			var childData:Object = ObjectUtil.copy(IVisualNode(this.data).data);
			childData.id = UIDUtil.createUID();
			childData.desc = 'This is new node';
			EnhancedVisualGraph(IVisualNode(this.data).vgraph).addVNodeAsChild(childData.id, childData, IVisualNode(this.data).node);
		}
		
		private function deleteTreeItemClick(event:ContextMenuEvent):void
		{
			if (IVisualNode(this.data) == IVisualNode(this.data).vgraph.currentRootVNode)
			{
				Alert.show("Cannot delete root node");
				return;
			}
			EnhancedVisualGraph(IVisualNode(this.data).vgraph).removeSubTree(IVisualNode(this.data).node);
		}
		
		private function deleteNodeChildrenItemClick(event:ContextMenuEvent):void
		{
			EnhancedVisualGraph(IVisualNode(this.data).vgraph).removeNodeChildren(IVisualNode(this.data).node);
		}
		
		private function deleteNodeItemClick(event:ContextMenuEvent):void
		{
			if (IVisualNode(this.data) == IVisualNode(this.data).vgraph.currentRootVNode)
			{
				Alert.show("Cannot delete root node");
				return;
			}
			EnhancedVisualGraph(IVisualNode(this.data).vgraph).removeNodeWithOption(IVisualNode(this.data).node, false);
		}
		
		private function deleteNodeAndRebindChildItemClick(event:ContextMenuEvent):void
		{
			if (IVisualNode(this.data) == IVisualNode(this.data).vgraph.currentRootVNode)
			{
				Alert.show("Cannot delete root node");
				return;
			}
			EnhancedVisualGraph(IVisualNode(this.data).vgraph).removeNodeWithOption(IVisualNode(this.data).node, true);
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
		}
		
		private function mouseEventHandler(event:MouseEvent):void
		{
			var vnode:IVisualNode = data as IVisualNode;
			if ((vnode) && (vnode.vgraph))
			{
				var nodeEvent:VGNodeEvent = new VGNodeEvent(VGNodeEvent.VG_NODE_EVENT_PREFIX + event.type);
				nodeEvent.originalEvent = event;
				nodeEvent.node = vnode.node;
				vnode.vgraph.dispatchEvent(nodeEvent);
			}
		}
			
		public function labelCoordinates(label:UIComponent):Point
		{
			if (this.data is IVisualNode)
			{
				var hInside:Boolean = true;
				var vInside:Boolean = false;
				var hAlign:String = "center"; //left, right, center
				var vAlign:String = "bottom"; //top, bottom, middle
			
	
				var labelx:Number;
				var labely:Number;
				var currentLayouter:ILayoutAlgorithm = IVisualNode(this.data).vgraph.layouter;
				
				if (currentLayouter is HierarchicalLayouter)
				{
					switch ((currentLayouter as HierarchicalLayouter).orientation)
					{
						case HierarchicalLayouter.ORIENT_BOTTOM_UP:
						{
							hInside = true;
							vInside = false;
							hAlign = "center";
							vAlign = "top";
							break;
						}
						
						case HierarchicalLayouter.ORIENT_TOP_DOWN:
						{
							hInside = true;
							vInside = false;
							hAlign = "center";
							vAlign = "bottom";
							break;
						}
						
						case HierarchicalLayouter.ORIENT_LEFT_RIGHT:
						{
							hInside = false;
							vInside = true;
							hAlign = "right";
							vAlign = "middle";
							break;
						}
						
						case HierarchicalLayouter.ORIENT_RIGHT_LEFT:
						{
							hInside = false;
							vInside = true;
							hAlign = "left";
							vAlign = "middle";
							break;
						}
					}
				}
				switch (hAlign)
				{
					case "left":
					{
						labelx = IVisualNode(this.data).view.x;
						if (hInside == false) labelx -= label.width;
						break;
					}
					case "right":
					{
						labelx = IVisualNode(this.data).view.x + IVisualNode(this.data).view.width;
						if (hInside == true) labelx -= label.width;
						break;
					}
					case "center":
					{
						labelx = IVisualNode(this.data).view.x + IVisualNode(this.data).view.width/2 - label.width/2;
						break;
					}
					default:
						labelx = IVisualNode(this.data).viewCenter.x;
				}
						
				switch (vAlign)
				{
					case "top":
					{
						labely = IVisualNode(this.data).view.y;
						if (vInside == false) labely -= label.height;
						break;
					}
					case "bottom":
					{
						labely = IVisualNode(this.data).view.y + IVisualNode(this.data).view.height;
						if (vInside == true) labely -= label.height;
						break;
					}
					case "middle":
					{
						labely = IVisualNode(this.data).view.y + IVisualNode(this.data).view.height/2 - label.height/2;
						break;
					}
					default:
						labely = IVisualNode(this.data).viewCenter.y;
				}
				return new Point(labelx, labely);
			}
			else 
				return new Point(this.x + this.width/2, this.y + this.height/2)
					
		}
	}
}