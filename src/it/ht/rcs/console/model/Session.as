package it.ht.rcs.console.model
{
  
  import it.ht.rcs.console.accounting.model.User;
  
  import mx.core.FlexGlobals;
  import mx.resources.ResourceManager;

  public class Session
  {
    [Bindable]
    public var user:User;
    [Bindable]
    public var server:String;
    [Bindable]
    public var authCookie:String;
    
    public var fake:Boolean;
    
    public function Session(user:User, server:String, authCookie:String, fake:Boolean = false)
    {
      /* is it a real session */
      this.fake = fake;
      
      /* the user of this session */
      this.user = user;

      /* the cookie value for server-side session management */
      this.authCookie = authCookie;
      
      /* the connected server */
      this.server = server;
      
      /* set the locale of the current user */
      // FIXME: for some reason we cannot do this here, since the ResourceManager singleton is returing a sort of "read-only" impl
      //ResourceManager.getInstance().localeChain = [user.locale];

      /* update the clock timezone */
      Clock.instance.setConsoleTimezone(user.timezone);
    }
    
    public function destroy():void
    {      
      /* current user is released */
      user = null;
      server = null;
    }
    
    
  }
}