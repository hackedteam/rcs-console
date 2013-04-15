/* 
* The MIT License
*
* Copyright (c) 2007 The SixDegrees Project Team
* (Jason Bellone, Juan Rodriguez, Segolene de Basquiat, Daniel Lang).
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/
package org.un.cava.birdeye.ravis.graphLayout.layout {
    
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;
    
    import mx.core.UIComponent;
    import mx.events.FlexEvent;
    
    import org.un.cava.birdeye.ravis.graphLayout.data.INode;
    import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualGraph;
    import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualNode;
    import org.un.cava.birdeye.ravis.utils.LogUtil;
    
    /**
     * This layouter does not use any algorithm for node placement,
     * but relys on coordinate information (x,y-coordinates) specified
     * in each nodes associated XML object.
     * It also takes a relative height and width parameter (which may be
     * calculated by autofit) to put the specified coordinates into
     * perspective.
     * */
    public class AnimatedDirectPlacementLayouter extends AnimatedBaseLayouter implements ILayoutAlgorithm {
        
        private static const _LOG:String = "graphLayout.layout.AnimatedDirectPlacementLayouter";
        
        /* hold the relative height and width of the specified coordinates */
        private var _relativeHeight:Number;
        private var _relativeWidth:Number;
        
        /* a specified relative origin, defaults to (0,0); */
        private var _relativeOrigin:Point;
        
        private var _currentDrawing:BaseLayoutDrawing;
        /**
         * defines if the vgraph's center offset should be applied.
         * Set it to true if your coordinates assume a centered origin
         * and you place them all around the center.
         * @default false
         * */
        public var centeredLayout:Boolean;
        
        public var leftMargin:Number = 30;
        
        public var topMargin:Number = 30;
        
        /**
         * The constructor only initialises some data structures.
         * @inheritDoc
         * */
        public function AnimatedDirectPlacementLayouter(vg:IVisualGraph = null) {
            super(vg);
            animationType = ANIM_STRAIGHT;
            _relativeHeight = 1000;
            _relativeWidth = 1000;
            _relativeOrigin = new Point(0,0);
            centeredLayout = false;
        }
        
        /**
         * @inheritDoc
         * */
        override public function resetAll():void {			
            
            super.resetAll();
            
            /* invalidate all trees in the graph */
            _stree = null;
            _graph.purgeTrees();
        }
        
        /**
         * This main interface method computes and
         * and executes the new layout.
         * @return Currently the return value is not set or used.
         * */
        override public function layoutPass():Boolean {
            
            //LogUtil.debug(_LOG, "layoutPass called");
            if(!_vgraph) {
                LogUtil.warn(_LOG, "No Vgraph set in DPLayouter, aborting");
                return false;
            }
            
            if(!_vgraph.currentRootVNode) {
                LogUtil.warn(_LOG, "This Layouter always requires a root node!");
                return false;
            }
            
            /* nothing to do if we have no nodes */
            if(_graph.noNodes < 1) {
                return false;
            }
            
            var notReadyRenderer:UIComponent = getFirstUninitializedNode();
            if(notReadyRenderer) {
                if(notReadyRenderer.hasEventListener(FlexEvent.CREATION_COMPLETE) == false) {
                    notReadyRenderer.addEventListener(FlexEvent.CREATION_COMPLETE,function(e:FlexEvent):void {
                        layoutPass(); 
                    });
                }
                return false;
            }
            else {
                
                _currentDrawing = new BaseLayoutDrawing();
                super.currentDrawing = _currentDrawing;
                placeNodes();
                
                if(centeredLayout)
                    centerDiagram();
                /* reset animation cycle */
                resetAnimation();
                
                /* start the animation, does also the commit */
                startAnimation();
                super.layoutPass();
            }
            
            _layoutChanged = true;
            return true;
        }
        
        /**
         * Centers the diagram to the page
         */
        protected function centerDiagram():void {
            var offset:Point = new Point(-bounds.x/2,-bounds.y/2);
            _currentDrawing.centeredLayout = false;
            _currentDrawing.originOffset = offset;
            
            var wF:Number = (vgraph.width - leftMargin)/(bounds.width);
            var hF:Number = (vgraph.height - topMargin)/(bounds.height);
            var sF:Number = Math.min(wF,hF);
            var newS:Number = Math.min(1, sF);
            vgraph.scale = newS;
            
            var setupsCenter:Point = new Point(bounds.width/2 , bounds.height/2);
            var ourCenter:Point = new Point(vgraph.width/newS/2, vgraph.height/newS/2);
            
            var transformPoint:Point = setupsCenter.subtract(ourCenter);
            for each(var node:INode in _graph.nodes) {
                var p:Point = _currentDrawing.getAbsCartCoordinates(node);
                p.x -= transformPoint.x;
                p.y -= transformPoint.y;
                _currentDrawing.setCartCoordinates(node,p);
            } 
        }
        
        private function getFirstUninitializedNode():UIComponent{
            for each(var node:IVisualNode in _vgraph.visibleVNodes) {
                if(node.view.initialized == false) {
                    return node.view;
                }
            }
            
            return null;
        }
        
        /**
         * Access the relative height for the y coordinates specified.
         * Default is 1000.
         * */
        public function set relativeHeight(rh:Number):void {
            _relativeHeight = rh;
        }
        
        /**
         * @private
         * */
        public function get relativeHeight():Number {
            return _relativeHeight;
        }
        
        /**
         * Access the relative width for the x coordinates specified.
         * Default is 1000.
         * */
        public function set relativeWidth(rw:Number):void {
            _relativeWidth = rw;
        }
        
        /**
         * @private
         * */
        public function get relativeWidth():Number {
            return _relativeWidth;
        }
        
        /**
         * Access the relative origin, which will result in an offset for
         * each coordinate, default is (0,0);
         * */
        public function set relativeOrigin(ro:Point):void {
            _relativeOrigin = ro;
        }
        
        /**
         * @private
         * */
        public function get relativeOrigin():Point {
            return _relativeOrigin;
        }
        
        
        /**
         * @internal
         * Places the nodes according to the specified coordinates
         * in the XML data of each node. Interprets the coordinates
         * relative to the Height and Width specified (default 1000).
         * If autoFit is enabled, it will in addition take that
         * into account. The internal reference grid is always 1000x1000.
         * */
        private function placeNodes():void {
            
            var nodePostions:Dictionary = new Dictionary();
            var visVNodes:Array;
            var vn:IVisualNode;
            var node_x:Number;
            var node_y:Number;
            var target:Point;
            var oldLocation:Point;
            var newLocation:Point;
            
            /* those are needed for autofit */
            var smallest_x:Number = Infinity;
            var largest_x:Number = -Infinity;
            var largest_y:Number = -Infinity;
            var smallest_y:Number = Infinity;
            var max_x_dist:Number = 0;
            var max_y_dist:Number = 0;
            var max_label_width:Number = -Infinity;
            var max_label_height:Number = -Infinity;
            
            visVNodes = _vgraph.visibleVNodes;
            
            /* place visible nodes */
            for each(vn in visVNodes) {
                
                if(vn.data is XML)
                {
                    /* check for x and y attributes */
                    if((vn.data as XML).attribute("x").length() > 0) {
                        node_x = Number(vn.data.@x);
                    } else {
                        LogUtil.warn(_LOG, "Node:"+vn.id+" associated XML object does not have x attribute, => 0.0");
                        node_x = 0.0;
                    }
                    
                    if((vn.data as XML).attribute("y").length() > 0) {
                        node_y = Number(vn.data.@y);
                    } else {
                        LogUtil.warn(_LOG, "Node:"+vn.id+" associated XML object does not have y attribute, => 0.0");
                        node_y = 0.0;
                    }
                }
                else
                {
                    if(vn.data.hasOwnProperty("x") && vn.data.x is Number) {
                        node_x = vn.data.x;
                    } else {
                        LogUtil.warn(_LOG, "Node:"+vn.id+" associated Data object does not have x attribute as Number, => 0.0");
                        node_x = 0.0;
                    }
                    
                    if(vn.data.hasOwnProperty("y") && vn.data.y is Number) {
                        node_y = vn.data.y;
                    } else {
                        LogUtil.warn(_LOG, "Node:"+vn.id+" associated Data object does not have y attribute, => 0.0");
                        node_y = 0.0;
                    }
                }
                
                //LogUtil.debug(_LOG, "using rel width:"+_relativeWidth+" rh:"+_relativeHeight);
                target = new Point(node_x * 1000 / _relativeWidth, node_y * 1000 / _relativeHeight);
                //LogUtil.debug(_LOG, "target for node:"+vn.id+" = " + target.toString());
                
                /* apply the relative origin */
                target = target.add(_relativeOrigin);
                //LogUtil.debug(_LOG, "target2 for node:"+vn.id+" = " + target.toString());
                
                
                /* set the coordinates in the VNode, this won't be
                * applied until commit() is called */
                _currentDrawing.setCartCoordinates(vn.node,target);
                
                /* if autofit is enabled, we need to track
                * the largest distances */
                if(_autoFitEnabled) {
                    if(smallest_x > target.x) {
                        smallest_x = target.x;
                    }
                    if(smallest_y > target.y) {
                        smallest_y = target.y;
                    }
                    if(largest_x < target.x) {
                        largest_x = target.x;
                    }
                    if(largest_y < target.y) {
                        largest_y = target.y;
                    }
                    if(vn.view.width > max_label_width) {
                        max_label_width = vn.view.width;
                    }
                    if(vn.view.height > max_label_height) {
                        max_label_height = vn.view.height;
                    }
                }
            }
            
            /* if autofitted, scale to the current canvas */
            if(_autoFitEnabled) {
                /* find greatest distance in each dimension */
                max_x_dist = largest_x - smallest_x;
                max_y_dist = largest_y - smallest_y;
                
                /* adjust nodes */
                for each(vn in visVNodes) {
                    oldLocation = _currentDrawing.getAbsCartCoordinates(vn.node);
                    newLocation = new Point();
                    newLocation.x = oldLocation.x * ((_vgraph.width - (2 * margin) - max_label_width) / max_x_dist);
                    newLocation.y = oldLocation.y * ((_vgraph.height - (2 * margin) - max_label_height) / max_y_dist);
                    _currentDrawing.setCartCoordinates(vn.node,newLocation);
                }
            }
            
            /* final round, to apply the vgraph origin */
            for each(vn in visVNodes) {
                
                oldLocation = _currentDrawing.getAbsCartCoordinates(vn.node);
                newLocation = new Point();
                
                newLocation.x = oldLocation.x + _vgraph.origin.x;
                newLocation.y = oldLocation.y + _vgraph.origin.y;
                
                if(centeredLayout) {
                    newLocation.x = newLocation.x + _vgraph.center.x;
                    newLocation.y = newLocation.y + _vgraph.center.y;	
                }
                _currentDrawing.setCartCoordinates(vn.node,newLocation);
            }
        }
    }
}
