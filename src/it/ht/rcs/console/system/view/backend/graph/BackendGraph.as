package it.ht.rcs.console.system.view.backend.graph
{
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import it.ht.rcs.console.system.view.backend.graph.renderers.DBRenderer;
	import it.ht.rcs.console.system.view.backend.graph.renderers.ShardRenderer;
	
	import mx.collections.ArrayCollection;
	
	import spark.components.Group;

	public class BackendGraph extends Group
	{
    
		private var _db:DBRenderer;

		private static const SHARDS_DISTANCE:int   = 70;
		private static const VERTICAL_DISTANCE:int = 40;
		private static const TOP_DISTANCE:int      = 20;

		public function BackendGraph()
		{
			super();
			layout = null;
      addEventListener(MouseEvent.CLICK, onClick);
		}
    
    public function set rootNode(root:DBRenderer):void
    {
      _db = root;
      rebuildGraph();
    }
    
    private function onClick(event:MouseEvent):void
    {
    }
    
		// List of IP renderer
		private var ips:ArrayCollection;
    private var map:Dictionary;
    
    public function selectNode():void
    {
//      for each (var cr:CollectorRenderer in _db.collectors) {
//        cr.selectNode(false);
//        while (cr.nextHop != null) {
//          cr = cr.nextHop;
//          cr.selectNode(false);
//        }
//      }
//      
//      var node:CollectorRenderer = map[c] as CollectorRenderer;
//      if (!node) return;
//      
//      node.selectNode(true);
    }
    
		public function rebuildGraph():void
		{

			removeAllElements();
			ips = new ArrayCollection();
      map = new Dictionary();

			if (_db == null)
				return;

			addElement(_db);
			for each (var sr:ShardRenderer in _db.shards)
				addElement(sr);

			invalidateSize();
			invalidateDisplayList();

		}
    
		override protected function measure():void
		{
			super.measure();

			if (_db != null && _db.shards.length > 0)
			{

				measuredWidth = measuredMinWidth = (_db.shards[0].measuredWidth * _db.shards.length) + (SHARDS_DISTANCE * (_db.shards.length - 1));

				var maxBranch:Number = 0, branch:Number = 0;
				for each (var shard:ShardRenderer in _db.shards)
				{
					branch = TOP_DISTANCE + _db.height + VERTICAL_DISTANCE;
//					while (nextHop != null)
//					{
//						branch += VERTICAL_DISTANCE;
//						nextHop = nextHop.nextHop;
//					}
//					maxBranch = branch > maxBranch ? branch : maxBranch;
				}
				measuredHeight = measuredMinHeight = maxBranch;

			}
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{

			super.updateDisplayList(unscaledWidth, unscaledHeight);

			var _width:Number = unscaledWidth > measuredWidth ? unscaledWidth : measuredWidth;
			var _height:Number = unscaledHeight > measuredHeight ? unscaledHeight : measuredHeight;

			graphics.lineStyle(1, 0x222222, 1, true);

			if (_db != null)
			{

				_db.move(_width / 2 - _db.measuredWidth / 2, TOP_DISTANCE);

				// Where to draw the first shard?
				if (_db.shards.length > 0)
				{
					var offsetFromCenter:int = 0;
					var renderer:ShardRenderer = _db.shards[0];
					if (_db.shards.length % 2 == 0)
						offsetFromCenter = _width / 2 - (_db.shards.length / 2 * (SHARDS_DISTANCE + renderer.measuredWidth)) + SHARDS_DISTANCE / 2;
					else
						offsetFromCenter = _width / 2 - (Math.floor(_db.shards.length / 2) * (SHARDS_DISTANCE + renderer.measuredWidth)) - renderer.measuredWidth / 2;
				}
				// Draw shards
				for (var collectorIndex:int = 0; collectorIndex < _db.shards.length; collectorIndex++)
				{

					var shard:ShardRenderer = _db.shards[collectorIndex];

					var cX:int = offsetFromCenter + collectorIndex * (SHARDS_DISTANCE + shard.measuredWidth) + shard.measuredWidth / 2;
					var cY:int = _db.y + _db.measuredHeight + VERTICAL_DISTANCE;
          shard.move(cX - shard.measuredWidth / 2, cY);

					graphics.moveTo(_width / 2, TOP_DISTANCE + _db.measuredHeight / 2);
					graphics.lineTo(cX, cY);

				} // End collectors

			} // End db

		}

	}

}