package it.ht.rcs.console.system.view.frontend.renderers
{
  import it.ht.rcs.console.network.model.Collector;
  
  import mx.binding.utils.BindingUtils;
  
  import spark.components.BorderContainer;
  import spark.components.Label;

  public class IPRenderer extends NetworkObject
	{
    
    private static const WIDTH:Number  = 130; // 5*2 (padding) + 120 (width of container)
    private static const HEIGHT:Number = 40; // 5*2 (padding) + 30 (height of container)
	
    public var collector:Collector;
    
    private var container:BorderContainer;
		private var textLabel:Label;
    
    public function IPRenderer(collector:Collector)
    {
      super();
      this.width = WIDTH;
      this.height = HEIGHT;
      
      this.collector = collector;
    }
    
		override protected function createChildren():void
    {
			super.createChildren();
			
      if (container == null)
      {
        container = new BorderContainer();
        container.width = 120;
        container.height = 30;
        container.setStyle('borderColor', 0xdddddd);
        container.setStyle('cornerRadius', 10);

        textLabel = new Label();
        BindingUtils.bindProperty(textLabel, 'text', collector, 'address');
        textLabel.setStyle('textAlign', 'center');
        textLabel.setStyle('verticalAlign', 'middle');
        textLabel.horizontalCenter = 0;
        textLabel.width = 100;
        textLabel.height = 30;
        textLabel.maxDisplayedLines = 1;
			  container.addElement(textLabel);
        
        addElement(container);
      }
		}
		
	}
	
}