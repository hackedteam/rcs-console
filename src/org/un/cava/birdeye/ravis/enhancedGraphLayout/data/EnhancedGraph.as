package org.un.cava.birdeye.ravis.enhancedGraphLayout.data
{
	import org.un.cava.birdeye.ravis.graphLayout.data.Graph;
	import org.un.cava.birdeye.ravis.graphLayout.data.IEdge;
	import org.un.cava.birdeye.ravis.graphLayout.data.INode;
	import org.un.cava.birdeye.ravis.utils.LogUtil;
	import org.un.cava.birdeye.ravis.utils.TypeUtil;
	
	public class EnhancedGraph extends Graph
	{
        private static const _LOG:String = "graphLayout.data.EnhancedGraph";
		public var data:Object;
		
		public function EnhancedGraph(id:String, directional:Boolean = false, xmlsource:XML = null):void {
			super(id, directional, xmlsource);
		}
		
		public function initFromVO(vo:Object):void{
			data = vo;
			if (vo == null)
				return;
			
			var nodeProp:String = DEFAULTNAME_NODE;
			var edgeProp:String = DEFAULTNAME_EDGE;
			var fromIDProp:String = DEFAULTNAME_FROMID;
			var toIDProp:String = DEFAULTNAME_TOID;
			
			var fromNodeId:String;
			var toNodeId:String;
			var nodeId:String;
			
			var fromNode:INode;
			var toNode:INode;
			
			var elements:Object = vo[DEFAULTNAME_NODE];
			var arrElements:Array;
			if (!elements)
				arrElements = new Array();
			else if ((elements is Array))
				arrElements = elements as Array;
			else
				arrElements = [elements];
			
			var edges:Object = vo[DEFAULTNAME_EDGE];
			var arrEdges:Array;
			if (!edges)
				arrEdges = new Array();
			else if (edges is Array)
				arrEdges = edges as Array;
			else
				arrEdges = [edges];
			
			for each (var nodeVO:Object in arrElements)
			{
				nodeId = nodeVO.id;
				fromNode = createNode(nodeId, nodeVO);
			}
			
			for each (var edgeVO:Object in arrEdges)
			{
				fromNodeId = edgeVO[fromIDProp];
				toNodeId = edgeVO[toIDProp];
				
				fromNode = nodeByStringId(fromNodeId);
				toNode = nodeByStringId(toNodeId);
				
				/* we do not throw an error here, because the data
				 * is often inconsistent. In this case we just ignore
				 * the edge */
				if(fromNode == null) 
				{
                    LogUtil.warn(_LOG,"Node id: "+fromNodeId+" not found, link not done");
					continue;
				}
				if(toNode == null) 
				{
                    LogUtil.warn(_LOG,"Node id: "+toNodeId+" not found, link not done");
					continue;
				}
				link(fromNode,toNode,edgeVO);
			}
		}
		
		public override function get xmlData():XML
		{
			var data:Object;
			var tabStr:String = '';
			var attrStr:String = TypeUtil.objectPropertyToXMLAttributeString(this);
			var tempStr:String = '<' + 'root' + ' ' + attrStr +' >';
			//var arrNodes:Array = nodes.reverse();
			var arrNodes:Array = nodes;
			for each (var node:INode in arrNodes)
			{
				data = node.data;
				attrStr = TypeUtil.objectPropertyToXMLAttributeString(data);
				tempStr += ("<" + DEFAULTNAME_NODE + " " + attrStr + "/>\n");
			}
			
			//var arrEdges:Array = edges.reverse();
			var arrEdges:Array = edges;
			for each (var edge:IEdge in arrEdges)
			{
				data = edge.data;
				attrStr = TypeUtil.objectPropertyToXMLAttributeString(data);
				tempStr += ("<" + DEFAULTNAME_EDGE + " " + attrStr + "/>\n");
			}
			
			
			tempStr += '</' + 'root' + '>';
			return new XML(tempStr);
		}

	}
}