package it.ht.rcs.console.operations.main.views.configuration.renderers
{
  import flash.events.MouseEvent;
  
  import it.ht.rcs.console.events.NodeEvent;
  import it.ht.rcs.console.network.model.Collector;
  import it.ht.rcs.console.system.view.frontend.CollectorListRenderer;
  
  import mx.binding.utils.BindingUtils;
  import mx.core.DragSource;
  import mx.core.UIComponent;
  import mx.events.DragEvent;
  import mx.managers.DragManager;
  
  import spark.components.Label;

  public class EventRenderer extends Node
	{
    
    private static const WIDTH:Number  = 120;
    private static const HEIGHT:Number = 32;
    
    private static const NORMAL_COLOR:Number   = 0xbbbbbb;
    private static const SELECTED_COLOR:Number = 0x8888bb;
    private static const DRAG_COLOR:Number     = 0x5555bb;
	  
		public var event:Object;
		
		private var textLabel:Label;
		
		public function EventRenderer(event:Object)
		{
			super();
			
			this.event = event;
      
			setStyle('backgroundColor', NORMAL_COLOR);
			
		}
		
    override protected function createChildren():void
    {
			super.createChildren();

      if (textLabel == null)
      {
  			textLabel = new Label();
        BindingUtils.bindProperty(textLabel, 'text', event, 'name');
  			textLabel.setStyle('fontSize', 12);
        textLabel.setStyle('textAlign', 'center');
        textLabel.width = WIDTH - 20;
        textLabel.maxDisplayedLines = 1;
  			addElement(textLabel);
      }
		}
		
		override protected function measure():void
    {
			super.measure();
			
			width = measuredWidth = WIDTH;
			height = measuredHeight = HEIGHT;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			graphics.beginFill(getStyle('backgroundColor'));
			graphics.drawRoundRect(0, 0, measuredWidth, measuredHeight, 20, 20);
			graphics.endFill();
		}
		
	}
	
}