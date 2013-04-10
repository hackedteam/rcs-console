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
	import org.un.cava.birdeye.ravis.utils.Geometry;
	import org.un.cava.birdeye.ravis.utils.LogUtil;
	
	/**
	 * This is an implementation of the 
	 * parent centered radial layouter
	 * as described in the 2006 paper by
	 * Andy Pavlo, Christopher Homan and Jon Schull. It is not
	 * yet working perfectly. 
	 * */
	public class ParentCenteredRadialLayouter
		extends AnimatedBaseLayouter
		implements IAngularLayouter {
		
		private static const _LOG:String = "graphLayout.layout.ParentCenteredRadialLayouter";
		
		/* if we change phi we cannot set it directly
		 * in the drawing mode, because we throw it away
		 * and build a new one, so we need it here */
		private var _phi:Number = 90;
		private var _rootR:Number = 10;
		
		/* the queue for the BFS style walk through the calculation */
		private var _nodequeue:Array = null;
		
		/* this holds the data for the ParentCentered layout drawing */
		private var _currentDrawing:ParentCenteredDrawingModel;
		/**
		 * The constructor only initialises some data structures.
		 * @inheritDoc
		 * */
		public function ParentCenteredRadialLayouter(vg:IVisualGraph = null) {
			super(vg);
			animationType = ANIM_RADIAL; // inherited
			initModel();
		}

		/**
		 * @inheritDoc
		 * */
		override public function resetAll():void {			
			
			super.resetAll();
			
			_nodequeue = null;
			_stree = null;
			_graph.purgeTrees();
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
			var children:Array;
			
			//LogUtil.info(_LOG, "layoutPass called");
			
			if(!_vgraph) {
				LogUtil.warn(_LOG, "No Vgraph set in PCRLayouter, aborting");
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
			
					
			/* establish the spanning tree, restricted to visible nodes */
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
			if(_layoutChanged) {
				initModel();
			}

			/* this is complicated. */
			if(_autoFitEnabled) {
				/* first we do a regular calculation */
				calculateNodes();
				
				/* now we calculate the best rootR
				 * from the existing model calculation */
				calculateAutoFit();
				
				/* then we reinit the model to have a clean
				 * one with new rootR */
				initModel();
				 
				/* then outside of this clause we do the real
				 * calculation */
			}

			/* do a calculation pass */
			calculateNodes()
		
			/* reset animation cycle */
			resetAnimation();
			
			/* start the animation, does also the commit */
			startAnimation();		
		
			_layoutChanged = true;
			return true;
		}
	
		/**
		 * @inheritDoc
		 * */
		[Bindable]
		override public function get linkLength():Number {
			return _rootR / 5;
		}
		/**
		 * @private
		 * */
		override public function set linkLength(rr:Number):void {
			_rootR = rr * 5;
		}
		
		/**
		 * Access to the preset of the starting angle of the layout
		 * */
		[Bindable]
		public function get phi():Number {
			return _phi
		}
		/**
		 * @private
		 * */
		public function set phi(p:Number):void {
			_phi = p;
		}
		
		/* private methods */
		 
		/**
		 * @internal
		 * Create a new layout drawing object, which is required
		 * on any root change (and possibly during other occasions)
		 * and intialise various parameters of the drawing.
		 * */
		private function initModel():void {		
			_currentDrawing = null;
			_currentDrawing = new ParentCenteredDrawingModel();
			
			/* set in super class */
			super.currentDrawing = _currentDrawing;
			
			_currentDrawing.originOffset = _vgraph.origin;
			_currentDrawing.centerOffset = _vgraph.center;
			_currentDrawing.centeredLayout = true;
			(_currentDrawing as ParentCenteredDrawingModel).phi = _phi;
			(_currentDrawing as ParentCenteredDrawingModel).rootR = _rootR;
			//LogUtil.debug(_LOG, "New Model with phi:"+_phi+" and origin:"+_currentDrawing.originOffset.toString());
		}
		
		
		/**
		 * @internal
		 * Initialize the node queue and then recurse
		 * the node calculation. */
		private function calculateNodes():void {
			/* init/reset the node queue */
			_nodequeue = new Array();

			/* push the root into the array */
			_nodequeue.unshift(_root);

			/* start the calculation */
			calculateNodesRecursion();
		}
		
		
		
		/**
		 * @internal
		 * Walk the tree again in a BFS manner to process all nodes.
		 * This relys on the nodequeue, which has to at least
		 * be initialised with the root node. */
		private function calculateNodesRecursion():void {
			
			var n:INode;
			var c:INode;
			var children:Array;
			
			/* pop the first node from the queue, in
			 * the first iteration this should be the root
			 */
			n = (_nodequeue.pop() as INode);
			
			/* if the queue was empty, we are done */
			if(n == null) {
				return;
			}
			
			//LogUtil.debug(_LOG, "popped node:"+n.id+" from queue, working on it");
			
			/* first process the node */
			processNode(n);
			
			/* now get the nodes children */
			children = _stree.getChildren(n);
			
			/* add the children to the end of the _nodequeue
			 * if it is visible */
			for each(c in children) {
				if(c.vnode.isVisible) {
					_nodequeue.unshift(c);
					//LogUtil.debug(_LOG, "added node:"+c.id+" to nodequeue");
				}
			}
			
			/* recurse, this should to until there are no
			 * more children left */
			calculateNodesRecursion();
		}
		
		
		/**
		 * @internal
		 * calculate the coordinates of a node, Requires all nodes in the
		 * parental level to be calculated.
		 * @param vi The current node to inspect v_i
		 * @param i the child index of the current node (beware this starts with 0)
		 * @param m the number of all children of the node's parent
		 * */
		private function processNode(vi:INode):void {
			
			var vp:INode;        // parent node of vi
			var vs:INode;        // the next sibling of the parent
			var vgp:INode;       // grandparent of vi (parent of vp)
			var i:int;			 // childindex of vi
			var m:int;			 // number of siblings (including vi) of vi
			var mp:int;          // the number of siblings (m) of the parent node
			var ip:int;          // child index (i) of parent node
			var delta:Number;    // the angle between two siblings polar coordinates
			var angle1:Number; 	 // angle
			var angle2:Number; 	 // angle
			var lrgangle:Number; 	 // the larger of two angles
			var smlangle:Number; 	 // the smaller of two angles
			var vpcoords:Point;  // parent point
			var vgpcoords:Point; // grandparent point
			var vscoords:Point;  // parent sibling point
			var magnitude:Number; // diameter of a node's view to measure occupied space.
			
			/* the following are variables to be set in a drawing */
			var nodeOrigin:Point;
			var zeroAngleOffset:Number;
			var nodePolarR:Number;
			var nodePolarPhi:Number;
			
			/* needed for the calculation */
			var intersection:Point
			var phi:Number;

			i = _stree.getChildIndex(vi);
			m = _stree.getNoSiblings(vi);

		
			/* some sanity checks */
			if(i < 0) {
				throw Error("i was < 0");
			}
			if(m < 1) {
				throw Error("m was < 1");
			}
			if(vi == null) {
				throw Error("Node was null");
			}
			
			/* all nodes here should be visible, but we check it anyway */
			if(!vi.vnode.isVisible) {
				throw Error("found invisible node in recursion function, which should not happen");
			}

			
			//LogUtil.debug(_LOG, "RecurseCC1: called");
			
			if(vi == _root) {
				
				//LogUtil.debug(_LOG, "RecurseCC2: node:"+vi.id+" is root, setting all to 0");
				
				/* if we are the root node we set the
				 * static parameters of the root node */
				nodeOrigin = new Point(0,0);
				zeroAngleOffset = 0.0;
				nodePolarR = 0.0;
				nodePolarPhi = 0.0;
	
				/* set the values, this should apply the origin and zero-angle
				 * offset to the cartesian coordinates */			
				_currentDrawing.
					setNodeCoordinates(vi,nodeOrigin,zeroAngleOffset,nodePolarR,nodePolarPhi);
				return;
			}
			
			
			/* else the node has a parent */
			vp = _stree.parents[vi];

			/* make sure it is the case */
			if(vp == null) {
				throw Error("Found non-root node without parent");
			}
			
			//LogUtil.debug(_LOG, "RecurseCC3: node:"+vi.id+" is NOT root, got parent:"+vp.id);
			
			/* we would now check if we already have
			 * the data of the parent node (in this case the root)
			 * and if not, we call this function (i.e. recurse)
			 * the other values on the model are Numbers, so we would
			 * need to check if the map has the key at all ....
			 */
			if(!_currentDrawing.nodeDataValid(vp)) {
				/* RECURSE upward, but should not happen */
				//LogUtil.debug(_LOG, "RecurseCC4: recursing with parent node:"+vp.id+" (current node:"+vi.id+")");
				//recurseCoordinateCalculation(vp,_stree.getChildIndex(vp),_stree.getNoSiblings(vp));
				throw Error("Parent node data invalid, this should not have happened");
			}
			
			//LogUtil.debug(_LOG, "RecurseCC5: node:"+vi.id+"'s parent:"+vp.id+" has values");
			
			/* now if the parent (v) is the root, i.e. we have
			 * a tier-1 node we are still in a special case */
			if(vp == _root) {
								
				//LogUtil.debug(_LOG, "RecurseCC6: node:"+vi.id+"'s parent:"+vp.id+" is ROOT, applying special values");
								
				nodeOrigin = (_currentDrawing as ParentCenteredDrawingModel).getNodeOrigin(vp);
				zeroAngleOffset = _currentDrawing.getAngleOffset(vp);
				
				nodePolarR = _currentDrawing.rootR // this is the initial user defined value
				
				/* remember we use degrees now, not radians */
				nodePolarPhi = (360 * (i+1) / m); // have to adjust for index starting with 0 instead of 1
				
				//LogUtil.debug(_LOG, "RecurseCC6.1: node:"+vi.id+" gets rootR:"+nodePolarR);
				
				/* set the values */				
				_currentDrawing.
					setNodeCoordinates(vi,nodeOrigin,zeroAngleOffset,nodePolarR,nodePolarPhi);
				return;
			}
			
			//LogUtil.debug(_LOG, "RecurseCC7: node:"+vi.id+"'s parent:"+vp.id+" is NOT root, calculating..");
			
			/* now we use a regular node, again here we have 
			 * two cases, depending on if the node has 
			 * siblings or not but the origin references
			 * will be the same regardless */
			
			/* origin will be the coordinates of the parent, but
			 * those are relative to the parents origin
			 * so we already need to apply the origin offset
			 * so that we can be sure all the origins are already
			 * absolute */
			 
			nodeOrigin = _currentDrawing.getRelCartCoordinates(vp);
			
			/* first get a grandparent, there should be one
			 * because we are in the case where the parent is not root */
			vgp = _stree.parents[vp];
			if(vgp == null) {
				throw Error("Node vi:"+vi.id+" with parent:"+vp.id+" has no grandparent but should have");
			}
			
			vgpcoords = _currentDrawing.getRelCartCoordinates(vgp);
			vpcoords = _currentDrawing.getRelCartCoordinates(vp);
			
			//LogUtil.debug(_LOG, "Node:"+vi.id+" has parent:"+vp.id+" and grandparent:"+vgp.id);
			
			/* big issue here is that the y axis direction is reversed
			 * that means the sign of the y.coordinates is probably
			 * reversed either, we try to compensate by changing the subtrating
			 * order of the y coordinates */
			zeroAngleOffset = Geometry.rad2deg(Math.atan2(vpcoords.y - vgpcoords.y, vgpcoords.x - vpcoords.x));
			
			/* the polar angle is also independent of the 
			 * number of siblings
			 * calculated according to the formula */
			phi = _currentDrawing.phi;
			
			//LogUtil.debug(_LOG, "RecurseCC7.1: node:"+vi.id+" gets phi:"+phi);
			
			/* new reasoning */
			if(m == 1) {
				nodePolarPhi = 180;
			} else {
				nodePolarPhi = 180 - (phi / 2.0) + (phi * i / (m-1));
			} 
		
			//LogUtil.debug(_LOG, "RecurseCC7.2: node:"+vi.id+" with: i:"+i+" and m:"+m+" gets Polarphi:"+nodePolarPhi);	
				
			/* if the node has no siblings, m must be 1
			 * the magnitude of the parent is what? Maybe
			 * the r of the parent, which is then halved?
			 * XXXX
			 * MAGNITUDE probably refers to the "importance" in terms
			 * of social networking, which is often visualised
			 * by having a direct impact to the node's size.
			 * we do not use that, all nodes are created equal, so we
			 * could choose this factor to fit our needs
			 * right now we chose the node's view's average
			 * size by half, which may in the future also be multiplied by
			 * a certain factor (which could then be used in 
			 * autofitting)
			 */
			
			mp = _stree.getNoSiblings(vp);
			ip = _stree.getChildIndex(vp);
			
			//LogUtil.debug(_LOG, "RecurseCC8: set node:"+vi.id+"'s polarPhi to:"+nodePolarPhi);
			if(mp == 1) {
				
				magnitude = Math.sqrt((vp.vnode.view.width * vp.vnode.view.width) +
					(vp.vnode.view.height * vp.vnode.view.height));
				
				//LogUtil.debug(_LOG, "RecurseCC8.1: parent node:"+vp.id+" has no siblings");			
				/* the diameter might be better here, but anyway */
				//nodePolarR = (vp.vnode.view.width + vp.vnode.view.height) / 4;
				
				nodePolarR = magnitude / 2.0;
								
			} else {
				
				//LogUtil.debug(_LOG, "RecurseCC8.2: parent node:"+vp.id+" has "+mp+" siblings");
				
				/* literally: the radius of the circle centered at vp (parent node)
				 * and intersecting the midway point between vp and vp's nearest
				 * sibling on their shared containment circle */
				 
				/* we need to get a sibling from vp, but first we need to know
				 * if we need to take the following or preceding sibling,
				 * (either would do) so we do not overrun */

				/* check if there is a next sibling, i.e. the index must be less
				 * than the maximum number -1 (which is the last index) */
				if(ip < (mp - 1)) {
					//LogUtil.debug(_LOG, "RecurseCC8.2.0.1: ip:"+ip+" is < mp:"+mp);
					vs = _stree.getIthChildPerNode(vgp,ip+1);
					//LogUtil.debug(_LOG, "RecurseCC8.2.0.2: sibling node vs:"+vs.id);
				}
				/* no? but if the index is > 0 we have a previous sibling */
				else if(ip > 0) {
					//LogUtil.debug(_LOG, "RecurseCC8.2.0.3: ip:"+ip+" is > 1 and mp:"+mp);
					vs = _stree.getIthChildPerNode(vgp,ip-1);
					//LogUtil.debug(_LOG, "RecurseCC8.2.0.4: sibling node vs:"+vs.id);
				}
				/* we have neither? so vp is childindex 1 and mp is 1 
				 * that means vp was an only child */
				else {
					throw Error("vp:"+vp.id+" has no sibling, but mp > 1? this is very wrong");
				}
				
				/* since we compute from root down, this should not happen */
				if(!_currentDrawing.nodeDataValid(vs)) {
					throw Error("Parent siblings node data invalid, this should not have happened");
				}
				
				angle1 = _currentDrawing.getLocalPolarPhi(vp);
				angle2 = _currentDrawing.getLocalPolarPhi(vs);
				
				/* *
				LogUtil.debug(_LOG, "RecurseCC8.3: vi:"+vi.id+" parent:"+vp.id+"'s phi:"+
				angle1+
				" sibling:"+vs.id+"'s phi:"+
				angle2);
				/* */
				
				/* establish the larger of the two angles */
				if(angle1 > angle2) {
					lrgangle = angle1;
					smlangle = angle2;
				} else {
					lrgangle = angle2;
					smlangle = angle1;
				}
				
				/* if the difference is larger than 180, we want
				 * to use the complementary angle */
				if(lrgangle < (smlangle + 180)) {
					delta = lrgangle - smlangle;
				} else {
					delta = 360 - (lrgangle - smlangle);
				}

				/* now half it */
				delta = delta / 2.0;
				
				/*
				LogUtil.debug(_LOG, "Half Angular diff between:"+vp.id+" and:"+vs.id+" is:"+delta);
				LogUtil.debug(_LOG, "Radius of vp:"+_currentDrawing.getLocalPolarR(vp)+" and vs:"+
					_currentDrawing.getLocalPolarR(vs));
				*/
				
				/* delta is an angle in degrees now */
				
				/* now multiply with radius to get the segments length */
				nodePolarR = Geometry.deg2rad(delta) * _currentDrawing.getLocalPolarR(vp);
			}
			//LogUtil.debug(_LOG, "RecurseCC9: set node:"+vi.id+"'s polarR to:"+nodePolarR);
			
			/* set the values */				
			_currentDrawing.
				setNodeCoordinates(vi,nodeOrigin,zeroAngleOffset,nodePolarR,nodePolarPhi);
				
			return;
		}
			

		/**
		 * @internal
		 * do all the calculations required for autoFit
		 * */
		private function calculateAutoFit():void {
			
			var maxlen:Number;
			var lenlimit:Number;
			var len:Number;
			var currentRootR:Number;
			var visVNodes:Array;
			var vn:IVisualNode;
			
			maxlen = 0;
			currentRootR = _currentDrawing.rootR;
			visVNodes = _vgraph.visibleVNodes;
			for each(vn in visVNodes) {	
				/* should be visible otherwise somethings wrong */
				if(!vn.isVisible) {
					throw Error("received invisible vnode from list of visible vnodes");
				}
				len = _currentDrawing.getRelCartCoordinates(vn.node).length;
				maxlen = Math.max(maxlen,len);
			}

			lenlimit = (Math.min(_vgraph.width,_vgraph.height) - margin) / 2;
			
			_rootR = currentRootR * (lenlimit / maxlen);
			
			//LogUtil.info(_LOG, "autofitting rootR to:"+_rootR+" with ml:"+maxlen);
		}
	}
}
