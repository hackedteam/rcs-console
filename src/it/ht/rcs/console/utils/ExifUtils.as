package it.ht.rcs.console.utils
{
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.geom.Matrix;
  
  import jp.shichiseki.exif.IFDSet;
  
  public class ExifUtils
  {
    public static const PORTRAIT:int = 6;
    public static const PORTRAIT_REVERSE:int = 8;
    
    public static const LANDSCAPE:int = 1;
    public static const LANDSCAPE_REVERSE:int = 3;
    
    /**
     * function figures out the rotation needed so the image
     * appears in the right view for the user
     *
     *
     * @param ifd attribute in exif belonging to image
     * @return the angle to rotate an image based on ifd information
     * @see http://bit.ly/j70E7T
     */
    public static function getEyeOrientedAngle( set:IFDSet ):int
    {
      var angle:int = 0;
      
      if(!set)
       return angle;
      
      if( set.primary[ "Orientation" ] )
      {
        switch( set.primary[ "Orientation" ] )
        {
          case LANDSCAPE: angle = 0; break;
          case LANDSCAPE_REVERSE: angle = 180; break;
          case PORTRAIT: angle = 90; break;
          case PORTRAIT_REVERSE: angle = -90; break;
        }
      }
      
      return angle;
    }
    
    /**
     * creates a bitmap appealing to the eye, so that based on provided original bitmap and its IFDSet
     * it's possible to track the orientation and create a transformed bitmap copied from the original.
     *
     * @see <a href="http://www.psyked.co.uk/actionscript/rotating-bitmapdata.htm">rotating-bitmapdata.htm</a>
     * @see <a href="http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/geom/Matrix.html">matrix documentation</a>
     *
     * @param bitmap retrieved after selecting an image from CameraRoll
     * @param set retrieved after loading the Exif data from selected image
     * @return a new bitmap in the right angle and same dimensions as the original.
     *
     */
    public static function getEyeOrientedBitmap( bitmap:Bitmap, set:IFDSet ):Bitmap
    {
      var m:Matrix = new Matrix();
      var orientation:int= set.primary[ "Orientation" ];
      var bitmapData:BitmapData;
      
      if( orientation == LANDSCAPE || orientation == LANDSCAPE_REVERSE )
      {
        bitmapData = new BitmapData( bitmap.width, bitmap.height, true );
      }
      else
      {
        bitmapData = new BitmapData( bitmap.height, bitmap.width, true );
      }
      
      m.rotate( getEyeOrientedAngle( set ) * ( Math.PI / 180 ) );
      
      if( orientation == PORTRAIT_REVERSE )
      {
        m.translate( 0, bitmap.width );
      }
      else
        if( orientation == PORTRAIT )
        {
          m.translate( bitmap.height, 0 );
        }
        else
          if( orientation == LANDSCAPE_REVERSE )
          {
            m.translate( bitmap.width, bitmap.height );
          }
      
      bitmapData.draw( bitmap, m );
      
      return new Bitmap( bitmapData );
    }
  }
}
