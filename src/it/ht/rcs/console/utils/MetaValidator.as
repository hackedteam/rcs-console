package it.ht.rcs.console.utils
{
  import mx.events.ValidationResultEvent;
  import mx.validators.Validator;
  
  import spark.validators.NumberValidator;

  public class MetaValidator
  {
    
    public static const ipExpr:String = "^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\." +
                                        "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\." +
                                        "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\." +
                                        "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$";
    
    public var validators:Array;
    
    public function isValid():Boolean
    {
      for each (var val:* in validators)
       if(val is Validator || val is NumberValidator)
       {
         if (val.validate().type == ValidationResultEvent.INVALID)
           return false;
       }
      return true;
    }
    
  }
}