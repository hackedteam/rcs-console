package it.ht.rcs.console.model
{
  import it.ht.rcs.console.accounting.User;
  
  import mx.resources.ResourceManager;
  import mx.core.FlexGlobals;

  public class Session
  {
    [Bindable]
    public var user:User;
    [Bindable]
    public var server:String;
    
    public var fake:Boolean;
    
    public function Session(user:User, server:String, fake:Boolean = false)
    {
      /* is it a real session */
      this.fake = fake;
      
      /* the user of this session */
      this.user = user;

      /* the connected server */
      this.server = server;
      
      /* set the locale of the current user */
      // FIXME: for some reason we cannot do this here, since the ResourceManager singleton is returing a sort of "read-only" impl
      //ResourceManager.getInstance().localeChain = [user.locale];

      /* update the clock timezone */
      Clock.instance.setConsoleTimezone(user.time_offset);
    }
    
    public function destroy():void
    {
      /* logout the user from the db */
      new Account().logout();
      
      /* current user is released */
      user = null;
    }
    
    
  }
}