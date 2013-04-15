package org.un.cava.birdeye.ravis.graphLayout.visual.events
{
	import flash.events.Event;
	
	import org.un.cava.birdeye.ravis.graphLayout.data.INode;

	public class VisualNodeEvent extends Event
	{
		public static const CLICK:String = "nodeClick";
        public static const DOUBLE_CLICK:String = "nodeDoubleClick";
		public static const DRAG_START:String = "nodeDragStart";
		public static const DRAG_END:String = "nodeDragEnd";
		
		public var node:INode;
        public var ctrlKey:Boolean;
		
		public function VisualNodeEvent(type:String, node:INode, ctrlKey:Boolean, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.node = node;
            this.ctrlKey = ctrlKey;
		}
		
		public override function clone():Event
		{
			return new VisualNodeEvent(type,node,ctrlKey, bubbles,cancelable);
		}
		
	}
}