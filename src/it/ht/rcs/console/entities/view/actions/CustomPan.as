package it.ht.rcs.console.entities.view.actions
{
  import fr.kapit.visualizer.actions.PanAction;
  
  public class CustomPan extends PanAction
  {
    public static const ID:String = "CustomPan";
    
    public function CustomPan()
    {
      super();
    }
    public override function get id():String
    {
      return ID;
    }
  }
}