package it.ht.rcs.console.system.view.backend.graph.renderers
{
  import it.ht.rcs.console.system.view.backend.graph.BackendGraph;
  
  import spark.components.Group;
  import spark.layouts.VerticalLayout;
	
	public class NetworkObject extends Group
	{
		
    protected var graph:BackendGraph;
    
		public function NetworkObject()
		{
      super();
			var layout:VerticalLayout = new VerticalLayout();
			layout.horizontalAlign = 'center';
			layout.verticalAlign = 'top';
			layout.paddingTop = 5;
      layout.paddingBottom = 5;
      layout.paddingLeft = 5;
      layout.paddingRight = 5;
      layout.gap = 6;
			this.layout = layout;
		}
		
	}
	
}