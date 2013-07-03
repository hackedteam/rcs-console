package it.ht.rcs.console.utils
{
  public class StringUtils
  {
    public function StringUtils()
    {
    }
    
    public static function getExtension(path:String):String
    {
      var extension:String = path.substring(path.lastIndexOf(".")+1, path.length);
      return extension;
    }
    
    public static function getFilename(path:String):String
    {
      var fSlash: int = path.lastIndexOf("/");
      var bSlash: int = path.lastIndexOf("\\"); // reason for the double slash is just to escape the slash so it doesn't escape the quote!!!
      var slashIndex: int = fSlash > bSlash ? fSlash : bSlash;
      var name: String = path.substr(slashIndex + 1);
     
      return name;
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