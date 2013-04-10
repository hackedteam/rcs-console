package org.un.cava.birdeye.ravis.utils
{

	import mx.collections.ArrayCollection;
	import mx.collections.XMLListCollection;
	
	import org.un.cava.birdeye.ravis.graphLayout.data.Edge;
	import org.un.cava.birdeye.ravis.graphLayout.data.Graph;
	import org.un.cava.birdeye.ravis.graphLayout.data.IGraph;
	import org.un.cava.birdeye.ravis.graphLayout.data.Node;
	
	/**
	 * Helper methods to handle graph data. 
	 */
	public class GraphHelper
	{
		
		private var _assignedNodes:Object = new Object();
		private var _assignedNodesCount:int = 0;
		
		public function GraphHelper()
		{
		}
		
		/**
		 * Searches for components in a <b><a href="http://code.google.com/p/birdeye/wiki/RaVis">RaVis</a></b> <code>IGraph</code> object 
		 * an return an <code>Array</code> with the xml data for all components in this graph.
		 * 
		 * @return An <code>Array</code> with the xml data for all components in this graph
		 */
		public function graphs(graph:IGraph):Array
		{
			
			var nodes:Array = graph.nodes;
			var edges:Array = graph.edges;
			var graphs:Array = new Array();
			var queuedNodes:Array = new Array();
			
			while (_assignedNodesCount < nodes.length) {
				
				var i:int = 0;
				while ( _assignedNodes.hasOwnProperty(nodes[i].stringid) ) {
						i++;
				}
				
				queuedNodes = [ nodes[i] ];
				_assignedNodes[nodes[i].stringid] = nodes[i].stringid;
				_assignedNodesCount++;
				
				var graphXML:XML = collectGraph(queuedNodes, graph);
				var edgesXMLListColl:XMLListCollection = new XMLListCollection( graphXML..Edge);
				
				if( edgesXMLListColl.source.length() > 0) {
					graphs.push( graphXML );
				}
				
			}
				
			
			return graphs; 
		}
		
		
		private function collectGraph(queuedNodes:Array, graph:IGraph):XML
		{
			var graphXML:XML = <graph/>;
			
			while ( queuedNodes.length > 0 ) {
				var searchNode:Node = queuedNodes.shift();
				
				graphXML.appendChild(createNodesXML(searchNode));
				graphXML.appendChild(createEdgeXML(searchNode));
				
				for each (var successor:Node in searchNode.successors) {
					if( !_assignedNodes.hasOwnProperty(successor.stringid) ) {
						queuedNodes.push(successor);
						_assignedNodes[successor.stringid] = successor.stringid;
						_assignedNodesCount++;
					}	
				}
			}
			return graphXML;
		}
		
		
		
		private function createNodesXML(node:Node):XML
		{
			return node.data as XML;
		}
		
		private function createEdgeXML(node:Node):XMLList
		{
			var edgesXML:XMLList = new XMLList();
			
			for each (var edge:Edge in node.inEdges) {
				edgesXML += (edge.data);
			}
			
			return edgesXML;
		}
	}
}