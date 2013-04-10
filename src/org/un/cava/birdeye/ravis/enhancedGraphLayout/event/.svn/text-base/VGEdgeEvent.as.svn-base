package org.un.cava.birdeye.ravis.enhancedGraphLayout.event
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.DragEvent;
	
	import org.un.cava.birdeye.ravis.graphLayout.data.IEdge;

	/**
	 * This class defines some node events
	 */
	public class VGEdgeEvent extends Event
	{
		public static const VG_EDGE_EVENT_PREFIX:String = 'vg_edge';
		public static const VG_EDGE_CONTROL_EVENT_PREFIX:String = 'vg_control_edge';
		public static const VG_EDGE_LABEL_EVENT_PREFIX:String = 'vg_edge_label';
		
		public static const VG_EDGE_CLICK:String = VG_EDGE_EVENT_PREFIX + MouseEvent.CLICK;
		public static const VG_EDGE_MOUSE_DOWN:String = VG_EDGE_EVENT_PREFIX + MouseEvent.MOUSE_DOWN;
		public static const VG_EDGE_MOUSE_UP:String = VG_EDGE_EVENT_PREFIX + MouseEvent.MOUSE_UP;
		public static const VG_EDGE_MOUSE_MOVE:String = VG_EDGE_EVENT_PREFIX + MouseEvent.MOUSE_MOVE;
		public static const VG_EDGE_MOUSE_OVER:String = VG_EDGE_EVENT_PREFIX + MouseEvent.MOUSE_OVER;
		public static const VG_EDGE_MOUSE_OUT:String = VG_EDGE_EVENT_PREFIX + MouseEvent.MOUSE_OUT;
		public static const VG_EDGE_DOUBLE_CLICK:String = VG_EDGE_EVENT_PREFIX + MouseEvent.DOUBLE_CLICK;
		public static const VG_EDGE_DRAG_DROP:String = VG_EDGE_EVENT_PREFIX + DragEvent.DRAG_DROP;
		public static const VG_EDGE_DRAG_OVER:String = VG_EDGE_EVENT_PREFIX + DragEvent.DRAG_OVER;
		public static const VG_EDGE_DRAG_ENTER:String = VG_EDGE_EVENT_PREFIX + DragEvent.DRAG_ENTER;
		public static const VG_EDGE_DRAG_EXIT:String = VG_EDGE_EVENT_PREFIX + DragEvent.DRAG_EXIT;
		
		public static const VG_EDGE_LABEL_CLICK:String = VG_EDGE_LABEL_EVENT_PREFIX + MouseEvent.CLICK;
		public static const VG_EDGE_LABEL_MOUSE_DOWN:String = VG_EDGE_LABEL_EVENT_PREFIX + MouseEvent.MOUSE_DOWN;
		public static const VG_EDGE_LABEL_MOUSE_UP:String = VG_EDGE_LABEL_EVENT_PREFIX + MouseEvent.MOUSE_UP;
		public static const VG_EDGE_LABEL_MOUSE_MOVE:String = VG_EDGE_LABEL_EVENT_PREFIX + MouseEvent.MOUSE_MOVE;
		public static const VG_EDGE_LABEL_MOUSE_OVER:String = VG_EDGE_LABEL_EVENT_PREFIX + MouseEvent.MOUSE_OVER;
		public static const VG_EDGE_LABEL_MOUSE_OUT:String = VG_EDGE_LABEL_EVENT_PREFIX + MouseEvent.MOUSE_OUT;
		public static const VG_EDGE_LABEL_DOUBLE_CLICK:String = VG_EDGE_LABEL_EVENT_PREFIX + MouseEvent.DOUBLE_CLICK;
		public static const VG_EDGE_LABEL_DRAG_DROP:String = VG_EDGE_LABEL_EVENT_PREFIX + DragEvent.DRAG_DROP;
		
		public static const VG_EDGE_CONTROL_CLICK:String = VG_EDGE_CONTROL_EVENT_PREFIX + MouseEvent.CLICK;
		public static const VG_EDGE_CONTROL_MOUSE_DOWN:String = VG_EDGE_CONTROL_EVENT_PREFIX + MouseEvent.MOUSE_DOWN;
		public static const VG_EDGE_CONTROL_MOUSE_UP:String = VG_EDGE_CONTROL_EVENT_PREFIX + MouseEvent.MOUSE_UP;
		public static const VG_EDGE_CONTROL_MOUSE_MOVE:String = VG_EDGE_CONTROL_EVENT_PREFIX + MouseEvent.MOUSE_MOVE;
		public static const VG_EDGE_CONTROL_MOUSE_OVER:String = VG_EDGE_CONTROL_EVENT_PREFIX + MouseEvent.MOUSE_OVER;
		public static const VG_EDGE_CONTROL_MOUSE_OUT:String = VG_EDGE_CONTROL_EVENT_PREFIX + MouseEvent.MOUSE_OUT;
		public static const VG_EDGE_CONTROL_DOUBLE_CLICK:String = VG_EDGE_CONTROL_EVENT_PREFIX + MouseEvent.DOUBLE_CLICK;
		public static const VG_EDGE_CONTROL_DRAG_DROP:String = VG_EDGE_CONTROL_EVENT_PREFIX + DragEvent.DRAG_DROP;
		public static const VG_EDGE_CONTROL_END_DRAG:String = VG_EDGE_CONTROL_EVENT_PREFIX + "END_DRAG";
		
		public var edge:IEdge;
		public var originalEvent:Event;
		
		public function VGEdgeEvent(type:String, currentEdge:IEdge = null, flexEvt:Event = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			edge = currentEdge;
			originalEvent = flexEvt;
		}
		
		public override function clone():Event
		{
			var evtRet:VGEdgeEvent = new VGEdgeEvent(type, edge, originalEvent, bubbles, cancelable);
			return evtRet;
		}
	}
}