package org.un.cava.birdeye.ravis.enhancedGraphLayout.visual.nodeRenderers
{
	import flash.events.MouseEvent;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mx.core.IDataRenderer;
	import mx.core.IFlexModuleFactory;
	import mx.core.IFontContextComponent;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	import org.un.cava.birdeye.ravis.enhancedGraphLayout.event.VGNodeEvent;
	import org.un.cava.birdeye.ravis.graphLayout.data.INode;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualNode;
	import org.un.cava.birdeye.ravis.utils.TypeUtil;
	
	use namespace mx_internal;
	/**
	 * This _image displays the graph node renderers as
	 * primitive icon or as embedded image
	 * */
	public class NodeLabelRenderer extends UIComponent implements IDataRenderer, IFontContextComponent
	{
		public var text:TextField = new TextField;
		public function NodeLabelRenderer()
		{
			this.styleName = "NodeLabelRenderer";
			this.doubleClickEnabled = true;
			text.doubleClickEnabled = true;
		}
		
		/**
	     *  @inheritDoc 
	     */
	    public function get fontContext():IFlexModuleFactory
	    {
	        return moduleFactory;
	    }
	
	    /**
	     *  @private
	     */
	    public function set fontContext(moduleFactory:IFlexModuleFactory):void
	    {
	        this.moduleFactory = moduleFactory;
	    }

	    //----------------------------------
	    //  styleSheet
	    //----------------------------------
	
	    /**
	     *  @private
	     */
	    mx_internal function get styleSheet():StyleSheet
	    {
	        return text.styleSheet;
	    }
	
	    /**
	     *  @private
	     */
	    mx_internal function set styleSheet(value:StyleSheet):void
	    {
	        text.styleSheet = value;
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
				var nodeEvent:VGNodeEvent = new VGNodeEvent(VGNodeEvent.VG_NODE_LABEL_EVENT_PREFIX + event.type);
				nodeEvent.originalEvent = event;
				nodeEvent.node = vnode.node;
				vnode.vgraph.dispatchEvent(nodeEvent);
			}
		}
		
		private var _data:Object
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
			var node:INode = (data as IVisualNode).node;
			var visible:String = node.data.visible;
			
			if (TypeUtil.isFalse(visible))	
			{

			}
			else
			{
				var nodeVO:Object = data.data;
				if (nodeVO is XML)
				{
					text.autoSize = TextFieldAutoSize.LEFT;
					text.multiline = true;
					this.addChild(text);
					if (nodeVO.@name)
					{
						text.text = nodeVO.@name.toString();
						this.width = this.text.textWidth;
						this.height = this.text.textHeight;
					}
				}
				else
				{
					if (nodeVO.hasOwnProperty('name') && (nodeVO.name != null))
					{
						text.autoSize = TextFieldAutoSize.LEFT;
						text.multiline = true;
						this.addChild(text);
						var txt:String = '' + nodeVO.name;
						text.text = txt;
						this.width = this.text.textWidth;
						this.height = this.text.textHeight;
					}
				}
				//This is a cheat to layout initialize component
				
				//this.width = this.textWidth;
				//this.height = this.textHeight;
				addEventListeners();
			}
		}
	}
}