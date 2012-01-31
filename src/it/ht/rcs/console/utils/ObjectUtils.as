package it.ht.rcs.console.utils
{
  import flash.utils.describeType;
  
  import mx.collections.ArrayCollection;

  public class ObjectUtils
  {

    private static const defaultToExclude:Array = ['_model', 'managingService'];
    
    public static function toHash(object:Object, customToExclude:Array=null):Object
    {
      var hash:Object = {};

      if (object)
      {
        var toExclude:Array = customToExclude || defaultToExclude;
        var def:XML = describeType(object);
        var properties:XMLList = def..accessor.@name;
        
        for each (var property:String in properties)
          if (toExclude.indexOf(property) == -1)
            hash[property] = object[property] is ArrayCollection ? object[property].source : object[property];
      }
      
      return hash;
    }
    
  }
  
}