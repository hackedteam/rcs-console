package it.ht.rcs.console.system.view.frontend.graph.renderers
{
  import spark.primitives.BitmapImage;

  public class DBRenderer extends NetworkObject
	{
    
    private static const WIDTH:Number  = 60; // 5*2 padding + 50 (width of icon)
    private static const HEIGHT:Number = 60; // 5*2 padding + 50 (height of icon)
    
    public var collectors:Vector.<CollectorRenderer>;
    
    [Embed(source='/img/NEW/rcs_icona.png')]
    private const rcsIcon:Class;
    
    private var icon:BitmapImage;
    
    public function DBRenderer()
    {
      super();
      this.width = WIDTH;
      this.height = HEIGHT;
    }
    
    override protected function createChildren():void
    {
      super.createChildren();
      
      if (icon == null)
      {
        icon = new BitmapImage();
        icon.horizontalCenter = icon.verticalCenter = 0;
        icon.source = rcsIcon;
        addElement(icon);
      }
    }

  }
  
}