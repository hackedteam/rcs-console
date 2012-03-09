package it.ht.rcs.console.utils
{
  import spark.core.ContentCache;
  
  public class ImageCache
  {
    private static var _instance:ImageCache;
    public var cache:ContentCache;
    
    public function ImageCache(s:Singleton, maxCacheEntries:int=100) {
      
      cache = new ContentCache();
      cache.maxCacheEntries = maxCacheEntries;
      
    }
    
    public static function getInstance(maxCacheEntries:int=100):ImageCache {
      
      if (ImageCache._instance == null)
      {
        ImageCache._instance = new ImageCache(new Singleton(), maxCacheEntries);
      }
      return ImageCache._instance;
    }
    
  }
  
}

class Singleton {}