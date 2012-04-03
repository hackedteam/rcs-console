package it.ht.rcs.console.operations.view.evidences.advanced.viewers.map
{
	import flash.display.Sprite;

	public class CustomMarker extends Sprite
	{

		[Embed('img/NEW/target_36.png')]
		private var TargetIcon:Class;

    public var data:Object;
    
		public function CustomMarker(label:String)
		{
			var icon:Sprite=new Sprite()
			icon.x=-18;
			icon.y=-18;
			icon.addChild(new TargetIcon())
			addChild(icon);

		}
	}
}
