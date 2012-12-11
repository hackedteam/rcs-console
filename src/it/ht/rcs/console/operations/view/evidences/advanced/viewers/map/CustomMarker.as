package it.ht.rcs.console.operations.view.evidences.advanced.viewers.map
{
	import flash.display.Sprite;
	
	import it.ht.rcs.console.evidence.model.Evidence;

	public class CustomMarker extends Sprite
	{

		[Embed('img/NEW/target_36.png')]
		private var TargetIcon:Class;

    public var data:Evidence;
    
		public function CustomMarker(evidence:Evidence)
		{
      data=evidence;
			var icon:Sprite=new Sprite();
			icon.x=-18;
			icon.y=-18;
			icon.addChild(new TargetIcon())
			addChild(icon);

		}
	}
}
