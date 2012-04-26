package it.ht.rcs.console.utils
{
  public class FileUtils
  {
   public static function getAccessMask(value:int):String
    {

      var res : String = "";
      
      if ((value & 0x80000000) != 0)
        res+="R";
      else
        res+="-";
      
      if ((value & 0x40000000) != 0)
        res+="W";
      else
        res+="-";
      
      if ((value & 0x20000000) != 0)
        res+="X";
      else
        res+="-";
      
      if ((value & 0x00010000) != 0)
        res+="D";
      else
        res+="-";
      
      return res;
      
    }
/*    public static function getAccessMask(value:int):String
    {
      
      var res : String = "";
      
      if (((value & 0x80000000) != 0) || ((value & 0x40000000) != 0) || ((value & 0x20000000) != 0))
      {
        res="open"
      }

      else if ((value & 0x00010000) != 0)
      {
        res="delete"
      }
      else
      {
        res="(unknown)"
      }
     
      return res;
      
    }*/
  }
}