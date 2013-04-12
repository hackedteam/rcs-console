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
	/**
	 * This class represents a spanning
	 * tree, rooted in the given root node
	 * of the connected component of the
	 * associated graph.
	 * <p>
	 * It stores the predecessors of each node
	 * to allow the traversal
	 * and also the distance of each node to the
	 * root.
	 * </p>
	 * */
	public class GTree extends EventDispatcher implements IGTree {
		
		private static const _LOG:String = "graphLayout.data.GTree";
		
        /**
         * If building a spanning tree, walk only forward.
         * */
        public static const WALK_FORWARDS:int = 0;
        
        /**
         * If building a spanning tree, walk only backwards.
         * */
        public static const WALK_BACKWARDS:int = 1;
        
        /**
         * If building a spanning tree, walk only both
         * directions
         * */
        public static const WALK_BOTH:int = 2;
        
        protected var _walkingDirection:int = WALK_BOTH;
        
		protected var _graph:IGraph;
		protected var _root:INode;

		/* max depth of the tree */
		protected var _maxDepth:int = 0;
		
		/* the following are indexed by node objects */
		protected var _parentMap:Dictionary;
		protected var _childrenMap:Dictionary;
		protected var _distanceMap:Dictionary;
		
		/* this is indexed by a distance value and stores
		 * the number of nodes with that distance. Since this
		 * is compact it can be an array */
		protected var _amountNodesWithDistance:Array;
		
		/* this is the maximum of nodes that are in a certain distance */
		protected var _maxNumberPerLayer:uint;
		
		/* for some algorithms
		 * we also need to establish a specific order, i.e.
		 * for each node to know that it is the 'i'th child
		 * and it has m siblings */
		protected var _nodeChildIndexMap:Dictionary;
		protected var _nodeNoChildrenMap:Dictionary;

		/* in some cases we rather build a tree
		 * that is restriced to the _visible_ nodes
		 * we create a flag for that, which has to be
		 * set in the constructor */
		protected var _restrictToVisible:Boolean;
		
		/* this stores the leaf nodes*/
		protected var _nodesWithoutLinkToNextLevel:Dictionary;

		/**
		 * Constructor to create a new GTree object, the tree will not immediately
		 * be initialised, but this will happen as soon as any attributes or methods
		 * are accessed, that require the tree to be initialised (late initialisation).
		 * @param root The root node of the tree.
		 * @param graph The graph that this tree is a subset of.
		 * @param restrict A flag to indicate that the resulting tree should be restricted to currently invisible nodes.
		 * */
		public function GTree(root:INode, graph:IGraph, restrict:Boolean = false, direction:int = GTree.WALK_BOTH) {
			_parentMap = null;
			_childrenMap = null;
			_distanceMap = null;
			_nodeChildIndexMap = null;
			_nodeNoChildrenMap = null;
			_amountNodesWithDistance = null;
			
            _walkingDirection = direction;
            
			_maxNumberPerLayer = 0;
			
			_root = root;
			_graph = graph;
			
			_maxDepth = 0;
			
			_restrictToVisible = restrict;
		}

		/**
		 * @inheritDoc
		 * */ 
		public function get restricted():Boolean {
			return _restrictToVisible;
		}

		/**
		 * @inheritDoc
		 * */ 
		public function get parents():Dictionary {
			/* we make sure to initialise here */
			if(_parentMap == null) {
				initTree();
			}
			return _parentMap;
		}

		/**
		 * @inheritDoc
		 * */ 
		public function get distances():Dictionary {
			if(_distanceMap == null) {
				initTree();
			}
			return _distanceMap;
		}

		/**
		 * @inheritDoc
		 * */ 
		public function get maxDepth():int {
			return _maxDepth;
		}

		/**
		 * @inheritDoc
		 * */ 
		public function get root():INode {
			return _root;
		}
		/**
		 * @private
		 * */
		public function set root(r:INode):void {
			_root = r;
			/* we need to invalidate if we change the root */
			initMaps();
		}
		
		public function get maxNumberPerLayer():uint {
			return _maxNumberPerLayer;
		}
        
        /**
         * @inheritDoc
         * */
        public function set walkingDirection(d:int):void {
            _walkingDirection = d;
        }
        
        /**
         * @private
         * */
        public function get walkingDirection():int {
            return _walkingDirection;
        }
		
		
		/**
		 * @inheritDoc
		 * */
		public function get XMLtree():XML {
			var resXML:XML;
			var nxml:XML;
			var pxml:XML;
			var children:Array;
			var queue:Array;
			var nodeToXML:Dictionary;
			var i:uint;
			var n:INode;
			var p:INode;
			
			/* make sure tree is initialised */
			if(_childrenMap == null) {
				initTree();
			}	
			
			queue = new Array;
			nodeToXML = new Dictionary;
			
			/* the root object will be the corresponding item of the root node */
			resXML = new XML(_root.data);
			pxml = resXML;
			nodeToXML[_root] = pxml;
			queue.unshift(_root);
			
			/* work on the children */
			while(queue.length > 0) {
				p = queue.pop();
				pxml = nodeToXML[p];
				children = (_childrenMap[p] as Array);
				for(i=0;i<children.length;++i) {
					n = (children[i] as INode);
					nodeToXML[n] = new XML(n.data);
					pxml.appendChild(nodeToXML[n]);
					if(_nodeNoChildrenMap[n] > 0) {
						queue.unshift(n);
					}
				}
			}
			return resXML;	
		}
		
		
		
		/**
		 * @inheritDoc
		 * */ 
		public function getDistance(n:INode):int {
			if(_distanceMap == null) {
				initTree();
			}
			return _distanceMap[n];
		}
		
		
		 
		/**
		 * @inheritDoc
		 * */ 
		public function getChildIndex(n:INode):int {
			if(_nodeChildIndexMap == null) {
				initTree();
			}
			return _nodeChildIndexMap[n];
		}
		
		/**
		 * @inheritDoc
		 * */ 
		public function getNoChildren(n:INode):int {
			if(_nodeNoChildrenMap == null) {
				initTree();
			}
			return _nodeNoChildrenMap[n];
		}
		
		/**
		 * @inheritDoc
		 * */ 
		public function getChildren(n:INode):Array {
			if(_childrenMap == null) {
				initTree();
			}
			return (_childrenMap[n] as Array);
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function getNodesWithoutLinkToNextLevel():Array {
			var retVal:Array = new Array();
			for each(var node:INode in _nodesWithoutLinkToNextLevel)
			{
				retVal.push(node);
			}
			return retVal;;
		}
		
		/**
		 * @inheritDoc
		 * 
		 * @internal
		 * this basically calls the number of children
		 * from the node's parent, if it has a
		 * parent. It not it is the root node and
		 * that is currently considered to have no
		 * other siblings but itself, so 1 is returned
		 * */
		public function getNoSiblings(n:INode):int {
			var p:INode;
			
			if(_parentMap == null) {
				initTree();
			}
			
			p = this.parents[n];
			if(p == null) {
				return 1;
			} else {
				return this.getNoChildren(p);
			}
		}
		
		/**
		 * @inheritDoc
		 * */
		public function areSiblings(n:INode, m:INode):Boolean {
			/* get the parent of each node and test if they are the same */
			return (this.parents[n] == this.parents[m]);
		}
		
		/**
		 * @inheritDoc
		 * */ 
		public function getIthChildPerNode(n:INode,i:int):INode {
			if(_childrenMap == null) {
				initTree();
			}
			if(_childrenMap[n] == null) {
				throw Error("no childmap for node n:"+n.id);
			}
			return _childrenMap[n][i];
		} 
		
		/**
		 * @inheritDoc
		 * */ 
		public function initTree():Dictionary {
			
			var queue:Array = new Array();
			
			/* we create this as a dummy parent node, but it should
			 * never be accessed */
			var dummyParent:INode = new Node(0,"dummyNode",null,null);

			var u:INode,v:INode;
			var i:int,j:int;
			var childcount:int;
			
			//LogUtil.debug(_LOG, "initTree1: walking tree with root:"+_root.id);
			initMaps();

			/* root is the 1st child (i.e. 0th) and an only child */
			setValues(_root, dummyParent, 0, 0);
			
			queue.push(_root);
			
			while(queue.length > 0) {
				
				/* pop() may lead to a wrong BFS search, more DFS
				 * may need to use shift() instead */
				//u = (queue.pop() as INode);
				u = (queue.shift() as INode);
				
				/* this should not have an effect, but we'll see */
				if(_restrictToVisible && !u.vnode.isVisible) {
					continue;
				}
				
				//LogUtil.debug(_LOG, "initTree2: queue node:"+u.id+" has successors:"+u.successors.toString());
				
				// here we could check if we want the node
				childcount = 0;
				var nodesToWalk : Array = null
				switch(walkingDirection)
				{
					case WALK_FORWARDS:
						nodesToWalk = u.successors
						break
					case WALK_BACKWARDS:
						nodesToWalk = u.predecessors
						break
					case WALK_BOTH:
						nodesToWalk = u.successors.concat(u.predecessors)
						break
					default:
						throw Error("unknown graph walking direction")
				}
				for each(var adjacentNode:INode in nodesToWalk) {
					v = adjacentNode
					
					/* here we check if the child vnode is visible
					 * and if not, not take it into account */
					if(_restrictToVisible && !v.vnode.isVisible) {
						continue;
					}
					
					//LogUtil.warn(_LOG, "initTree3: working on successor index:"+j+
					//" which is node:"+v.id+" and has current parent:"+_parentMap[v]);
					
					/* check if visited before */
					if(_parentMap[v] == null) {
						/*
						 * v is the child of u, meaning in the successor list
						 * of u, but that does not mean it is the
						 * i'th child in terms of the tree
						 * the Number of all children is yet unknown ....
						 */
					
						setValues(v,u,_distanceMap[u] + 1,childcount);
						
						queue.push(v);
						
						++childcount; // we have to increase here (i.e. after setValues)
						//LogUtil.debug(_LOG, "initTree4 added node:"+v.id+" with distance:"+_distanceMap[v]);
					}
				}
				/* only here we now know the number of childen
				 * in childcount so we need to set it here */
				_nodeNoChildrenMap[u] = childcount;
			}
			
			for each(var node:INode in _graph.nodes) {
				var linksToNextLevel:Boolean = false;
				
				var level:Number = _distanceMap[node];
				for each(var n2:INode in node.successors) {
					if(level < _distanceMap[n2]) {
						linksToNextLevel = true;
						break;
					}
				}
				
				if(linksToNextLevel) {
					continue;
				}
				
				for each(var n3:INode in node.predecessors) {
					if(level < _distanceMap[n3]) {
						linksToNextLevel = true;
						break;
					}
				}
				
				if(linksToNextLevel == false) {
					_nodesWithoutLinkToNextLevel[node] = node;
				}
			}
			
			/* reset the dummy to null */
			_parentMap[_root] = null;
			
			/* sort the children if we have a nodeSortFunction
			 * set in the Graph object */
			nodeSortChildren();
			
			return _parentMap;
		}
		
		/**
		 * @inheritDoc
		 * */ 
		public function getLimitedNodes(limit:int):Dictionary {
			var result:Dictionary = new Dictionary;
			var key:Object;
			var on:INode;
		
			if(_distanceMap == null) {
				initTree();
			}
			
			/* walk the nodes in the distance Map and
			 * include all which have a distance not too big 
			 */			
			for(key in _distanceMap) {
				on = (key as INode);
				if(_distanceMap[on] <= limit) {
					/* we use the same stringid as the original node
					 * but it is in fact a copy */
					//LogUtil.debug(_LOG, "getLimitedNodes: adding node id:"+on.id);
					result[on] = on;
				}
			}
			return result;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function getNumberNodesWithDistance(d:uint):uint {
			if(_amountNodesWithDistance == null) {
				initTree();
			}
			if(_amountNodesWithDistance[d] == null) {
				return 0;
			} else {
				return _amountNodesWithDistance[d];
			}
		}
		
		/**
		 * @internal
		 * Initialises all the maps, throwing away old values. 
		 * */
 		protected function initMaps():void {				
			_parentMap = new Dictionary;
			_childrenMap = new Dictionary;
			_distanceMap = new Dictionary;
			_nodesWithoutLinkToNextLevel = new Dictionary();
			
			_amountNodesWithDistance = new Array;
			
			_nodeChildIndexMap = new Dictionary;
			_nodeNoChildrenMap = new Dictionary;
		
			_maxNumberPerLayer = 0;
		
			_maxDepth = 0;
		
			/* init the parent Map with null parents 
			 * XXX maybe this is redundant.... */
			for(var i:int=0; i<_graph.noNodes; ++i) {
				_parentMap[_graph.nodes[i]] = null;
				
			}
		}
		
		/**
		 * @internal
		 * This method checks for an existing nodeSortFunction
		 * in the Graph object and applies it to the
		 * entries in the childrenMap.
		 * 
		 * This method was provided by Ivan Bulanov and
		 * his team. 
		 * */
		protected function nodeSortChildren():void {
			var children:Array;
			var childIndex:int;
			
			/* only act if a function is present */
			if(_graph.nodeSortFunction != null) {
				for each(children in _childrenMap){
					/* sort the array */
					children.sort(_graph.nodeSortFunction);
					/* update the childIndexMap */
					for(childIndex = 0; childIndex < children.length; ++childIndex) {
						_nodeChildIndexMap[children[childIndex]] = childIndex;
					}
				}
			}
		}
		
		/**
		 * @internal
		 * Helper function to set various map values in one go
		 * @param n The current node.
		 * @param p The parent node of n.
		 * @param d The distance of node n from the root.
		 * @param cindex The child index of node n among p's children.
		 * */ 
		protected function setValues(n:INode, p:INode, d:Number, cindex:int):void {
		
			var childarray:Array;
		
			_parentMap[n] = p;
			_distanceMap[n] = d;
		
			/* increase the count of nodes with that distance */
			if(_amountNodesWithDistance[d] == null) {
				_amountNodesWithDistance[d] = 0;
			}
			++_amountNodesWithDistance[d];
			
			/* update the maximum */
			_maxNumberPerLayer = Math.max(_maxNumberPerLayer, _amountNodesWithDistance[d]);
		
			_nodeChildIndexMap[n] = cindex;

			/* update the maxDepth which is also the max distance 
			 * from the root obviously */
			_maxDepth = Math.max(_maxDepth, d);

			/* add n as the child of p in its children map */
			if(_childrenMap[p] == null) {
				_childrenMap[p] = new Array;
			}
			
			_childrenMap[p][cindex] = n;
			
			//LogUtil.debug(_LOG, "added child:"+_childrenMap[p][cindex]+" of node:"+p.id+" to its map at index:"+cindex);
			//LogUtil.debug(_LOG, "GTreeSetValues: set node:"+n.id+" as "+cindex+" child of parent:"+p.id);
			//LogUtil.debug(_LOG, "GTreeSetValues: with key:"+p.id.toString()+"_"+cindex.toString());
		}
	}
}
