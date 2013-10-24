package it.ht.rcs.console.entities.view.map
{
	import flash.display.Sprite;
	
	import it.ht.rcs.console.entities.model.Place;
	import it.ht.rcs.console.evidence.model.Evidence;
	
	import mx.core.UIComponent;

	public class LastPositionMarker extends UIComponent
	{

		[Embed('img/evidence/mapMarkerBlu.png')]
		private var MarkerIcon:Class;

    
		public function LastPositionMarker()
		{
			var icon:Sprite=new Sprite();
			icon.x=-12;
			icon.y=-20;
			icon.addChild(new MarkerIcon())
			addChild(icon);
      this.toolTip="Last known position: ";
		}
	}
}
