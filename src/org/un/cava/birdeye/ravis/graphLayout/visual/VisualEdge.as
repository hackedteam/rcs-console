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
package org.un.cava.birdeye.ravis.graphLayout.visual {
    
    import flash.events.EventDispatcher;
    import flash.geom.Point;
    
    import mx.core.IDataRenderer;
    import mx.core.UIComponent;
    
    import org.un.cava.birdeye.ravis.graphLayout.data.IEdge;
    
    /**
     * A visual edge is just a representation of a graph edge
     * in the VisualGraph context. However, right now the only
     * feature a VisualEdge has is a reference to its Graph Edge
     * and a data object to support it's drawing features.
     * There is a small possibility that this class will be removed.
     * */
    public class VisualEdge extends EventDispatcher implements IVisualEdge, IDataRenderer {
        
        /* internal id of the edge */
        private var _id:int;
        
        /* VEdge data object, including data for drawing of the edge */
        private var _data:Object;
        
        /* we already link a graph edge with it */
        private var _edge:IEdge;
        
        /* the associated VGraph of this VEdge */
        private var _vgraph:IVisualGraph;
        
        /* visibility */
        private var _visible:Boolean;
        
        /* the associated label view if set */
        private var _labelView:UIComponent;
        
        /* the line style of the edge */
        private var _lineStyle:Object;
        
        /* instead of a left/top corner orientation
        * we can implicitly do a centered orientation 
        * this will be applied during the commit() method
        * and will be reversed during refresh() */
        private var _centered:Boolean;
        
        private var _edgeView:IEdgeRenderer;
        /**
         * The constructor initialiazes the edge and must be preset with almost
         * all parameters. 
         * @param vg The associated VisualGraph.
         * @param edge The associated Graph Edge.
         * @param id The internal id of this VisualEdge.
         * @param data The associated data Object.
         * @param lview The associated label view.
         * @param lStyle The line style of the edge, must be an object as associative mapping containing Graphics.lineStyle() parameters.
         * @see flash.display.Graphics.lineStyle()
         * */
        public function VisualEdge(vg:IVisualGraph, edge:IEdge, id:int, data:Object = null, lview:UIComponent = null, lStyle:Object = null) {
            _vgraph = vg;
            _edge = edge;
            _id = id;
            _visible = undefined;
            _centered = true;
            _data = data;
            _labelView = lview;
            _lineStyle = lStyle;
        }
        
        /**
         * Access to the associated Graph Edge.
         * */
        public function get edge():IEdge {
            return _edge;
        }
        
        /**
         * Access to the associated VisualGraph.
         * */
        public function get vgraph():IVisualGraph {
            return _vgraph;
        }
        
        /**
         * Access to the data object.
         * */
        [Bindable]
        public function get data():Object {
            return _data;
        }
        
        /**
         * @private
         * */
        public function set data(o:Object):void {
            _data = o;
        }
        
        /**
         * Access to the id of the VEdge
         * */
        public function get id():int {
            return _id;
        }
        
        /**
         * @inheritDoc
         * */
        public function get centered():Boolean {
            return _centered;
        }
        
        /**
         * @private
         * */
        public function set centered(c:Boolean):void {
            _centered = c;
        }
        
        
        /**
         * Access to the indicator if the node is currently
         * visible or not. If this is set to false, any
         * associated view will be removed in order to 
         * save resources.
         * */
        public function get isVisible():Boolean {
            return _visible;
        }
        
        /**
         * @private
         * */
        public function set isVisible(v:Boolean):void {
            _visible = v;
            
            /* set the views visibility, if we currently
            * have one */
            if(	_labelView != null) {
                _labelView.visible = v;
            }
        }
        
        /**
         * @inheritDoc
         * */
        public function get labelView():UIComponent {
            return _labelView;
        }
        
        /**
         * @private
         * */
        public function set labelView(lv:UIComponent):void {
            _labelView = lv;
        }
        
        /**
         * @inheritDoc
         * */
        public function setEdgeLabelCoordinates(p:Point):void {
            if(_labelView == null || p == null) 
            {
                return;
            }
            
            if(_labelView.width == 0 ||
               _labelView.height == 0)
            {
                _labelView.callLater(setEdgeLabelCoordinates,[p]);
                return;
            }
            
            if(_centered) {
                _labelView.x = p.x - (_labelView.width / 2.0);
                _labelView.y = p.y - (_labelView.height / 2.0);
            } else {
                _labelView.x = p.x;
                _labelView.y = p.y;
            }
            
        }
        
        /**
         * @inheritDoc
         * */
        public function set lineStyle(ls:Object):void {
            _lineStyle = ls;
        }
        
        /**
         * @private
         * */
        public function get lineStyle():Object {
            return _lineStyle;
        }
        
        public function get edgeView():IEdgeRenderer{
            return _edgeView;
        }
        
        public function set edgeView(value:IEdgeRenderer):void {
            _edgeView = value;
        }
        
    }
}