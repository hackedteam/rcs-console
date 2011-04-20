package it.ht.rcs.console.model
{
  import it.ht.rcs.console.utils.Clock;

  public class Session
  {
    [Bindable]
    public var user:String;
    [Bindable]
    public var contact:String;
    [Bindable]
    public var privs:Array;
    [Bindable]
    public var locale:String;

    public function Session()
    {
     // TODO fill in with real info
      user = "alor";
      contact = "alor@hackingteam.it";
      privs = ['ADMIN', 'TECH', 'VIEW'];
      locale = 'it_IT';
      
      /* set the locale of the current user */
      // FIXME: for some reason we cannot do this here, since the ResourceManager singleton is returing a sort of "read-only" impl
      //ResourceManager.getInstance().localeChain = [console.currentSession.locale];
      /* update the clock timezone */
      Clock.instance.setConsoleTimezone(0);
    }
    
    
  }
}