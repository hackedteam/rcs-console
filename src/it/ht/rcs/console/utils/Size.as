package it.ht.rcs.console.utils
{
  import mx.formatters.NumberBaseRoundType;
  import mx.formatters.NumberFormatter;
  
  public class Size
  {
    
    public static const TIB:Number = 1099511627776;
    public static const GIB:Number = 1073741824;
    public static const MIB:Number = 1048576;
    public static const KIB:Number = 1024;
    
    public static function toHumanBytes(n:Number):String
    {
      var num:NumberFormatter = new NumberFormatter();
      num.precision = 0;
      num.rounding = NumberBaseRoundType.NEAREST;

      if (n > TIB) {
        num.precision = 2;
        return num.format(n / TIB).toString() + " TiB";
      }
      
      if (n > GIB) {
        num.precision = 2;
        return num.format(n / GIB).toString() + " GiB";
      }
      
      if (n > MIB) {
        num.precision = 1;
        return num.format(n / MIB).toString() + " MiB";
      }
      
      if (n > KIB)
        return num.format(n / KIB).toString() + " KiB";
      
      return num.format(n).toString() + " B"; 
    }
  }
}