package it.ht.rcs.console.operations.view.filesystem
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import it.ht.rcs.console.agent.model.Agent;
	import it.ht.rcs.console.evidence.model.Evidence;

	import mx.collections.ArrayCollection;
	import mx.rpc.events.ResultEvent;

	public class FileSystemItem extends EventDispatcher
	{
		public var name:String;
		public var agent:Agent;
		public var parent:FileSystemItem;
		public var children:Array;
		public var attr:int;
		public var scanning:Boolean;
		public var path:String;
		public var size:Number;
		public var date:int;
		public var created_at:int;
		public var sent_at:int;
		public var aid:String;
		public var evidence:Evidence;
		public var incomplete:Boolean;

		[Bindable]
		public var pending:Boolean;
		[Bindable]
		public var updated:Boolean; //got push

		private function getName(path:String):String
		{
			path=path.replace('\\\\', '\\');
			var separator:String=path.indexOf('/') == -1 ? '\\' : '/';
			var tokens:Array=path.split(separator);
			var name:String=tokens[tokens.length - 1]
			return name;
		}

		public function isCloud():Boolean
		{
			if (this.path.substr(0, 6) == "cloud:")
				return true;
			return false;
		}


		private function dumpItem(o:Object):FileSystemItem
		{
			var item:FileSystemItem=new FileSystemItem();
			item.name=o.name;
			item.date=o.date;
			item.attr=o.attr;
			item.aid=o.aid;
			item.path=o.path;
			item.size=o.size;
			item.incomplete=o.incomplete;
			item.pending=o.pending;
			item.created_at=o.created_at;
			item.sent_at=o.sent_at;

			//recursive loop on children //check if folder and not empty !
			if (item.attr == FileSystemView.FULL_FOLDER && item.incomplete)
			{
				item.children=[{name: "retrieving data...", scanning: true}]
			}
			else if (o.attr != FileSystemView.EMPTY_FOLDER && o.attr != FileSystemView.FILE)
			{
				item.children=new Array();
				for (var i:int=0; i < o.children.length; i++)
				{
					var c:FileSystemItem=dumpItem(o.children[i]);
					item.children.push(c)
				}
			}
			return item;

		}

		public function update(event:ResultEvent):void
		{
			var o:Object=JSON.parse(String(event.result))
			var a:Array=o as Array;
			children=new Array();
			for (var i:int=0; i < a.length; i++)
			{
				var item:FileSystemItem=dumpItem(a[i]);
				children.push(item);
			}
			dispatchEvent(new Event("updated"));
		}



		public function onPendingResult(e:ResultEvent):void
		{
			for (var i:int=0; i < e.result.length; i++)
			{
				for (var c:int=0; c < children.length; c++)
				{
					if (e.result[i].path == (children[c].path + "\\*"))
					{
						children[c].pending=true;
					}
				}
			}
			dispatchEvent(new Event("pendingResult"));
		}
	}
}
