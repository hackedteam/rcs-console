package it.ht.rcs.console.entities.view.renderers
{

  import mx.core.UIComponent;
  
  import spark.components.Group;
  import spark.components.Image;
  import spark.layouts.VerticalLayout;
  
  public class EntityRenderer extends Group
  {
    private static const WIDTH:Number  = 90; // 5*2 (padding) + 80 (width of label)
    private static const HEIGHT:Number = 66 + 26; // 5*2 (padding) + 50 (height of container) + 6 (gap) + 26 (height of label)
    
    private static const NORMAL_COLOR:Number = 0xffffff;
    private static const SELECTED_COLOR:Number = 0xa8c6ee;
    
    [Embed(source='/img/NEW/star_50.png')]
    private var entityIcon:Class;
    
    [Embed(source='/img/NEW/entity_people_50.png')]
    private var entityPeopleIcon:Class;
    
    [Embed(source='/img/NEW/entity_location_50.png')]
    private var entityLocationIcon:Class;
    
    [Embed(source='/img/NEW/entity_target_50.png')]
    private var entityTargetIcon:Class;
    
    public function EntityRenderer()
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
  }
}