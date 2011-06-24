package it.ht.rcs.console.network.model
{
	
	public class NetworkObject
	{
		
		private var _nextHop:NetworkObject;
		private var _prevHop:NetworkObject;
		
		public var ip:String;
		
		public function NetworkObject(ip:String)
		{
			this.ip = ip;
		}

		public function set nextHop(newNextHop:NetworkObject):void
		{
			_nextHop = newNextHop;
			newNextHop._prevHop = this;
		}
		
		public function get nextHop():NetworkObject
		{
			return _nextHop;
		}
		
		public function get prevHop():NetworkObject
		{
			return _prevHop;
		}
		
		public function moveAfter(destination:NetworkObject):void
		{
			if (_prevHop === destination)
				return;
			
			_prevHop._nextHop = _nextHop;
			if (_nextHop != null)
				_nextHop._prevHop = _prevHop;
			
			if (destination._nextHop != null)
				destination._nextHop._prevHop = this;
			_nextHop = destination._nextHop;
			_prevHop = destination;
			destination._nextHop = this;
		}
		
	}
	
}