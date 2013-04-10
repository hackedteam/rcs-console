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
	
/**
 * This is an implementation of an Inverted Self Organizing Map (ISOM) 
 * layout.
 * <ul> Refer the following paper for more information:<br>
 *  <li>Meyer, B; 'Self-Organizing Graphs - A Neural Network Prespective
 *  of Graph Layout',<br>
 *  Graph Drawing'98. </li>
 *  <li>http://www.csse.monash.edu.au/~berndm/ISOM/</li>
 * </ul>
 * 
 * @author Nitin Lamba
 */
  public class ISOMLayouter extends IterativeBaseLayouter implements ILayoutAlgorithm {
	 /*********************************************
		* CONSTANTS
		*********************************************/
		private static const _LOG:String = "graphLayout.layout.ISOMLayouter";
		/**
		 * @internal
		 * This defines the Rectangular random distribution. */
    private const _DIST_RECTANGULAR:int = 0;
		/**
		 * @internal
		 * This defines the Triangular random distribution. */
    private const _DIST_TRIANGULAR:int = 1;
		/**
		 * @internal
		 * This defines the Circular random distribution. */
    private const _DIST_CIRCULAR:int = 2;
		
	 /*********************************************
		* PARAMETERS
		*********************************************/
	  /* Last coordinates of Random stimulus point */
		private var last_x:Number;
    private var last_y:Number;
		
    /* Bounds of the layout */
    private var min_x:int;
	  private var max_x:int;
	  private var min_y:int;
	  private var max_y:int;
    
		/* Maximum number of iterations */
    private var max_epochs:int;
    private var epoch:int;
    
		/* Parameters for controlling the radius 
		 * (for propagation of changes) */
    private var radius_constant_time:int;
    private var radius:int;
    private var min_radius:int;
    
		/* Adaptation parameter */
    private var adaption:Number;
    private var initial_adaption:Number;
    private var min_adaption:Number;
    
		/* Cooling Factor */
    private var factor:Number;
    private var cooling_factor:Number;
    
		/* OBSOLETE: Temperature and Jump Radius */
    private var temp:Number;
    private var jump_radius:int;
    private var initial_jump_radius:int;
	 
    private var tabooDist:Number;
	 
	  /* Distribution type */
    private var distribution:int;
		
		/* Clipping: When enabled, only Nodes within stimulus area are updated */
    private var clipping:Boolean = false;
		
    /* OBSOLETE: Make a random node jump on every iteration */
		private var random:Boolean = false;
		
		/* OBSOLETE: check for taboo area violation of every node */
    private var taboo:Boolean = true; 
	 
	 /*********************************************
		* LOCAL VARIABLES
		*********************************************/
	  /* Used primarily for taboo step */
		private var _previousPositions:Dictionary = new Dictionary();
	 
    public function ISOMLayouter(vg:IVisualGraph = null):void {
			super(vg);
			resetAll();
    }
    
    override public function resetAll():void {
			super.resetAll();
			initialize();
		}
		
		// OPTIONAL: Create a UI for setting parameters
		private function initialize():void {
      distribution = _DIST_RECTANGULAR;
			
			max_epochs = 300; // 500 in paper
    	radius = 3; //from paper
    	min_radius = 0; //from paper
    	radius_constant_time = 100; //guessed
			initial_adaption = 0.8; //from paper
			adaption = initial_adaption;
			min_adaption = 0.01; //from paper
      cooling_factor = 0.4; //from paper
			
			// following are guess values
			temp = 0.05; // guessed
			initial_jump_radius = 30; //guessed
			jump_radius = initial_jump_radius;
			tabooDist = 60.0;
			
			epoch = 1;
			_dragNode = null;
			
			last_x = 0;
			last_y = 0;
			min_x = margin; 
			min_y = margin; 
			max_x = _vgraph.width - margin; 
			max_y = _vgraph.height - margin;
    }

		override public function refreshInit():void {
			epoch = 1;
		}
		
		/*********************************************
		* Layout Methods - Computational Methods
		* ********************************************/
		/* Calculation step of the layout */
		override protected function calculateLayout():void {
	    if (epoch < max_epochs) {
	      adjust();
  	    updateParameters();
				/*
	      LogUtil.debug(_LOG, "epoch=" + epoch + ", " 
				    + "adaption=" + adaption + ", "
						+ "radius=" + radius);
				 */
  	  }
			
			// If random is enabled, just jump a random node randomly
	    if (random && (Math.random() < temp)) {
				var randomNodePosition:int = Math.round(_vgraph.noVisibleVNodes * Math.random());
						
				/* Find random node from all currently visible VNodes */
				var allVisVNodes:Array = _vgraph.visibleVNodes;
				var vn:IVisualNode;
				var randomNode:IVisualNode;
				var count:int = 0;
				
				/* HACK: twisted way to find the random node - much simpler with arrays */
      	for each(vn in allVisVNodes) {
				  ++count;
					if (count == randomNodePosition) {
						randomNode = vn
					}
				}
				if (randomNode.moveable) {
					randomNode.x += jump_radius*Math.random() - jump_radius/2;
					randomNode.y += jump_radius*Math.random() - jump_radius/2;
				}
	    }
		}
		
		/* Terminating condition for the layout */
		override protected function isStable():Boolean {
			return ( (epoch >= max_epochs) && (!random || (random && Math.random() > temp)) );
		}
		
  /*************************************************
	 * Helper Functions
	 ************************************************/
		/**
		 * @internal
		 * This adjusts the node positions by propagating the 
		 * stimulus upto a certain distance */
    private function adjust():void {
	 		var winner:IVisualNode = null;
			
			var queue:Array = new Array();
			var visitedMap:Dictionary = new Dictionary();
			var distanceMap:Dictionary = new Dictionary();
			
			var allVisVNodes:Array = _vgraph.visibleVNodes;
			var vn:IVisualNode;
			var j:int;
			
			// initialize caches
      for each(vn in allVisVNodes) {
    	  visitedMap[vn] = [false];
				var initDistance:Array = [0];
				distanceMap[vn] = initDistance;
				_previousPositions[vn] = new Point(vn.x, vn.y);
			}
			
			// pick a node randomly
			do {
				last_x = min_x + (max_x - min_x) * Math.random();
				last_y = min_y + (max_y - min_y) * Math.random();
			} while (!insideDistribution(last_x,last_y));
      		winner = closestNode(last_x, last_y);
			//LogUtil.debug(_LOG, "*> Winner is = " + winner.node.stringid);
			// add winner to the queue
			distanceMap[winner] = [0];
			visitedMap[winner] = [true];
			queue.push(winner);
			
			/* Do a breadth first traversal for all neighbors of the winner */
			while (queue.length > 0) {
				vn = (queue[0] as IVisualNode);
				queue.shift();

				var dx:Number = last_x - vn.x;
				var dy:Number = last_y - vn.y;
				var p:int = (distanceMap[vn] as Array)[0];
				var factor:Number = adaption/Math.pow(2, p);
				
				vn.x += factor * dx;
				vn.y += factor * dy;
				/*
				 LogUtil.debug(_LOG, "Q: Adjusting node " + vn.node.stringid + 
							 "@d=" + p + 
							 ": dx=" + factor * dx +
							 " and dy=" + factor * dy +
							 ".");
				*/
				if ((distanceMap[vn] as Array)[0] < radius) {
					var node:INode = vn.node;
					var child:INode = null;
					var vchild:IVisualNode = null;
					var d:int;
					
					// Propagate the change to predessors
					for(j=0;j < node.predecessors.length; ++j) {
						child = (node.predecessors[j] as INode);
						//LogUtil.debug(_LOG, "P: Child = " + child.stringid);
						vchild = child.vnode;
						//LogUtil.debug(_LOG, "P: Retrieved child's vNode...");
						if (vchild.isVisible &&
						      !(visitedMap[vchild] as Array)[0] &&
									 ( !clipping ||
										 insideDistribution(vchild.x,vchild.y)) ) {
							visitedMap[vchild] = [true];
							d = (distanceMap[vn] as Array)[0];
							distanceMap[vchild] = [d + 1];
				 			//LogUtil.debug(_LOG, "P: Distance =" + d);
							queue.push(vchild);
						} else {
							//LogUtil.debug(_LOG, "P: vNode doesn't qualify, no action...");
						}
					}
					
					// Propagate the change to successors
					for(j=0;j < node.successors.length; ++j) {
						child = (node.successors[j] as INode);
						//LogUtil.debug(_LOG, "S: Child = " + child.stringid);
						vchild = child.vnode;
						//LogUtil.debug(_LOG, "S: Retrieved child's vNode...");
						if (vchild.isVisible &&
						      !(visitedMap[vchild] as Array)[0] &&
									 ( !clipping ||
										 insideDistribution(vchild.x,vchild.y))) {
							visitedMap[vchild] = [true];
							d = (distanceMap[vn] as Array)[0];
							distanceMap[vchild] = [d + 1];
				 			//LogUtil.debug(_LOG, "S: Distance =" + d);
							queue.push(vchild);
						} else {
							//LogUtil.debug(_LOG, "S: vNode doesn't qualify, no action...");
						}
					}
				} else {
					//LogUtil.debug(_LOG, "Q: Node beyond the radius, no action...");
				}
			}
      if (taboo) tabooCheck(visitedMap);
    }
		
		/**
		 * @internal
		 * This finds the closest node to a given point. 
		 * 
		 * OPTIONAL: Should this be moved to <code>VisualGraph</code>
		 */
		private function closestNode(x:Number, y:Number):IVisualNode {
			var dx:Number;
			var dy:Number;
			var dist:Number;
			var bestDistance:Number = Number.MAX_VALUE;
			var bestNode:IVisualNode = null;
			var allVisVNodes:Array = _vgraph.visibleVNodes;
			var vn:IVisualNode;
			
			for each(vn in allVisVNodes) {
				/* we have to do this to prevent this method from returning null*/
				if(bestNode == null) {
					bestNode = vn;	
				}
				//LogUtil.debug(_LOG, "$> " + vn.x + ", " + vn.y);
				if (insideDistribution(vn.x, vn.y)) {
					dx = vn.x - x;
					dy = vn.y - y;
					dist = Math.sqrt(dx*dx + dy*dy);
					//LogUtil.debug(_LOG, "$> Distance from target =" + dist);
					if (bestDistance > dist) {
						bestDistance = dist;
						bestNode = vn;
					}
				}
			}
			//LogUtil.debug(_LOG, "$> closestNode = " + bestNode);
			return bestNode;
		}
    
		/**
		 * @internal
		 * This checks if a point lies inside the random distribution */
		private function insideDistribution(x:Number, y:Number):Boolean {
			var rtn:Boolean;
      switch (distribution) {
			  case _DIST_RECTANGULAR:
				  rtn = (x >= min_x) && (x <= max_x) && (y >= min_y) && (y <= max_y);
					break;
			  case _DIST_TRIANGULAR:
					var range:Number = (y-min_y) / (max_y-min_y) * (max_x-min_x) / 2;
					rtn = ( x >= (min_x + (max_x-min_x)/2 - range) &&
									x <= (min_x + (max_x-min_x)/2 + range) );
					break;
			  case _DIST_CIRCULAR:
					var centerX:Number = min_x + (max_x-min_x)/2;
					var centerY:Number = min_y + (max_y-min_y)/2;
					var radius:Number = Math.min( max_x - min_x, max_y - min_y)/2;
					var dist:Number = Math.sqrt(Math.pow((centerX - x),2.0) + Math.pow((centerY - y),2.0));
					rtn = (dist <= radius);
					break;
			  default: 
				  last_x=0;
				  last_y=0;
				  rtn = true;
					break;
      }
			return rtn;
    }
    
		/**
		 * @internal
		 * This updates the layout parameters on every iteration */
    private function updateParameters():void {
			epoch += 1;
		
		// Option 1. linear cooling:
		// factor=(1-(Number)epoch/max_epochs);
		
		// Option 2. negative exponential cooling:
			factor = Math.exp(-1 * cooling_factor * epoch / max_epochs);
			
			adaption = Math.max( min_adaption, factor * initial_adaption);
			jump_radius = Math.round(factor * jump_radius);
			temp = factor * temp;

			// apparently it is not a good idea to update just a single node
			// in isolation (radius=0)
			if ((radius > min_radius) && (0 == epoch%radius_constant_time)) { 
				radius -= 1; 
			}
    }
    
		/**
		 * @internal
		 * OBSOLETE: This checks if any node violates the taboo
		 * distance of any other node */
    private function tabooCheck(visited:Dictionary):void {
			var allVisVNodes:Array = _vgraph.visibleVNodes;
			var vn_i:IVisualNode;
			var vn_j:IVisualNode;
			
			for each(vn_i in allVisVNodes) {
				if(!vn_i.isVisible) {
					throw Error("Received invisible node while working on visible vnodes only");
				}
				for each(vn_j in allVisVNodes) {
					if(!vn_j.isVisible) {
						throw Error("Received invisible node while working on visible vnodes only");
					}
					if(vn_i != vn_j) {
            var dx:Number = vn_i.x - vn_j.x;
            var dy:Number = vn_i.y - vn_j.y;
            var dist:Number = Math.sqrt(dx*dx + dy*dy);
            if (dist < tabooDist) {
							var old:Point = null;
							var x_translat:Number;
							var y_translat:Number;
							var translation:Number;
							var clip_factor:Number;
							
              if ((visited[vn_i] as Array)[0]) {
								old = (_previousPositions[vn_i] as Point);
								x_translat = vn_i.x - old.x;
								y_translat = vn_i.y - old.y;
								translation = Math.sqrt(x_translat*x_translat + y_translat*y_translat);
								//dont want to divide by zero
								clip_factor = translation == 0 ? 1 : 1 - (tabooDist - dist) / translation;
								
								vn_i.x = old.x + clip_factor*x_translat;
								vn_i.y = old.y + clip_factor*y_translat;
								
						  } else if ((visited[vn_j] as Array)[0]) {
								old = (_previousPositions[vn_j] as Point);
								x_translat = vn_j.x - old.x;
								y_translat = vn_j.y - old.y;
								translation = Math.sqrt(x_translat*x_translat + y_translat*y_translat);
								clip_factor = 1 - (tabooDist - dist) / translation;
								
								vn_j.x = old.x + clip_factor*x_translat;
								vn_j.y = old.y + clip_factor*y_translat;
						  }
            }
          }
        }
      }
	  }
		
  }//End of class
}//End of package
