package it.ht.rcs.console.network.view.renderers
{
  import flash.display.BitmapData;
  
  import mx.core.UIComponent;
  
  import spark.components.Group;
  import spark.components.Image;
  import spark.layouts.HorizontalLayout;
	
	public class NetworkObject extends Group
	{
		
		public function NetworkObject()
		{
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.horizontalAlign = 'center';
			layout.verticalAlign = 'middle';
			layout.paddingTop = 2;
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