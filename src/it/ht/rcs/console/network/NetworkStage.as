package it.ht.rcs.console.network
{
  import it.ht.rcs.console.network.model.Collector;
  import it.ht.rcs.console.network.renderers.CollectorRenderer;
  
  import mx.collections.ArrayCollection;
  
  import spark.components.Group;

  public class NetworkStage extends Group
	{
		
		private var _db:DB;
		
		private static const COLLECTORS_DISTANCE:int = 60;
		private static const VERTICAL_DISTANCE:int = 55;
    private static const IP_VERTICAL_DISTANCE:int = 65;
		private static const BOTTOM_DISTANCE:int = 30;
		
		public function NetworkStage()
    {
			super();
			layout = null;
		}
		
		private var ips:ArrayCollection;
		public function set db(db:DB):void
    {
			_db = db;
      
      removeAllElements();
      ips = new ArrayCollection();
      
      if(_db == null) return;
      
      ips = new ArrayCollection();
      
      addElement(_db);
      for each (var collector:Collector in _db.collectors)
      {
        //addElement(collector.renderer);
        var anonymizer:Collector = collector.nextHop as Collector;
        while (anonymizer != null)
        {
          //addElement(anonymizer.renderer);
          anonymizer = anonymizer.nextHop as Collector;
        }
        var ip:IPRenderer = new IPRenderer();
        ips.addItem(ip);
        addElement(ip);
      }
		}
		
		public function get db():DB
    {
			return _db;
		}
		
		override protected function measure():void
    {
      super.measure();
//      if (_db != null && _db.collectors.length > 0) {
//        measuredWidth = measuredMinWidth = (_db.collectors[0].renderer.measuredWidth * _db.collectors.length) + (COLLECTORS_DISTANCE * (_db.collectors.length-1)) + 47;
//        var maxBranch:Number = 0, branch:Number = 0, nextHop:NetworkObject;
//        for each (var coll:Collector in _db.collectors) {
//          nextHop = coll.nextHop;
//          while (nextHop != null) {
//            branch += VERTICAL_DISTANCE;
//            nextHop = nextHop.nextHop;
//          }
//          branch += VERTICAL_DISTANCE;
//          maxBranch = branch > maxBranch ? branch : maxBranch;
//        }
//        measuredHeight = maxBranch;
//            
//      }
		}
    
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
      
			super.updateDisplayList(unscaledWidth, unscaledHeight);

//      var _width:Number = unscaledWidth > measuredWidth ? unscaledWidth : measuredWidth;
//      var _height:Number = unscaledHeight > measuredHeight ? unscaledHeight : measuredHeight;
//
//      graphics.lineStyle(1, 0x000000, 1, true);
//      
//			if (_db != null) {
//			
//				_db.move(_width/2 - _db.measuredWidth/2, _height - BOTTOM_DISTANCE - _db.measuredHeight);
//				
// 				// Where to draw the first Collector?
//        if (_db.collectors.length > 0) {
//  				var offsetFromCenter:int = 0;
//          var renderer:CollectorRenderer = _db.collectors[0].renderer;
//  				if (_db.collectors.length % 2 == 0)
//  					offsetFromCenter = _width/2 - (_db.collectors.length/2 * (COLLECTORS_DISTANCE + renderer.measuredWidth)) + COLLECTORS_DISTANCE/2;
//  				else
//  					offsetFromCenter = _width/2 - (Math.floor(_db.collectors.length/2) * (COLLECTORS_DISTANCE + renderer.measuredWidth)) - renderer.measuredWidth/2;
//        }
//				// Draw collectors
//				for (var collectorIndex:int = 0; collectorIndex < _db.collectors.length; collectorIndex++) {
//					
//					var collector:Collector = _db.collectors[collectorIndex];
//					
//					var cX:int = offsetFromCenter + collectorIndex * (COLLECTORS_DISTANCE + collector.renderer.measuredWidth) + collector.renderer.measuredWidth/2;
//					var cY:int = _db.y - VERTICAL_DISTANCE;
//					collector.renderer.move(cX - collector.renderer.measuredWidth/2, cY);
//					
//					graphics.moveTo(_width/2, _height - BOTTOM_DISTANCE - _db.measuredHeight/2);
//					graphics.lineTo(cX, cY + collector.renderer.measuredHeight);
//					
//					var anonymizer:Collector = collector.nextHop as Collector;
//					while (anonymizer != null) {
//						
//						graphics.moveTo(cX , cY - VERTICAL_DISTANCE + anonymizer.renderer.measuredHeight);
//						graphics.lineTo(cX, cY);
//						
//						cY -= VERTICAL_DISTANCE;
//            anonymizer.renderer.move(cX - anonymizer.renderer.measuredWidth/2, cY);
//            
//						if (anonymizer.nextHop == null)
//							break;
//						
//            anonymizer = anonymizer.nextHop as Collector;
//						
//					} // End anonymizer
//					
//          // Draw the IPs
//          if (ips.length > 0) {
//  					var ip:IPRenderer = ips.getItemAt(collectorIndex) as IPRenderer;
//  					graphics.moveTo(cX, cY - IP_VERTICAL_DISTANCE + ip.measuredHeight);
//  					graphics.lineTo(cX, cY);
//  					ip.move(cX - ip.measuredWidth/2, cY - IP_VERTICAL_DISTANCE);
//          }
//
//				} // End collectors
//				
//			} // End db
			
		}

	}
	
}