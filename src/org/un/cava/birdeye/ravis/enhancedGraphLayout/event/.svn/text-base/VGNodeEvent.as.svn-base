package org.un.cava.birdeye.ravis.enhancedGraphLayout.event
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.DragEvent;
	
	import org.un.cava.birdeye.ravis.graphLayout.data.INode;

	/**
	 * This class defines some edge events
	 */
	public class VGNodeEvent extends Event
	{
		public static const VG_NODE_EVENT_PREFIX:String = 'vg_node';
		public static const VG_NODE_LABEL_EVENT_PREFIX:String = 'vg_node_label';
		
		public static const VG_NODE_CLICK:String = VG_NODE_EVENT_PREFIX + MouseEvent.CLICK;
		public static const VG_NODE_MOUSE_DOWN:String = VG_NODE_EVENT_PREFIX + MouseEvent.MOUSE_DOWN;
		public static const VG_NODE_MOUSE_UP:String = VG_NODE_EVENT_PREFIX + MouseEvent.MOUSE_UP;
		public static const VG_NODE_MOUSE_MOVE:String = VG_NODE_EVENT_PREFIX + MouseEvent.MOUSE_MOVE;
		public static const VG_NODE_MOUSE_OVER:String = VG_NODE_EVENT_PREFIX + MouseEvent.MOUSE_OVER;
		public static const VG_NODE_MOUSE_OUT:String = VG_NODE_EVENT_PREFIX + MouseEvent.MOUSE_OUT;
		public static const VG_NODE_DOUBLE_CLICK:String = VG_NODE_EVENT_PREFIX + MouseEvent.DOUBLE_CLICK;
		public static const VG_NODE_DRAG_DROP:String = VG_NODE_EVENT_PREFIX + DragEvent.DRAG_DROP;
		public static const VG_NODE_END_DRAG:String = VG_NODE_EVENT_PREFIX + "END_DRAG";
		
		public static const VG_NODE_LABEL_CLICK:String = VG_NODE_LABEL_EVENT_PREFIX + MouseEvent.CLICK;
		public static const VG_NODE_LABEL_MOUSE_DOWN:String = VG_NODE_LABEL_EVENT_PREFIX + MouseEvent.MOUSE_DOWN;
		public static const VG_NODE_LABEL_MOUSE_UP:String = VG_NODE_LABEL_EVENT_PREFIX + MouseEvent.MOUSE_UP;
		public static const VG_NODE_LABEL_MOUSE_MOVE:String = VG_NODE_LABEL_EVENT_PREFIX + MouseEvent.MOUSE_MOVE;
		public static const VG_NODE_LABEL_MOUSE_OVER:String = VG_NODE_LABEL_EVENT_PREFIX + MouseEvent.MOUSE_OVER;
		public static const VG_NODE_LABEL_MOUSE_OUT:String = VG_NODE_LABEL_EVENT_PREFIX + MouseEvent.MOUSE_OUT;
		public static const VG_NODE_LABEL_DOUBLE_CLICK:String = VG_NODE_LABEL_EVENT_PREFIX + MouseEvent.DOUBLE_CLICK;
		
		
		public var node:INode;
		public var originalEvent:Event;
		
		/**
		 * Init function
		 */
		 
		public function VGNodeEvent(type:String, currentNode:INode = null, flexEvt:Event = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			node = currentNode;
			originalEvent = flexEvt;
		}
		
		public override function clone():Event
		{
			var evtRet:VGNodeEvent = new VGNodeEvent(type, node, originalEvent, bubbles, cancelable);
			return evtRet;		
		}
	}
}