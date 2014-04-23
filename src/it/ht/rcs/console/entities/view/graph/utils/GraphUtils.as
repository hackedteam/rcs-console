package it.ht.rcs.console.entities.view.graph.utils
{
  import it.ht.rcs.console.entities.model.Entity;
  
  import mx.collections.ArrayCollection;

  public class GraphUtils
  {
    public static function alreadyLinked(links:Array, source:String, target:String):Boolean
    {
      for (var i:int=0; i < links.length; i++)
      {
        if ((links[i].target == target && links[i].source == source) || (links[i].target == source && links[i].source == target))
        {
          return true;
        }
      }
      return false;
    }
    
    public static function isGrouped(entities:ArrayCollection, entity:Entity):Boolean
    {
      for (var i:int=0; i < entities.length; i++)
      {
        if (entities.getItemAt(i).type == "group" && entities.getItemAt(i).children.contains(entity._id))
        {
          return true;
        }
      }
      return false;
    }
  }
}