package org.un.cava.birdeye.ravis.utils
{
    import flash.display.Graphics;
    import flash.geom.Point;
    
    /**
     * The class wraps the Graphics class so that you can add a fuzz factor around edges.  This is so you can mouse over them
     * much more easily.  It draws an invisible line underneath the lines that are actually being drawn so that mouse events
     * are caught, but it does not appear any different to the user.
     */ 
    public class GraphicsWrapper
    {
        public var fuzzFactor:Number = 5;
        
        private var _g:Graphics;
        
        private var _actualStyle:Object;
        
        private var _current:Point;
        
        private var _passThrough:Boolean;
        private var _disable:Boolean;
        
        public function GraphicsWrapper(g:Graphics)
        {
            _g = g;
            
            _actualStyle = {};
            _current = new Point();
        }
        
        public function clear():void
        {
            _actualStyle = {};
            _g.clear();
        }
        
        private function applyInvisiStyle():void
        {
            _g.lineStyle(_actualStyle.thickness + fuzzFactor,
                0xFF0000,
                0,
                _actualStyle.pixelHinting,
                _actualStyle.scaleMode,
                _actualStyle.caps,
                _actualStyle.joints,
                _actualStyle.miterLimit);
        }
        
        private function applyActualStyle():void
        {
            _g.lineStyle(_actualStyle.thickness,
                _actualStyle.color,
                _actualStyle.alpha,
                _actualStyle.pixelHinting,
                _actualStyle.scaleMode,
                _actualStyle.caps,
                _actualStyle.joints,
                _actualStyle.miterLimit);
        }
        
        public function lineStyle(thickness:Number=0,
                                  color:uint=0,
                                  alpha:Number=1,
                                  pixelHinting:Boolean=false,
                                  scaleMode:String="normal",
                                  caps:String=null,
                                  joints:String=null,
                                  miterLimit:Number=3):void
        {
            _actualStyle.thickness = thickness;
            _actualStyle.color = color;
            _actualStyle.pixelHinting = pixelHinting;
            _actualStyle.scaleMode = scaleMode;
            _actualStyle.caps = caps;
            _actualStyle.joints = joints;
            _actualStyle.miterLimit = miterLimit;
            
            _g.lineStyle(thickness,color,alpha,pixelHinting,scaleMode,caps,joints,miterLimit);
        }
        
        public function beginFill(color:uint,alpha:Number=1):void
        {
            _passThrough = true;
            _g.beginFill(color,alpha);
        }
        
        public function endFill():void
        {
            _g.endFill();
            _passThrough = false;
        }
        
        public function moveTo(x:Number,y:Number):void
        {
            _g.moveTo(x,y);
            
            _current.x = x;
            _current.y = y;
        }
        
        public function curveTo(controlX:Number,controlY:Number,x:Number,y:Number):void
        {
            _g.curveTo(controlX,controlY,x,y);
            
            if(enabled)
            {
                applyInvisiStyle();   
                
                _g.moveTo(_current.x,_current.y);
                _g.curveTo(controlX,controlY,x,y);
                
                applyActualStyle();
            }
            
            _current.x = x;
            _current.y = y;
        }
        
        public function lineTo(x:Number,y:Number):void
        {
            _g.lineTo(x,y);
            
            if(enabled)
            {
                applyInvisiStyle();   
                
                _g.moveTo(_current.x,_current.y);
                _g.lineTo(x,y);
                
                applyActualStyle();
            }
            _current.x = x;
            _current.y = y;
        }
        
        public function get enabled():Boolean { return _disable == false && _passThrough == false; }
        
        public function get disable():Boolean { return _disable; }
        public function set disable(value:Boolean):void
        {
            _disable = value;
        }
    }
}