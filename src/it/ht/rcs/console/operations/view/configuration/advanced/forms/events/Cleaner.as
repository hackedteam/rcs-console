package it.ht.rcs.console.operations.view.configuration.advanced.forms.events
{
  public class Cleaner
  {
    
    private static const toKeep:Array = ['event', 'desc', 'start', 'stop', 'repeat'];
    
    public static function clean(event:Object):void
    {
      if (event)
      {
        for (var property:String in event)
          if (toKeep.indexOf(property) == -1)
            delete(event[property]);
      }
    }
    
  }
}