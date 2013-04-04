package it.ht.rcs.console.entities.view.graph
{
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.events.NativeWindowBoundsEvent;
  
  import it.ht.rcs.console.entities.model.Entity;
  import it.ht.rcs.console.entities.model.Link;
  import it.ht.rcs.console.entities.view.renderers.EntityRenderer;
  import it.ht.rcs.console.operations.view.configuration.advanced.renderers.utils.ArrowStyle;
  import it.ht.rcs.console.operations.view.configuration.advanced.renderers.utils.GraphicsUtil;
  import it.ht.rcs.console.utils.ScrollableGraph;
  
  import mx.collections.ArrayCollection;
  
  public class LinkGraph extends ScrollableGraph
  {
    private var entities:ArrayCollection;
    public function LinkGraph()
    {
      super();
      this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
      this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
    }
    
    private function onAddedToStage(e:Event):void
    {
      //clear
      this.removeAllElements();
      this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
      this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
      this.stage.addEventListener(Event.RESIZE, onStageResize)
      this.stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZE, onStageResize)
    }
    
    
    private function onRemovedFromStage(e:Event):void
    {
      this.stage.removeEventListener(Event.RESIZE, onStageResize)
      this.stage.nativeWindow.removeEventListener(NativeWindowBoundsEvent.RESIZE, onStageResize)
      this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
      this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }
    
    private function onStageResize(e:Event):void
    {
      resize()
    }
    
    public function draw(entities:ArrayCollection):void
    {
      this.entities=entities;
      //clear
      this.removeAllElements();
      
      var centerX:Number=this.width*.5
      var centerY:Number=this.height*.5
    
      
      var numberOfPoints:Number=entities.length;
      var angleIncrement:Number = 360 / numberOfPoints;

      var radius:Number=this.height/2.5;
      var i:int=0;
      var entity:Entity;
      //draw as a circle;
      for(i=0;i<entities.length;i++)
      {
        entity=entities.getItemAt(i) as Entity;
        var renderer:EntityRenderer=new EntityRenderer(entity);

        renderer.x= centerX+((radius*1.5) * Math.cos((angleIncrement * i) * (Math.PI / 180)))-80;

        renderer.y= centerY+(radius * Math.sin((angleIncrement * i) * (Math.PI / 180)))-50;
       
        renderer.addEventListener(MouseEvent.CLICK, onRendererClick)
        addElement(renderer);
   
      }
      //draw connections
      for(i=0;i<entities.length;i++)
      {
        entity=entities.getItemAt(i) as Entity;
        if(entity.links)
        {
        for(var l:int=0;l<entity.links.length;l++)
        {
          var link:Link=entity.links.getItemAt(l) as Link;
          //draw link
        }
        
        }
          
      }
     
    }
      private function resize():void
      {
        this.removeAllElements();
        
        var centerX:Number=this.width*.5
        var centerY:Number=this.height*.5
        
        
        var numberOfPoints:Number=entities.length;
        var angleIncrement:Number = 360 / numberOfPoints;
        
        var radius:Number=this.height/2.5;
        
        //draw as a circle;
        for(var i:int=0;i<entities.length;i++)
        {
          var entity:Entity=entities.getItemAt(i) as Entity;
          var renderer:EntityRenderer=new EntityRenderer(entity);
          
          renderer.x= centerX+((radius*1.5) * Math.cos((angleIncrement * i) * (Math.PI / 180)))-80;
          renderer.y= centerY+(radius * Math.sin((angleIncrement * i) * (Math.PI / 180)))-50;
          renderer.addEventListener(MouseEvent.CLICK, onRendererClick)
          addElement(renderer);
          
        }
     
    }
      private function onRendererClick(e:MouseEvent):void
      {
        e.stopPropagation()
        var renderer:EntityRenderer=e.currentTarget as EntityRenderer;
        var entity:Entity =renderer.entity;
        trace(entity.name);
      }
  }
}