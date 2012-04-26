package it.ht.rcs.console.operations.view.agents.build
{
	import mx.collections.ICollectionView;
	import mx.controls.treeClasses.ITreeDataDescriptor;

	/**
	 * Implements a very simple filterable TreeDataDescriptor
	 */
	public class FilteredTreeDataDescriptor implements ITreeDataDescriptor
	{
		private var _filter:Function;
		
		/**
		 * Creates a new FilteredTreeDataDescriptor with the specified filter
		 * 
		 * @param filterFunction	Function that complies with the signature:
		 * 							function(node:Object):ICollectionView.
		 * 							The function is expected to return the set
		 * 							of children to be displayed
		 */
		public function FilteredTreeDataDescriptor(filterFunction:Function)
		{
			_filter = filterFunction;
		}

		/** 
		 * Applies the filter to the node's children and returns the result
		 */
		public function getChildren(node:Object, model:Object=null):ICollectionView
		{
			return _filter(node);
		}
		
		/**
		 * True if the the filtered set of children >= 1
		 */
		public function hasChildren(node:Object, model:Object=null):Boolean
		{
			return getChildren(node, model).length > 0;
		}
		
		/**
		 * This method determines whether a folder or file icon is displayed for
		 * this node. Here it is a branch if the node has children
		 */
		public function isBranch(node:Object, model:Object=null):Boolean
		{
      return node.@folder == 'true';
			//return hasChildren(node, model);
		}
		
		public function getData(node:Object, model:Object=null):Object
		{
			//Not implemented
			return null;
		}
		
		public function addChildAt(parent:Object, newChild:Object, index:int, model:Object=null):Boolean
		{
			//Not implemented
			return false;
		}
		
		public function removeChildAt(parent:Object, child:Object, index:int, model:Object=null):Boolean
		{
			//Not implemented
			return false;
		}
	}
}