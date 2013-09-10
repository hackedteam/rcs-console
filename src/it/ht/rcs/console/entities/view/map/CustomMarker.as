package it.ht.rcs.console.entities.view.map
{
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import it.ht.rcs.console.entities.model.Entity;


	public class CustomMarker extends Sprite
	{

		[Embed(source='/img/NEW/star_50.png')]
		private var entityIcon:Class;

		[Embed(source='/img/NEW/mapMarker_people.png')]
		private var entityPeopleIcon:Class;

		[Embed(source='/img/NEW/mapMarker_location.png')]
		private var entityLocationIcon:Class;

		[Embed(source='/img/NEW/mapMarker_target.png')]
		private var entityTargetIcon:Class;

		public var data:Entity;
		private var _selected:Boolean;
		private var _glow:GlowFilter;
		public var entity:Entity;
		private var t:TextField;
		private var tf:TextFormat
		private var icon:Sprite;

		public function CustomMarker(entity:Entity)
		{
			this.entity=entity;
			_glow=new GlowFilter(0x00CCFF, 1, 10, 10, 2, 1)
			data=entity;
			icon=new Sprite();
			icon.x=-12;
			icon.y=-24;
			if (entity.type == "position")
				icon.addChild(new entityLocationIcon());
			if (entity.type == "target")
				icon.addChild(new entityTargetIcon());
			addChild(icon);

			t=new TextField();
			t.selectable=false;
			t.autoSize=TextFieldAutoSize.CENTER;
			tf=new TextFormat()
			tf.font="Arial"
			tf.bold=true; 
			tf.size=9
			t.y=0
			t.text=" "+entity.name+" "
			t.setTextFormat(tf)
			t.x=-t.width * .5
			addChild(t)
		}

		public function set selected(value:Boolean):void
		{
			_selected=value;
			if (selected)
			{
				//border.setStyle('backgroundAlpha', 0.2);
				//border.setStyle('borderAlpha', 1);
				icon.filters=[_glow]
			}
			else
			{
				//border.setStyle('backgroundAlpha', 0);
				//border.setStyle('borderAlpha', 0);
				icon.filters=null
			}
		}

		public function get selected():Boolean
		{
			return _selected
		}
	}
}
