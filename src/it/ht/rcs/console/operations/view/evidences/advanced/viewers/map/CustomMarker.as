package it.ht.rcs.console.operations.view.evidences.advanced.viewers.map
{
	import flash.display.Sprite;
	
	import it.ht.rcs.console.evidence.model.Evidence;

	public class CustomMarker extends Sprite
	{

		[Embed('img/evidence/mapMarker.png')]
		private var MarkerIcon:Class;

    public var data:Evidence;
    
		public function CustomMarker(evidence:Evidence)
		{
      data=evidence;
			var icon:Sprite=new Sprite();
			icon.x=-12;
			icon.y=-12;
			icon.addChild(new MarkerIcon())
			addChild(icon);

		}
	}
}
