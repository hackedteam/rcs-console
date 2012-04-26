package it.ht.rcs.console.main.skins.chrome
{
  import flash.events.Event;
  
  import it.ht.rcs.console.utils.CounterBaloon;
  
  import mx.events.PropertyChangeEvent;
  
  import spark.components.ButtonBarButton;
  import spark.components.Label;
  
  public class FixedSizeButtonBarButton extends ButtonBarButton
  {
  
    [SkinPart(required='false')]
    public var baloon:CounterBaloon;
    
    override public function set label(value:String):void
    {
      super.label = value;
      var size:int = parseInt((labelDisplay as Label).getStyle('fontSize'));
      width = measureText(value).width + (size * 3);
    }
    
    override public function set data(value:Object):void
    {
      if (data && data.hasOwnProperty('manager') && data.manager != null)
        data.manager.instance.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onCounterChange);
      
      super.data = value;
      
      if (data && data.hasOwnProperty('manager') && data.manager != null)
        data.manager.instance.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onCounterChange);
    }
    
    private function onCounterChange(e:Event):void
    {
      if (baloon) {
        baloon.visible = data.manager.instance[data.property].value;
        baloon.value = data.manager.instance[data.property].value;
        baloon.style = data.manager.instance[data.property].style;
      }
    }
    
  }
  
}