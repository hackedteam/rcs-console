package it.ht.rcs.console.network
{
  import it.ht.rcs.console.network.model.Anonymizer;
  import it.ht.rcs.console.network.model.Collector;
  import it.ht.rcs.console.network.model.DB;
  import it.ht.rcs.console.network.renderers.IPRenderer;
  
  import mx.collections.ArrayCollection;
  
  import spark.components.Group;

  public class Stage extends Group
	{
		
		private var _db:DB;
		
		private static const COLLECTORS_DISTANCE:int = 200;
		private static const VERTICAL_DISTANCE:int = 80;
		private static const BOTTOM_DISTANCE:int = 50;
		
		public function Stage()
    {
			super();
			
			layout = null;
		}
		
		private var ips:ArrayCollection;
		public function set db(db:DB):void
    {
			_db = db;
			
			ips = new ArrayCollection();
			
			removeAllElements();
			addElement(_db.renderer);
			for each (var collector:Collector in _db.collectors)
      {
				addElement(collector.renderer);
				var anonymizer:Anonymizer = collector.nextHop as Anonymizer;
				while (anonymizer != null)
        {
					addElement(anonymizer.renderer);
					anonymizer = anonymizer.nextHop as Anonymizer;
				}
				var ip:IPRenderer = new IPRenderer();
				ips.addItem(ip);
				addElement(ip);
			}
      
			this.invalidateDisplayList();
		}
		
		public function get db():DB
    {
			return _db;
		}
		
		override protected function createChildren():void
    {
			super.createChildren();
		}
		
		override protected function measure():void
    {
      measuredHeight = 1000;
      super.measure();
		}
    
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
      
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			graphics.lineStyle(1, 0x000000, 1, true);
//	  graphics.moveTo(width/2, 0);
//		graphics.lineTo(width/2, height);
			
			if (_db != null) {
			
				_db.renderer.move(width/2 - _db.renderer.measuredWidth/2, height - BOTTOM_DISTANCE - _db.renderer.measuredHeight/2);
				
				
				// Where to draw the first Collector?
				var offsetFromCenter:int = 0;
				if (_db.collectors.length % 2 == 0)
					offsetFromCenter = width/2 - (COLLECTORS_DISTANCE * _db.collectors.length/2) + COLLECTORS_DISTANCE/2;
				else
					offsetFromCenter = width/2 - (COLLECTORS_DISTANCE * Math.floor(_db.collectors.length/2));

				// Draw collectors
				for (var collectorIndex:int = 0; collectorIndex < _db.collectors.length; collectorIndex++) {
					
					var collector:Collector = _db.collectors[collectorIndex];
					
					var cX:int = offsetFromCenter + collectorIndex * COLLECTORS_DISTANCE;
					var cY:int = _db.renderer.y - VERTICAL_DISTANCE;
					collector.renderer.move(cX - collector.renderer.measuredWidth/2, cY);
					
					graphics.moveTo(width/2, height - BOTTOM_DISTANCE - _db.renderer.measuredHeight/2);
					graphics.lineTo(cX, cY + collector.renderer.measuredHeight);
					
					var anonymizer:Anonymizer = collector.nextHop as Anonymizer;
					while (anonymizer != null) {
						
						graphics.moveTo(cX, cY - VERTICAL_DISTANCE + anonymizer.renderer.measuredHeight);
						graphics.lineTo(cX, cY);
						
						cY -= VERTICAL_DISTANCE;
            anonymizer.renderer.move(cX - anonymizer.renderer.measuredWidth/2, cY);
						
						if (anonymizer.nextHop == null)
							break;
						
            anonymizer = anonymizer.nextHop as Anonymizer;
						
					} // End anonymizer
					
          // Draw the IPs
					var ip:IPRenderer = ips.getItemAt(collectorIndex) as IPRenderer;
					graphics.moveTo(cX, cY - VERTICAL_DISTANCE + ip.measuredHeight);
					graphics.lineTo(cX, cY);
					ip.move(cX - ip.measuredWidth/2, cY - VERTICAL_DISTANCE);

				} // End collectors
				
			} // End db
			
		}

	}
	
}