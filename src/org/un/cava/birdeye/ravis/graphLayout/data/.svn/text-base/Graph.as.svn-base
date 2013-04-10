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

package org.un.cava.birdeye.ravis.graphLayout.data {
    
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    
    import org.un.cava.birdeye.ravis.utils.LogUtil;
    
    /**
     * Graph implements a graph datastructure G(V,E)
     * with vertices V and edges E, except that we call the
     * vertices nodes, which is here more in line with similar
     * implementations. A graph may be associated with a 
     * VisualGraph object, which can visualize graph components
     * in Flash.
     * @see VisualGraph
     * @see Node
     * @see Edge
     * */
    public class Graph extends EventDispatcher implements IGraph {
        
        /**
         * The default XML tagname of an XML item that defines a node.
         * */
        public static const DEFAULTNAME_NODE:String = "Node";
        
        /**
         * The default XML tagname of an XML item that defines an edge.
         * */		
        public static const DEFAULTNAME_EDGE:String = "Edge";
        
        /**
         * The default XML attribute of an XML edge item that describes the from node.
         * */
        public static const DEFAULTNAME_FROMID:String = "fromID";
        
        /**
         * The default XML attribute of an XML edge item that describes the to node.
         * */
        public static const DEFAULTNAME_TOID:String = "toID";
        
        private static const _LOG:String = "graphLayout.data.Graph";
        
        /**
         * @internal
         * attributes of a graph
         * */
        protected var _id:String;
        
        protected var _xmlData:XML;
        
        protected var _nodes:Array;
        protected var _edges:Array;
        
        
        
        /* lookup by string id and by id */
        protected var _nodesByStringId:Object;
        protected var _nodesById:Object;
        
        /* indicator if the graph is directional or not */
        protected var _directional:Boolean;
        /* if directional we could have a walking direction for the
        * spanning tree */
        
        /** 
         * @internal
         * these two serve as id for nodes and
         * and edges the id's will start from 1 (not 0) !!
         * and are always increased.
         * */
        protected var _currentNodeId:int;
        protected var _currentEdgeId:int;
        
        /**
         * @internal
         * these two serve as count for nodes and edges
         * and are also decreased if nodes or edges
         * are removed
         * */
        protected var _numberOfNodes:int;
        protected var _numberOfEdges:int;
        
        /**
         * @internal
         * for several algorithms we might need
         * BFS and DFS implementations, all related
         * to a specific root node.
         * */
        protected var _treeMap:Dictionary;
        
        /**
         * @internal
         * Provide a function to be used for sorting the
         * graph items. This is used by GTree.
         * */
        protected var _nodeSortFunction:Function = null;
        
        /**
         * Constructor method that creates the graph and can
         * initialise it directly from an XML object, if one is specified.
         * 
         * @param id The id (or rather name) of the graph. Every graph has to have one.
         * @param directional Indicator if the graph is directional or not. Directional graphs have not been tested so far.
         * @param xmlsource an XML object that contains node and edge items that define the graph.
         * @param xmlnames an optional Array that contains XML tag and attribute names that define the graph. 
         * */
        public function Graph(id:String, directional:Boolean = false, xmlsource:XML = null) {
            if(id == null)
                throw Error("id string must not be null")
            if(id.length == 0)
                throw Error("id string must not be empty")
            
            _id = id
            
            _xmlData = xmlsource;
            
            _nodes = new Array;
            _edges = new Array;
            _treeMap = new Dictionary;
            
            _nodesByStringId = new Object;
            _nodesById = new Object;
            
            _directional = directional;
            _currentNodeId = 0;
            _currentEdgeId = 0;
            _numberOfNodes = 0;
            _numberOfEdges = 0;
            
            if(xmlsource != null) {
                //LogUtil.debug(_LOG, "Graph detected XML source:"+xmlsource.name().toString());
                initFromXML(xmlsource);
            }			
        }
        
        /**
         * A static factory method to create new graphs, but requires an xmlsource to be specified.
         * 
         * @param id The id (or rather name) of the graph. Every graph has to have one.
         * @param directional Indicator if the graph is directional or not. Directional graphs have not been tested so far.
         * @param xmlsource an XML object that contains node and edge items that define the graph.
         * @param xmlnames an optional Array that contains XML tag and attribute names that define the graph. 
         * @return the created Graph object (i.e. an object that implements the IGraph interface.
         * @throws Error of the xmlsource is null.
         **/
        public static function createGraph(id:String, directional:Boolean, xmlsource:XML):IGraph {
            if(xmlsource == null) {
                throw Error("the xmlsource must not be null if creating a new Graph");
            }
            
            return new Graph(id, directional, xmlsource);
        }
        
        /**
         * @inheritDoc
         * */
        public function get id():String {
            return _id;
        }		
        
        /**
         * @inheritDoc
         * */
        public function get xmlData():XML {
            return _xmlData;
        }
        
        /**
         * @inheritDoc
         * */
        public function get nodes():Array {
            return _nodes;
        }
        
        /**
         * @inheritDoc
         * */
        public function get edges():Array {
            return _edges;
        }
        
        /**
         * @inheritDoc
         * */
        public function get isDirectional():Boolean {
            return _directional;
        }
        
        /**
         * @inheritDoc
         * */
        public function get noNodes():int {
            return _numberOfNodes;
        }
        
        /**
         * @inheritDoc
         * */
        public function get noEdges():int {
            return _numberOfEdges;
        }
        
        /**
         * @inheritDoc
         * */
        public function set nodeSortFunction(f:Function):void {
            _nodeSortFunction = f;
        }
        
        /**
         * @private
         * */
        public function get nodeSortFunction():Function	{
            return _nodeSortFunction;
        }
        
        /**
         * @inheritDoc
         * */
        public function nodeByStringId(sid:String,caseSensitive:Boolean=true):INode {
            if(caseSensitive) {
                if(_nodesByStringId.hasOwnProperty(sid)) {
                    return _nodesByStringId[sid];
                } else {
                    return null;
                }
            } else {
                for (var ident:String in _nodesByStringId) {
                    if(ident.toLowerCase() == sid.toLowerCase()){
                        return _nodesByStringId[ident];
                    }
                }
                
                return null;
            }
        }
        
        /**
         * @inheritDoc
         * */
        public function nodeById(id:int):INode {
            if(_nodesById.hasOwnProperty(id)) {
                return _nodesById[id];
            } else {
                return null;
            }
        }
        
        /**
         * @inheritDoc
         * */
        public function getTree(n:INode,restr:Boolean = false, nocache:Boolean = false, direction:int=GTree.WALK_BOTH):IGTree{
            /* If nocache is set, we just return a new tree */
            if(nocache) {
                return new GTree(n,this,restr,direction);
            }
            
            if(!_treeMap.hasOwnProperty(n)) {
                _treeMap[n] = new GTree(n,this,restr,direction);
                /* do the init now, not lazy */
                (_treeMap[n] as IGTree).initTree();
            }
            return (_treeMap[n] as IGTree);
        }
        
        /**
         * @inheritDoc
         * */
        public function purgeTrees():void {
            _treeMap = new Dictionary;
        }
        
        /**
         * @inheritDoc
         * */
        public function initFromXML(xml:XML):void {
            
            var nodeName:String = DEFAULTNAME_NODE;
            var edgeName:String = DEFAULTNAME_EDGE;
            var fromIDName:String = DEFAULTNAME_FROMID;
            var toIDName:String = DEFAULTNAME_TOID;
            
            var xnode:XML;
            var xedge:XML;
            
            var fromNodeId:String;
            var toNodeId:String;
            
            var fromNode:INode;
            var toNode:INode;
            
            //LogUtil.debug(_LOG, "initFromXML called");
            
            for each(xnode in xml.descendants(nodeName)) {
                /* we add the xml node id as string id and the xml
                * node data as data object */
                fromNode = createNode(xnode.@id, xnode);
                //LogUtil.debug(_LOG, "Node:"+fromNode.stringid+" created, total:"+_nodes.length);
            }
            
            for each(xedge in xml.descendants(edgeName)) {
                fromNodeId = xedge.attribute(fromIDName);
                toNodeId = xedge.attribute(toIDName);
                
                fromNode = nodeByStringId(fromNodeId);
                toNode = nodeByStringId(toNodeId);
                
                /* we do not throw an error here, because the data
                * is often inconsistent. In this case we just ignore
                * the edge */
                if(fromNode == null) {
                    LogUtil.warn(_LOG, "Node id: "+fromNodeId+" not found, link not done");
                    continue;
                }
                if(toNode == null) {
                    LogUtil.warn(_LOG, "Node id: "+toNodeId+" not found, link not done");
                    continue;
                }
                link(fromNode,toNode,xedge);
                //LogUtil.warn(_LOG, "Current nr of edges:"+_edges.length);
            }
        }
        
        
        /**
         * @inheritDoc
         * */
        public function createNode(sid:String = "", o:Object = null):INode {
            
            /* we allow to pass a string id, e.g. it can originate
            * from the XML file.*/
            
            var myid:int = ++_currentNodeId;
            var mysid:String = sid;
            var myNode:Node;
            var myaltid:int = myid;
            
            if(mysid == "") {
                mysid = myid.toString();
            }
            
            /* avoid using a duplicate string id */
            while(_nodesByStringId.hasOwnProperty(mysid)) {
                LogUtil.warn(_LOG, "sid: "+mysid+" already in use, trying alternative");
                mysid = (++myaltid).toString();
            }
            
            /* 
            * see below when we link nodes, we cannot yet 
            * set the visual counterpart, but we have setter/getters
            * for the attribute, have to consider which
            * component must be created first
            * consider also to just pass it to the abstract graph
            * but more likely, we initialise the abstract graph
            * from a graphML XML file, when it is there, then we build
            * all the visual objects 
            */
            
            myNode = new Node(myid,mysid,null,o);
            
            _nodes.unshift(myNode);
            _nodesByStringId[mysid] = myNode;
            _nodesById[myid] = myNode;
            ++_numberOfNodes;
            
            /* a new node means all potentially existing
            * trees in the treemap need to be invalidated */
            purgeTrees()
            
            return myNode;
        }
        
        /**
         * @inheritDoc
         * */
        public function removeNode(n:INode):void {
            /* we check if inEdges or outEdges
            * are not empty. This also works for
            * non directional graphs, even though one
            * comparison would be sufficient */
            if(n.inEdges.length != 0 || n.outEdges.length != 0) {
                throw Error("Attempted to remove Node: "+n.id+" but it still has Edges");
            } else {
                /* XXXX searching like this through arrays takes
                * LINEAR time, so at one point we might want to add
                * associative arrays (possibly Dictionaries) to map
                * the objects back to their index... */
                var myindex:int = _nodes.indexOf(n);
                
                /* check if node was not found */
                if(myindex == -1) {
                    throw Error("Node: "+n.id+" was not found in the graph's" +
                        "node table while trying to delete it");
                }
                
                // HMMM we assume that the throw will abort the script
                // but I am not sure, we'll see
                //LogUtil.debug(_LOG, "PASSED Check for node in _node list");
                
                /* remove node from list */
                _nodes.splice(myindex,1);
                --_numberOfNodes;
                
                
                delete _nodesByStringId[n.stringid];
                delete _nodesById[n.id];
                
                /* we need to do something about vnodes */
                if(n.vnode != null) {
                    throw Error("Node is still associated with its vnode, this leaves a dangling reference and a potential memory leak");
                }
                
                /* node should have no longer a reference now
                * so the GarbageCollector will get it */
                
                /* invalidate trees */
                purgeTrees()
            }
        }
        
        /**
         * @inheritDoc
         * */
        public function link(node1:INode, node2:INode, o:Object = null):IEdge {
            
            var retEdge:IEdge;
            
            if(node1 == null) {
                throw Error("link: node1 was null");
            }
            if(node2 == null) {
                throw Error("link: node2 was null");
            }
            
            /* check if a link already exists */
            if(node1.successors.indexOf(node2) != -1) {
                /* we should give an error message, but
                * there is no need to abort the script
                * we should just do nothing */
                LogUtil.warn(_LOG, "Link between nodes:"+node1.id+" and "+
                    node2.id+" already exists, returning existing edge");
                
                /* oh in fact, we should return the edge that was found 
                * this was more complicated than I thought and I am
                * not tooo happy with this way...
                * also it might not always find the edge if graph is non-directional
                * as most graphs are. The edge found could be the other way round.
                * Have to use the "othernode()" method here.
                */
                var outedges:Array = node1.outEdges;
                for each (var edge:Edge in outedges) {
                    if(edge.othernode(node1) == node2) {
                        retEdge = edge;
                        break;
                    }
                }
                if(retEdge == null) {
                    throw Error("We did not find the edge although it should be there");
                }
            } else {
                // link does not exist, so we can create it
                var newEid:int = ++_currentEdgeId;
                /* not sure where we will be able to set the visual edge
                * as it must exist first, for now we pass null 
                * since the attribute has also a setter */
                var newEdge:Edge = new Edge(this,null,newEid,node1,node2,o);
                _edges.unshift(newEdge);
                ++_numberOfEdges;
                
                /* now register the edge with its nodes */
                node1.addOutEdge(newEdge);
                node2.addInEdge(newEdge);
                
                /* if we are a NON directional graph we would have
                * to add another edge also vice versa (in the other
                * direction), but that leaves us with the question
                * which of the edges to return.... maybe it can be
                * handled using the same edge, if the in the directional
                * case, the edge returns always the other node */
                //LogUtil.debug(_LOG, "Graph is directional? "+_directional.toString());
                if(!_directional) {
                    node1.addInEdge(newEdge);
                    node2.addOutEdge(newEdge);
                    //LogUtil.debug(_LOG, "graph is not directional adding same edge:"+newEdge.id+
                    //" the other way round");
                }
                retEdge = newEdge;
            }
            
            /* invalidate trees */
            purgeTrees()
            return retEdge;
        }
        
        /**
         * @inheritDoc
         * */
        public function unlink(node1:INode, node2:INode):void {
            
            /* find the corresponding edge first */
            var e:IEdge;
            
            e = getEdge(node1,node2);
            
            if(e == null) {
                throw Error("Could not find edge, Nodes: "+node1.id+" and "
                    +node2.id+" may not be linked.");
            } else {
                removeEdge(e);
            }
        }
        
        /**
         * @inheritDoc
         * */
        public function getEdge(n1:INode, n2:INode):IEdge {
            var outedges:Array = n1.outEdges;
            var e:IEdge = null;
            for each (var edge:Edge in outedges) {
                if(edge.othernode(n1) == n2) {
                    e = edge;
                    return e;
                }
            }
            return null;
        }
        
        /**
         * @inheritDoc
         * */
        public function removeEdge(e:IEdge):void {
            var n1:INode = e.node1;
            var n2:INode = e.node2;
            var edgeIndex:int = _edges.indexOf(e);
            
            if(edgeIndex == -1) {
                throw Error("Edge: "+e.id+" does not seem to exist in graph "+_id);
                // here we would need to abort the script
            }
            
            n1.removeOutEdge(e);
            n2.removeInEdge(e);
            
            /* if we are NOT directed, we also 
            * have to remove the other way round */
            if(!_directional) {
                n1.removeInEdge(e);
                n2.removeOutEdge(e);
            }
            
            /* now remove from the list of edges */
            _edges.splice(edgeIndex,1);
            --_numberOfEdges;
            
            /* invalidate trees */
            purgeTrees()
        }
        
        /**
         * @inheritDoc
         * */
        public function purgeGraph():void {
            
            while(_edges.length > 0) {
                removeEdge(_edges[0]);
            }
            
            while(_nodes.length > 0) {
                removeNode(_nodes[0]);
            }
            purgeTrees();
        }						
    }
}
