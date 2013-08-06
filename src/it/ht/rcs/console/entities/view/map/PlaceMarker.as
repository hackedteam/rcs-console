package it.ht.rcs.console.entities.view.map
{
	import flash.display.Sprite;
	
	import it.ht.rcs.console.entities.model.Place;
	import it.ht.rcs.console.evidence.model.Evidence;
	
	import mx.core.UIComponent;

	public class PlaceMarker extends UIComponent
	{

		[Embed('img/evidence/mapMarker.png')]
		private var MarkerIcon:Class;

    
		public function PlaceMarker(place:Place)
		{

			var icon:Sprite=new Sprite();
			icon.x=-12;
			icon.y=-20;
			icon.addChild(new MarkerIcon())
			addChild(icon);
      this.toolTip="Visited: "+ place.count+ " times";

		}
	}
}
