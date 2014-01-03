package it.ht.rcs.console.entities.view.renderers
{
  import com.greensock.TweenLite;
  import com.greensock.TweenMax;
  import com.greensock.motionPaths.LinePath2D;
  
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  import flash.filters.GlowFilter;
  import flash.geom.Point;
  
  import fr.kapit.visualizer.base.ISprite;
  import fr.kapit.visualizer.base.sprite.GenericLink;
  import fr.kapit.visualizer.renderers.ISelectable;

  public class CustomLink extends GenericLink
  {
    
    private var filter:GlowFilter=new GlowFilter(0x0099FF, 1,10,10,1,1)
  
    private var path1:LinePath2D;
    private var path2:LinePath2D;
    
    private var flowColor:uint;
    private var flowRenderers:Array;
      
    public function CustomLink(source:ISprite, target:ISprite)
    {
      super(source, target);
     
      this.buttonMode=true;
      this.useHandCursor=true;
      
      path1=new LinePath2D();
      path1.autoUpdatePoints=true;
      
      path2=new LinePath2D();
      path2.autoUpdatePoints=true;
      
      flowRenderers=new Array();
      
    //this.data
      
    }
    
    override protected function draw():void
    {
      super.draw();
      
      //graphics.clear();

  /*    graphics.beginFill(0X0000FF,0.5);
      graphics.drawCircle(path[0],path[1],6);  //start
      graphics.endFill();
      graphics.beginFill(0X00FF00,1);
      graphics.drawCircle(path[0]+(path[path.length-2]-path[0])*0.5,path[1]+(path[path.length-1]-path[1])*0.5,3);  //middle
      graphics.beginFill(0XFF0000,0.5);
      graphics.drawCircle(path[path.length-2],path[path.length-1],6);  //end
      graphics.endFill();*/
      

      if(isSelected)
        this.filters=[filter]
      else
        this.filters=null

      path1.points=[new Point(path[0], path[1]), new Point(path[path.length-2], path[path.length-1])]
      path2.points=[new Point(path[path.length-2], path[path.length-1]), new Point(path[0], path[1])]

    }
    
    
    public function flow():void    
    {
      trace("FLOW")
      
      flowRenderers=new Array()
      var numBalls:int=1;

      var flowRenderer:Sprite;
      var i:int;
      var increment:Number=0
  
        
        TweenMax.to(path1, 0, {progress: 0});
        
        for (i=0; i < numBalls; i++)
        {
          flowRenderer=new Sprite();
          
          this.addChild(flowRenderer);
          flowRenderer.graphics.beginFill(0xFF0000);
          flowRenderer.graphics.drawCircle(0, 0, 3);
          flowRenderer.graphics.endFill()
          flowRenderer.graphics.lineStyle(0.5, 0xFF0000, 1)
          flowRenderer.graphics.drawCircle(0, 0, 4);
          flowRenderers.push(flowRenderer)
          
          
          path1.addFollower(flowRenderer, increment)
          increment+=0.05;
        }
        path1.progress=0;
        TweenMax.to(path1, 2, {progress: 1, repeat: -1});
        
        draw()
    /* 
      path1=new LinePath2D();
      path1.autoUpdatePoints=true;
      
      path2=new LinePath2D();
      path2.autoUpdatePoints=true;
      
      
      path1.addFollower(flowRenderer)
      path1.progress=0;
      path2.progress=0;
      
      flowRenderer.x=path[0];
      flowRenderer.y=path[1];
      
      path1.points=[new Point(path[0], path[1]), new Point(path[2],path[3])]
      path2.points=[new Point(path[2], path[3]), new Point(path[0],path[1])]
        
      TweenMax.to(path1, 2, {progress: 1, repeat: -1});*/

    }
    
    public function showFlow(from:String, to:String, count:int):void
    {
      flowRenderers=new Array()
      flowColor=0xFF0000;
      var numBalls:int=0;
      
      if (count > 0 && count <= 10)
        numBalls=1;
      else if (count > 10 && count <= 50)
        numBalls=2;
      else if (count > 50)
        numBalls=3;
      

      
      var flowRenderer:Sprite;
      var i:int;
      var increment:Number=0
      if (this.data.source == from && this.data.target == to)
      {
        
        TweenMax.to(path1, 0, {progress: 0});
        
        for (i=0; i < numBalls; i++)
        {
          flowRenderer=new Sprite();
          
          this.addChild(flowRenderer);
          flowRenderer.graphics.beginFill(flowColor);
          flowRenderer.graphics.drawCircle(0, 0, 3);
          flowRenderer.graphics.endFill()
          flowRenderer.graphics.lineStyle(0.5, 0xFF0000, 1)
          flowRenderer.graphics.drawCircle(0, 0, 4);
          flowRenderers.push(flowRenderer)
          //this.setChildIndex(flowRenderer, this.numChildren-1)
          
          
          path1.addFollower(flowRenderer, increment)
          increment+=0.05;
        }
        path1.progress=0;
        TweenMax.to(path1, 2, {progress: 1, repeat: -1});
        
      }
        //inverse
      else if (this.data.source == to && this.data.target == from)
      {
        
        TweenMax.to(path2, 0, {progress: 0});
        
        for (i=0; i < numBalls; i++)
        {
          flowRenderer=new Sprite();
          
          this.addChild(flowRenderer);
          flowRenderer.graphics.beginFill(flowColor);
          flowRenderer.graphics.drawCircle(0, 0, 3);
          flowRenderer.graphics.endFill()
          flowRenderer.graphics.lineStyle(0.5, 0xFF0000, 1)
          flowRenderer.graphics.drawCircle(0, 0, 4);
          flowRenderers.push(flowRenderer)
          // this.setChildIndex(flowRenderer, this.numChildren-1)
          path2.addFollower(flowRenderer, increment)
          increment+=0.05;
        }
        path2.progress=0;
        TweenMax.to(path2, 2, {progress: 1, repeat: -1});
      }
      
      draw()
      
    }
    
    public function reset():void
    {
      trace("Custom Link Reset")
      while (this.numChildren > 0)
        this.removeChildAt(0)
      //this.addChild(dashed)
      //this.addChild(dotted)
      draw()
    }
    
    override protected function handleRollOverEvent(event:MouseEvent):void
    {
    
    }
    
    override protected function handleRollOutEvent(event:MouseEvent):void
    {
     
    }
    
  
  }
}