package it.ht.rcs.console.system.view.frontend.graph.renderers
{
  import flash.display.BitmapData;
  
  import it.ht.rcs.console.system.view.frontend.graph.FrontendGraph;
  
  import mx.core.UIComponent;
  
  import spark.components.Group;
  import spark.components.Image;
  import spark.layouts.VerticalLayout;
	
	public class NetworkObject extends Group
	{
		
    protected var graph:FrontendGraph;
    
		public function NetworkObject()
		{
      super();
			var layout:VerticalLayout = new VerticalLayout();
			layout.horizontalAlign = 'center';
			layout.verticalAlign = 'top';
			layout.paddingTop = 5;
      layout.paddingBottom = 5;
      layout.paddingLeft = 5;
      layout.paddingRight = 5;
      layout.gap = 6;
			this.layout = layout;
		}
		
		public function getProxy(proxy:UIComponent):Image
    {
			var bitmapData:BitmapData = new BitmapData(proxy.width, proxy.height, true, 0);
			bitmapData.draw(proxy);
			var image:Image = new Image();
			image.source = bitmapData;
			return image;
		}
		
	}
	
}