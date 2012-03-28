package it.ht.rcs.console.utils
{
  public class StringUtils
  {
    public function StringUtils()
    {
    }
    
    public static function truncate(s:String,len:int, replacement:String):String
    {
      var truncated:String;
      if(s.length<=len)
      {
        truncated=s;
        
      }
      else
      {
        var lastCharIndex:int=len
        var lastChar:String=s.charAt(lastCharIndex);
        if(lastChar!=" ")
          for(var i:int=lastCharIndex;i<s.length;i++)
          {
            if(s.charAt(i)==" ")
            {
              lastCharIndex=i;
              break;
            }
          }
        
        truncated=s.substr(0,lastCharIndex);
        truncated+=replacement
      }
      return truncated
    }
  }
}