package it.ht.rcs.console.system.view.frontend
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import it.ht.rcs.console.events.NodeEvent;
	import it.ht.rcs.console.network.model.Collector;
	import it.ht.rcs.console.system.view.frontend.renderers.CollectorRenderer;
	import it.ht.rcs.console.system.view.frontend.renderers.DBRenderer;
	import it.ht.rcs.console.system.view.frontend.renderers.IPRenderer;
	
	import mx.collections.ArrayCollection;
	
	import spark.components.Group;

	[Event(name="nodeChanged", type="it.ht.rcs.console.events.NodeEvent")]
	public class FrontendGraph extends Group
	{

		private var _db:DBRenderer;

		private static const COLLECTORS_DISTANCE:int  = 60;
		private static const VERTICAL_DISTANCE:int    = 55;
		private static const IP_VERTICAL_DISTANCE:int = 65;
		private static const BOTTOM_DISTANCE:int      = 15;

		public function FrontendGraph()
		{
			super();
			layout = null;
			addEventListener(NodeEvent.CHANGED, onNodeEvent);
			addEventListener(NodeEvent.ADDED, onNodeEvent);
			addEventListener(NodeEvent.REMOVED, onNodeEvent);
      addEventListener(MouseEvent.CLICK, onClick);
		}
    
    public function set rootNode(root:DBRenderer):void
    {
      _db = root;
      rebuildGraph();
    }
    
    private function onClick(event:MouseEvent):void
    {
      for each (var cr:CollectorRenderer in _db.collectors) {
        cr.selectNode(false);
        while (cr.nextHop != null) {
          cr = cr.nextHop;
          cr.selectNode(false);
        }
      }
      
      var node:CollectorRenderer;
      if (event.target is CollectorRenderer)
        node = event.target as CollectorRenderer;
      else if (event.target.parent is CollectorRenderer)
        node = event.target.parent as CollectorRenderer;
      else return;

      node.selectNode(true);
      trace('prev: ' + (node.prevHop == null ? 'null' : node.prevHop.collector._id) + ', next: ' + (node.nextHop == null ? 'null' : node.nextHop.collector._id));
      (this.parentDocument as Frontend).collectors.selectedItem = node.collector;
    }

		private function onNodeEvent(e:Event):void
		{
			if (!(e is NodeEvent) || e.target == this)
				return;

			trace('NetworkGraph: NodeEvent');
			rebuildGraph();
		}

		// List of IP renderer
		private var ips:ArrayCollection;
    private var map:Dictionary;
    
    public function selectNode(c:Collector):void
    {
      for each (var cr:CollectorRenderer in _db.collectors) {
        cr.selectNode(false);
        while (cr.nextHop != null) {
          cr = cr.nextHop;
          cr.selectNode(false);
        }
      }
      
      var node:CollectorRenderer = map[c] as CollectorRenderer;
      if (!node) return;
      
      node.selectNode(true);
    }

		public function rebuildGraph():void
		{

			removeAllElements();
			ips = new ArrayCollection();
      map = new Dictionary();

			if (_db == null)
				return;

			addElement(_db);
			for each (var cr:CollectorRenderer in _db.collectors)
			{
				addElement(cr);
        map[cr.collector] = cr;
				var anonymizer:CollectorRenderer = cr.nextHop;
				var lastIP:String = cr.collector.address;
				while (anonymizer != null)
				{
					addElement(anonymizer);
          map[anonymizer.collector] = anonymizer;
					lastIP = anonymizer.collector.address;
					anonymizer = anonymizer.nextHop;
				}
				var ip:IPRenderer = new IPRenderer();
				ip.text = lastIP;
				ips.addItem(ip);
				addElement(ip);
			}

			invalidateSize();
			invalidateDisplayList();

		}
    
		override protected function measure():void
		{
			super.measure();

			if (_db != null && _db.collectors.length > 0)
			{

				measuredWidth = measuredMinWidth = (_db.collectors[0].measuredWidth * _db.collectors.length) + (COLLECTORS_DISTANCE * (_db.collectors.length - 1));

				var maxBranch:Number = 0, branch:Number = 0, nextHop:CollectorRenderer;
				for each (var coll:CollectorRenderer in _db.collectors)
				{
					branch = BOTTOM_DISTANCE + _db.height + VERTICAL_DISTANCE;
					nextHop = coll.nextHop;
					while (nextHop != null)
					{
						branch += VERTICAL_DISTANCE;
						nextHop = nextHop.nextHop;
					}
					branch += IP_VERTICAL_DISTANCE;
					maxBranch = branch > maxBranch ? branch : maxBranch;
				}
				measuredHeight = measuredMinHeight = maxBranch;

			}
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{

			super.updateDisplayList(unscaledWidth, unscaledHeight);

			var _width:Number = unscaledWidth > measuredWidth ? unscaledWidth : measuredWidth;
			var _height:Number = unscaledHeight > measuredHeight ? unscaledHeight : measuredHeight;

			graphics.lineStyle(1, 0x999999, 1, true);

			if (_db != null)
			{

				_db.move(_width / 2 - _db.measuredWidth / 2, _height - BOTTOM_DISTANCE - _db.measuredHeight);

				// Where to draw the first collector?
				if (_db.collectors.length > 0)
				{
					var offsetFromCenter:int = 0;
					var renderer:CollectorRenderer = _db.collectors[0];
					if (_db.collectors.length % 2 == 0)
						offsetFromCenter = _width / 2 - (_db.collectors.length / 2 * (COLLECTORS_DISTANCE + renderer.measuredWidth)) + COLLECTORS_DISTANCE / 2;
					else
						offsetFromCenter = _width / 2 - (Math.floor(_db.collectors.length / 2) * (COLLECTORS_DISTANCE + renderer.measuredWidth)) - renderer.measuredWidth / 2;
				}
				// Draw collectors
				for (var collectorIndex:int = 0; collectorIndex < _db.collectors.length; collectorIndex++)
				{

					var collector:CollectorRenderer = _db.collectors[collectorIndex];

					var cX:int = offsetFromCenter + collectorIndex * (COLLECTORS_DISTANCE + collector.measuredWidth) + collector.measuredWidth / 2;
					var cY:int = _db.y - VERTICAL_DISTANCE;
					collector.move(cX - collector.measuredWidth / 2, cY);

					graphics.moveTo(_width / 2, _height - BOTTOM_DISTANCE - _db.measuredHeight / 2);
					graphics.lineTo(cX, cY + COLLECTORS_DISTANCE + BOTTOM_DISTANCE);
          graphics.lineTo(cX, cY + collector.measuredHeight);

					var anonymizer:CollectorRenderer = collector.nextHop;
					while (anonymizer != null)
					{

						graphics.moveTo(cX, cY - VERTICAL_DISTANCE + anonymizer.measuredHeight);
						graphics.lineTo(cX, cY);

						cY -= VERTICAL_DISTANCE;
						anonymizer.move(cX - anonymizer.measuredWidth / 2, cY);

						if (anonymizer.nextHop == null)
							break;

						anonymizer = anonymizer.nextHop;

					} // End anonymizer

					// Draw the IPs
					if (ips.length > 0)
					{
						var ip:IPRenderer = ips.getItemAt(collectorIndex) as IPRenderer;
						graphics.moveTo(cX, cY - IP_VERTICAL_DISTANCE + ip.measuredHeight);
						graphics.lineTo(cX, cY);
						ip.move(cX - ip.measuredWidth / 2, cY - IP_VERTICAL_DISTANCE);
					}

				} // End collectors

			} // End db

		}

	}

}