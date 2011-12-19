package it.ht.rcs.console.operations.view.configuration.renderers
{
  import flash.geom.Point;
  
  import mx.binding.utils.BindingUtils;
  
  import spark.components.Group;
  import spark.components.Label;

  public class ActionRenderer extends Group implements Linkable
	{
    private static const WIDTH:Number = 120;
    private static const HEIGHT:Number = 50;
    
    private static const NORMAL_COLOR:Number   = 0xbbbbbb;
    private static const SELECTED_COLOR:Number = 0x8888bb;
    private var backgroundColor:uint = NORMAL_COLOR;
	  
		public var action:Object;
		
		private var textLabel:Label;
    
    private var inBound:ConnectionLine;
    private var outBound:ConnectionLine;
    public function getInBound():ConnectionLine { return inBound; }
    public function setInBound(conn:ConnectionLine):void { inBound = conn; }
    public function getOutBound():ConnectionLine { return outBound; }
    public function setOutBound(conn:ConnectionLine):void { outBound = conn; }
		
		public function ActionRenderer(action:Object)
		{
			super();
      layout = null;
      width = WIDTH;
      height = HEIGHT;
      
			this.action = action;
		}
    
    override protected function createChildren():void
    {
			super.createChildren();

      if (textLabel == null) {
  			textLabel = new Label();
        BindingUtils.bindProperty(textLabel, 'text', action, 'desc');
        textLabel.width = WIDTH;
        textLabel.height = HEIGHT;
        textLabel.maxDisplayedLines = 2;
  			addElement(textLabel);
      }
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			graphics.beginFill(backgroundColor);
      graphics.drawRoundRect(0, 0, width, height, 10, 10);
			graphics.endFill();
		}
    
    public function getLinkPoint():Point
    {
      return new Point(x + width/2, y + height/2);
    }
		
	}
	
}