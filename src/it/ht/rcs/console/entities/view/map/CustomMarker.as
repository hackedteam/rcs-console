package it.ht.rcs.console.entities.view.map
{
  import flash.display.Sprite;
  
  import it.ht.rcs.console.entities.model.Entity;
  
  
  public class CustomMarker extends Sprite
  {
    
    [Embed(source='/img/NEW/star_50.png')]
    private var entityIcon:Class;
    
    [Embed(source='/img/NEW/mapMarker_people.png')]
    private var entityPeopleIcon:Class;
    
    [Embed(source='/img/NEW/mapMarker_location.png')]
    private var entityLocationIcon:Class;
    
    [Embed(source='/img/NEW/mapMarker_target.png')]
    private var entityTargetIcon:Class;
    
    public var data:Entity;
    
    public function CustomMarker(entity:Entity)
    {
      data=entity;
      var icon:Sprite=new Sprite();
      icon.x=-12;
      icon.y=-24;
      if(entity.type =="position")
        icon.addChild(new entityLocationIcon());
      if(entity.type =="target")
        icon.addChild(new entityTargetIcon());
      addChild(icon); 
    }
  }
}