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
    import flash.utils.Dictionary;
    
    import org.un.cava.birdeye.ravis.graphLayout.data.INode;
    import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualGraph;
    import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualNode;
    import org.un.cava.birdeye.ravis.utils.LogUtil;
    import org.un.cava.birdeye.ravis.utils.events.VGraphEvent;
    
    /**
     * This layouter implements the drawing of generalized trees
     * in a hierarchical fashion using the algorithm by
     * Christoph Buchheim, Michael Juenger and Sebastian Leipert
     * presented in their paper 
     * "Improving Walker's Algorithm to run in linear time"
     * */
    public class HierarchicalLayouter extends AnimatedBaseLayouter implements ILayoutAlgorithm {
        
        private static const _LOG:String = "graphLayout.layout.HierarchicalLayouter";
        
        /**
         * Set the orientation to this to result in a
         * left to right layout.
         * */
        public static const ORIENT_LEFT_RIGHT:uint = 0;
        
        /**
         * Set the orientation to this to result in a
         * right to left layout.
         * */		
        public static const ORIENT_RIGHT_LEFT:uint = 1;
        
        /**
         * Set the orientation to this to result in a
         * top down layout.
         * */
        public static const ORIENT_TOP_DOWN:uint = 2;
        
        /**
         * Set the orientation to this to result in a
         * bottom up layout.
         * */
        public static const ORIENT_BOTTOM_UP:uint = 3;
        
        /** this holds the data for the Hierarchical layout drawing */
        protected var _currentDrawing:HierarchicalLayoutDrawing;
        
        /* this is the distance between nodes within a layer
        * typically x distance if top-bottom orientation
        * it may be preset by autofit */
        protected var _breadth:Number;
        
        /* set to true if you want node sizes to be taken
        * into account */
        private var _honorNodeSize:Boolean;
        
        /* this is the distance between layers, or typically
        * the y distance if top-bottom orientation.
        * Again it may be set by autofit */
        protected var _linkLength:Number;
        
        /* this holds the actual orientation */
        private var _orientation:uint;
        
        /* this enables an additional spread of nodes within the
        * same layer, but which are all siblings */
        private var _siblingSpreadEnabled:Boolean;
        
        /* the corresponding distance, should be at least */
        private var _siblingSpreadDistance:Number;
        
        /* enables interleaved spread of nodes if _siblingSpreadEnabled is true */
        private var _interleaveSiblings:Boolean;
        
        /**
         * The constructor only initialises some data structures.
         * @inheritDoc
         * */
        public function HierarchicalLayouter(vg:IVisualGraph = null) {
            super(vg);
            animationType = ANIM_STRAIGHT; // inherited
            initModel();
            
            _breadth = 10;
            _linkLength = 10;
            _orientation = ORIENT_TOP_DOWN;
            //_orientation = ORIENT_BOTTOM_UP;
            _siblingSpreadEnabled = true;
            _siblingSpreadDistance = 10;
            _honorNodeSize = false;
            _interleaveSiblings = false;
        }
        
        /**
         * @inheritDoc
         * */
        override public function resetAll():void {			
            
            super.resetAll();
            
            /* invalidate all trees in the graph */
            _stree = null;
            
            /* handles if we have been reset when 
            we do not have a graph */
            if(_graph)
            {
                _graph.purgeTrees();
            }
            
            initModel();
        }
        
        /**
         * This main interface method computes and
         * and executes the new layout.
         * @return Currently the return value is not set or used.
         * */
        override public function layoutPass():Boolean {
            
            super.layoutPass();
            
            var i:int;
            var n:INode;
            var visVNodes:Dictionary;
            var vn:IVisualNode;
            var cindex:int;
            var nsiblings:int;
            var rv:Boolean;
            var children:Array;
            
            //LogUtil.info(_LOG, "layoutPass called");
            
            if(!_vgraph) {
                LogUtil.warn(_LOG, "No Vgraph set in HierarchicalLayouter, aborting");
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
            
            /* if there is a timer, we have to stop it to
            * prevent inconsistencies */
            killTimer();
            
            /* establish the current root, if it has 
            * changed we need to reinit the model */
            if(_root != _vgraph.currentRootVNode.node) {
                _root = _vgraph.currentRootVNode.node;
                _layoutChanged = true;
            }
            
            
            /* establish the spanning tree */
            //_graph.purgeTrees();
            _stree = _graph.getTree(_root,true,false);
            
            /* check if the root is visible, if not
            * this is an issue */
            if(!_root.vnode.isVisible) {
                LogUtil.warn(_LOG, "Invisible root node, this is probably due to wrong initialisation of nodes or wrong defaults");
                return false;
            }
            
            /* need to see where how we could get a clear
            * list of situation how to deal with hab
            * if the layout was changed (or any parameter)
            * we have to reinit the model */
            initModel();
            
            /* this is complicated. */
            if(_autoFitEnabled) {
                /* now we calculate the best spacing */
                calculateAutoFit();
            }
            
            /* do the first pass */
            firstWalk(_root);
            
            /* and now the second */
            secondWalk(_root, -_currentDrawing.getPrelim(_root));
            
            //now we fit the diagram to the center of the screen
            centerDiagram();
            
            /* reset animation cycle */
            resetAnimation();
            
            /* start the animation, does also the commit */
            startAnimation();		
            
            _layoutChanged = true;
            return rv;
        }
        
        /**
         * @inheritDoc
         * */
        [Bindable]
        override public function get linkLength():Number {
            return _linkLength / 10;
        }
        /**
         * @private
         * */
        override public function set linkLength(value:Number):void {
            _linkLength = value * 10;
        }
        
        /**
         * Set the spacing between the nodes within a layer.
         * Typical range 0 .. 100 should be ok.
         * */
        public function set breadth(b:Number):void {
            _breadth = b;
        }
        
        /**
         * @private
         * */
        public function get breadth():Number {
            return _breadth;
        }		
        
        /**
         * Enable a spreading out of sibling nodes to
         * make labels more legible in some cases.
         * */
        public function set enableSiblingSpread(ss:Boolean):void {
            _siblingSpreadEnabled = ss;
            /* notify controls (specifically interleaving toggle */
            if(_vgraph) {
                _vgraph.dispatchEvent(new VGraphEvent(VGraphEvent.LAYOUTER_HIER_SIBLINGSPREAD));
            }
        }
        
        /**
         * @private
         * */
        public function get enableSiblingSpread():Boolean {
            return _siblingSpreadEnabled;
        }
        
        /**
         * Enable a interleaved spreading out of sibling nodes to
         * make labels more legible in some cases.
         * */
        public function set interleaveSiblings(value:Boolean):void {
            _interleaveSiblings = value;
        }
        
        /**
         * @private
         * */
        public function get interleaveSiblings():Boolean {
            return _interleaveSiblings;
        }
        
        /**
         * Allows to specify the fixed distance to spread the
         * siblings.
         * @default 10
         * */
        public function get siblingSpreadDistance():Number {
            return _siblingSpreadDistance;	
        }
        
        /**
         * @private
         * */
        public function set siblingSpreadDistance(distance:Number):void {
            _siblingSpreadDistance = distance;
        }
        
        /**
         * Allow to specify that node size should be honored
         * when spacing.
         * @default false
         * */
        public function get honorNodeSize():Boolean {
            return _honorNodeSize;
        }
        
        /**
         * @private
         * */
        public function set honorNodeSize(honor:Boolean):void {
            _honorNodeSize = honor;
        }
        
        /**
         * Set the orientation for the hierarchical
         * layouter. Available values are provided through
         * defined constants. Use one of:
         * HierarchicalLayouter.ORIENT_TOP_DOWN
         * HierarchicalLayouter.ORIENT_BOTTOM_UP
         * HierarchicalLayouter.ORIENT_LEFT_RIGHT
         * HierarchicalLayouter.ORIENT_RIGHT_LEFT
         * 
         * @param o The orientation value, one of the above.
         * */
        public function set orientation(o:uint):void {
            switch(o) {
            case ORIENT_LEFT_RIGHT:
            case ORIENT_RIGHT_LEFT:
            case ORIENT_TOP_DOWN:
            case ORIENT_BOTTOM_UP:
                _orientation = o;
                break;
            default:
                LogUtil.warn(_LOG, "orientation:"+o+" not supported");
            }
            
            if(_vgraph.layouter == this)
            {
                centerDiagram()
            
                /* do a redraw */
                layoutPass();
            }
        }
        
        /**
         * @private
         * */
        public function get orientation():uint {
            return _orientation;
        }
        
        /* private methods */
        
        /**
         * @internal
         * This does the first pass over the nodes, recursing
         * downwards to each leaf and computing the preliminary
         * x value for each node. It also calls the "apportion()"
         * function which is the heart of the algorithm.
         * Then the children are spaced by executeShifts and finally
         * the node is moved to the center of its children.
         * @param v The root of the current subtree to work on.
         * */
        private function firstWalk(v:INode):void {
            var nochild:uint;
            var child:INode;
            var sibling:INode;
            var i:uint;
            var midpoint:Number;
            var prelimsib:Number;
            var vindex:uint;
            var depthOffset:Number;
            var defaultAncestor:INode;
            var ilfactor:int = 1; // for interleaving
            
            nochild = _stree.getNoChildren(v);
            vindex = _stree.getChildIndex(v);
            
            if(nochild == 0) {
                /* if v's childindex is > 0 then there is a 
                * node with a smaller one, i.e. one on the left and we need to space it */
                if(vindex > 0) { 
                    /* get the left sibling by getting the vindex - 1'th child of
                    * it's parent */
                    sibling = _stree.getIthChildPerNode(_stree.parents[v],vindex - 1);
                    
                    /* get the prelim value of the sibling */
                    prelimsib = _currentDrawing.getPrelim(sibling);
                    
                    /* now set it for this node, but add the spacing */
                    _currentDrawing.setPrelim(v, prelimsib + spacing(sibling, v));
                } else {
                    _currentDrawing.setPrelim(v,0);
                }  
            } else {
                /* init to the first (0th, leftmost) child of v, 
                * may be modified by apportion() */
                defaultAncestor = _stree.getIthChildPerNode(v,0);
                
                depthOffset = 0;
                
                for(i=0; i < nochild; ++i) {
                    child = _stree.getIthChildPerNode(v,i);
                    /* recurse */
                    firstWalk(child);
                    /* and call apportion */
                    defaultAncestor = apportion(child, defaultAncestor);
                    
                    /* apply the depth offset for each child */
                    if(_siblingSpreadEnabled) {
                        _currentDrawing.setDepthOffset(child,depthOffset);
                        // Not so .. Dirty hack for interleaving
                        depthOffset += ilfactor * _siblingSpreadDistance;
                        if(_interleaveSiblings) {
                            ilfactor = -ilfactor;
                        }
                    }
                }
                
                /* do the shifts */
                executeShifts(v);
                
                /* now center the node above its children */
                
                /* get the prelim value of the leftmost child */
                child = _stree.getIthChildPerNode(v,0);
                midpoint = _currentDrawing.getPrelim(child);
                
                /* now add the prelim of the rightmost child */
                child = _stree.getIthChildPerNode(v,nochild - 1);
                midpoint += _currentDrawing.getPrelim(child);
                
                /* now half it to get the center */
                midpoint = 0.5 * midpoint;
                
                /* if v's childindex is > 0 then there is a 
                * node with a smaller one, i.e. one on the left.
                */
                if(vindex > 0) {
                    /* get the left sibling by getting the vindex - 1'th child of
                    * it's parent */
                    sibling = _stree.getIthChildPerNode(_stree.parents[v],vindex - 1);
                    
                    /* get the prelim value of the sibling */
                    prelimsib = _currentDrawing.getPrelim(sibling);
                    
                    /* now set it for this node, but add the spacing */
                    _currentDrawing.setPrelim(v, prelimsib + spacing(sibling,v));
                    
                    /* also set the modifier for v */
                    _currentDrawing.setModifier(v, _currentDrawing.getPrelim(v) - midpoint);
                } else {
                    _currentDrawing.setPrelim(v,midpoint);
                }
            }
        }
        
        /**
         * This method combines a subtree with other subtrees, traverses
         * their contours/outlines using 'thread' pointers, etc.
         * @param v The node (root of subtree) to work on.
         * @param defaultAncestor (self explaining).
         * */
        private function apportion(v:INode, da:INode):INode {
            var vinsideleft:INode;
            var vinsideright:INode;
            var voutsideleft:INode;
            var voutsideright:INode;
            var sumileft:Number;
            var sumiright:Number;
            var sumoleft:Number;
            var sumoright:Number;
            var shift:Number;
            var vindex:uint;
            var w:INode;
            var defaultAncestor:INode;
            var lgua:INode; // left greatest uncommon ancestor
            
            defaultAncestor = da;
            
            /* if we have a left sibling w */
            vindex = _stree.getChildIndex(v);
            if(vindex > 0) {
                w = _stree.getIthChildPerNode(_stree.parents[v], vindex  - 1 );
                
                vinsideright = v;
                voutsideright = v;
                vinsideleft = w;
                
                /* the leftmost sibling of vinsideright which is v */
                voutsideleft = _stree.getIthChildPerNode(_stree.parents[v],0);
                
                sumiright = _currentDrawing.getModifier(vinsideright);
                sumoright = _currentDrawing.getModifier(voutsideright);
                sumileft = _currentDrawing.getModifier(vinsideleft);
                sumoleft = _currentDrawing.getModifier(voutsideleft);
                
                while((nextRight(vinsideleft) != null) && (nextLeft(vinsideright) != null)) {
                    
                    /* traverse the inside nodes more to the inside
                    * and the outside nodes further out */
                    vinsideright = nextLeft(vinsideright);
                    voutsideright = nextRight(voutsideright);
                    vinsideleft = nextRight(vinsideleft);
                    voutsideleft = nextLeft(voutsideleft);
                    
                    /* adjust the ancestor */
                    _currentDrawing.setAncestor(voutsideright,v);
                    
                    shift = (sumileft + _currentDrawing.getPrelim(vinsideleft)) -
                        (sumiright + _currentDrawing.getPrelim(vinsideright)) +
                        spacing(vinsideleft,vinsideright);
                    
                    if(shift > 0) {
                        /* get the left greatest uncommon ancestor */
                        lgua = leftGrUnAncestor(vinsideleft, v, defaultAncestor);
                        /* now move the subtree by shift */
                        moveSubtree(lgua, v, shift);
                        /* adjust sums */
                        sumiright += shift;
                        sumoright += shift;
                    }
                    
                    sumileft += _currentDrawing.getModifier(vinsideleft);
                    sumiright += _currentDrawing.getModifier(vinsideright);
                    sumoleft += _currentDrawing.getModifier(voutsideleft);
                    sumoright += _currentDrawing.getModifier(voutsideright);
                } // while
            } // if vindex > 0
            
            if((nextRight(vinsideleft) != null) && (nextRight(voutsideright) == null)) {
                /* set the thread pointer */
                _currentDrawing.setThread(voutsideright, nextRight(vinsideleft));
                /* add to the modifier */
                _currentDrawing.addToModifier(voutsideright, (sumileft - sumoright));
            }
            
            if((nextLeft(vinsideright) != null) && (nextLeft(voutsideleft) == null)) {
                /* set the thread pointer */
                _currentDrawing.setThread(voutsideleft, nextLeft(vinsideright));
                /* add to the modifier */
                _currentDrawing.addToModifier(voutsideleft, (sumiright - sumoleft));
                /* update the default ancestor */
                defaultAncestor = v;
            }
            return defaultAncestor;
        } // function 
        
        
        /**
         * returns the next node of the left contour/outline
         * of the subtree */
        private function nextLeft(v:INode):INode {
            /* if the node has children we return the leftmost
            * child, if not, we return the thread of the node */
            if(_stree.getNoChildren(v) > 0) {
                return _stree.getIthChildPerNode(v,0);
            } else {
                return _currentDrawing.getThread(v);
            }
        }
        
        /**
         * returns the next node of the right contour/outline
         * of the subtree */
        private function nextRight(v:INode):INode {
            var nochildren:uint;
            
            nochildren = _stree.getNoChildren(v);
            
            /* if the node has children we return the rightmost
            * child, if not, we return the thread of the node */
            if(nochildren > 0) {
                return _stree.getIthChildPerNode(v,nochildren - 1);
            } else {
                return _currentDrawing.getThread(v);
            }
        }
        
        /**
         * Moves the subtree in wright by shift, all other moves
         * are done later, but we remember their change and shift
         * values.
         * */
        private function moveSubtree(wleft:INode, wright:INode, shift:Number):void {
            var subtrees:int;
            
            subtrees = _stree.getChildIndex(wright) - _stree.getChildIndex(wleft);
            
            _currentDrawing.addToChange(wright, -(shift / subtrees));
            _currentDrawing.addToChange(wleft, (shift / subtrees));
            _currentDrawing.addToShift(wright, shift);
            _currentDrawing.addToPrelim(wright, shift);
            _currentDrawing.addToModifier(wright, shift);
        }
        
        /**
         * Finally execute all shifts that were accumulated
         * in previous moveSubtree calls
         * */
        private function executeShifts(v:INode):void {
            var shift:Number;
            var change:Number;
            var w:INode;
            var nochildren:uint;
            var i:int;
            
            shift = 0;
            change = 0;
            
            nochildren = _stree.getNoChildren(v);
            /* need to walk from right to left here */
            for(i=(nochildren -1); i >= 0; --i) {
                w = _stree.getIthChildPerNode(v,i);
                _currentDrawing.addToPrelim(w,shift);
                _currentDrawing.addToModifier(w,shift);
                
                change += _currentDrawing.getChange(w);
                shift += _currentDrawing.getShift(w) + change;
            }
        }
        
        
        /**
         * Finds and returns the left one of the greatest
         * uncommon ancestors of vileft and its right neighbour.
         * */
        private function leftGrUnAncestor(vileft:INode, v:INode, da:INode):INode {
            var avileft:INode;
            
            avileft = _currentDrawing.getAncestor(vileft);
            
            if(_stree.areSiblings(avileft,v)) {
                return avileft;
            } else {
                return da;
            }
        }
        
        /**
         * Computes the real x values from all the saved parameters
         * this is not yet subject to orientation, but could be
         * done here.
         * @param n The node set its coordinates.
         * @param m An accumulated modifier.
         * */
        private function secondWalk(v:INode, m:Number):void {
            var breadth:Number;
            var depth:Number;
            var children:Array;
            var w:INode;
            var result:Point;
            
            /* the depth value is the depth from the root times
            * the layerDistance. */
            depth = _stree.getDistance(v) * _linkLength;
            breadth = _currentDrawing.getPrelim(v) + m;
            
            if(_siblingSpreadEnabled) {
                depth -= _currentDrawing.getDepthOffset(v);
            }
            
            switch(_orientation) {
            case ORIENT_TOP_DOWN:
                result = new Point(breadth, depth);
                break;
            case ORIENT_BOTTOM_UP:
                result = new Point(breadth, -depth);
                break;
            case ORIENT_LEFT_RIGHT:
                result = new Point(depth, breadth);
                break;
            case ORIENT_RIGHT_LEFT:
                result = new Point(-depth, breadth);
                break; 
            }
            
            _currentDrawing.setCartCoordinates(v, result); 
            
            /* recurse over the children */
            children = _stree.getChildren(v);
            for each(w in children) {
                secondWalk(w, m + _currentDrawing.getModifier(v));
            }
        }
        
        
        /**
         * @internal
         * Create a new layout drawing object, which is required
         * on any root change (and possibly during other occasions)
         * and intialise various parameters of the drawing.
         * */
        private function initModel():void {		
            _currentDrawing = null;
            _currentDrawing = new HierarchicalLayoutDrawing();
            /* set in super class */
            super.currentDrawing = _currentDrawing;
            
            //_currentDrawing.originOffset = _vgraph.origin;
        }
        
        
        /**
         * @internal
         * Returns a calculated spacing, that can take node size
         * into account.
         * @param l The left node.
         * @param r The right node.
         * */
        private function spacing(l:INode, r:INode):Number {
            
            var result:Number;
            result = _breadth;
            
            /* we assume that both INodes, l and r have a vnode and a view */
            if(_honorNodeSize) {
                switch(_orientation) {
                case ORIENT_LEFT_RIGHT:
                case ORIENT_RIGHT_LEFT:
                    result += 0.5 * (l.vnode.view.height + r.vnode.view.height);
                    break;
                case ORIENT_TOP_DOWN:
                case ORIENT_BOTTOM_UP:
                    result += 0.5 * (l.vnode.view.width + r.vnode.view.width);
                    break;
                default:
                    throw Error("Invalid orientation value found in internal variable");
                }
            }
            return result;
        }
        
        /**
         * @internal
         * do autofitting the layer distance. The node distance cannot
         * be pre-computed, so we leave it alone.
         * */
        protected function calculateAutoFit():void {
            
            if(_stree.maxDepth > 0) {
                switch(_orientation) {
                case ORIENT_LEFT_RIGHT:
                case ORIENT_RIGHT_LEFT:
                    _linkLength = (_vgraph.width - 2 * margin)  / _stree.maxDepth;
                    _breadth = (_vgraph.height - 2 * margin) / _stree.maxNumberPerLayer;
                    break;
                case ORIENT_TOP_DOWN:
                case ORIENT_BOTTOM_UP:
                    _linkLength = (_vgraph.height - 2 * margin)  / _stree.maxDepth;
                    _breadth = (_vgraph.width - 2 * margin) / _stree.maxNumberPerLayer;
                    break;
                default:
                    throw Error("Invalid orientation value found in internal variable");
                    
                }
            }
        }
        
        /**
         * Centers the diagram to the page
         */
        protected function centerDiagram():void {
            
            switch(_orientation) {
            case ORIENT_TOP_DOWN:
                _currentDrawing.centerOffset = 
                new Point( (_vgraph.width / 2), margin);
                break;
            
            case ORIENT_BOTTOM_UP:
                _currentDrawing.centerOffset =
                new Point( (_vgraph.width / 2), (_vgraph.height - margin) );
                break;
            
            case ORIENT_LEFT_RIGHT:
                _currentDrawing.centerOffset = 
                new Point(margin, (_vgraph.height/2) );
                break;
            
            case ORIENT_RIGHT_LEFT:
                _currentDrawing.centerOffset =
                new Point((_vgraph.width - margin), (_vgraph.height/2) );
                break;
            
            default:
                throw Error("Invalid orientation value found in internal variable");
            }
            
            _currentDrawing.centeredLayout = true;	
        }
    }
}
