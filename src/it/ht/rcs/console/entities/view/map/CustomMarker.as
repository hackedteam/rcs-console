package it.ht.rcs.console.entities.view.map
{
  import flash.display.Sprite;
  
  import it.ht.rcs.console.entities.model.Entity;
  
  
  public class CustomMarker extends Sprite
  {
    
    [Embed(source='/img/NEW/star_50.png')]
    private var entityIcon:Class;
    
    [Embed(source='/img/NEW/entity_people_50.png')]
    private var entityPeopleIcon:Class;
    
    [Embed(source='/img/NEW/entity_location_50.png')]
    private var entityLocationIcon:Class;
    
    [Embed(source='/img/NEW/entity_target_50.png')]
    private var entityTargetIcon:Class;
    
    public var data:Entity;
    
    public function CustomMarker(entity:Entity)
    {
      data=entity;
      var icon:Sprite=new Sprite();
      icon.x=-25;
      icon.y=-25;
      if(entity.type =="position")
        icon.addChild(new entityLocationIcon());
      if(entity.type =="target")
        icon.addChild(new entityTargetIcon());
      addChild(icon); 
    }
  }
}