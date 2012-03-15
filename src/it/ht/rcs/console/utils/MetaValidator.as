package it.ht.rcs.console.utils
{
  import mx.events.ValidationResultEvent;
  import mx.validators.Validator;

  public class MetaValidator
  {
    
    public var validators:Array;
    
    public function isValid():Boolean
    {
      for each (var val:Validator in validators)
        if (val.validate().type == ValidationResultEvent.INVALID)
          return false;
      
      return true;
    }
    
  }
}