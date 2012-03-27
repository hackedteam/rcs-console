package it.ht.rcs.console.operations.view.evidences.advanced.viewers
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import mx.controls.Label;
	
	import spark.components.Group;
	import spark.core.SpriteVisualElement;
	
	public class SoundSpectrumMonitor extends Group
	{
		
		private var _monitorWidth:Number=1024;
		private var _monitorHeight:Number=512;
		
		//Styling
		private var _backgroundColor:uint=0xFF0000;//RGBA
		private var _waveColor:uint=0xCCCCCC;
		private var _selectionColor:uint=0x110000FF;
		private var _playheadColor:uint=0xFF000000;
		private var _playheadWidth:Number=2;
		
		
		private var _samples:ByteArray = new ByteArray();
		
		private var _buffer:BitmapData = new BitmapData(_monitorWidth,_monitorHeight,false,_backgroundColor);
		private var _cursorBuffer:BitmapData = new BitmapData(_monitorWidth,_monitorHeight,true,_backgroundColor);
		private var _selectBuffer:BitmapData = new BitmapData(_monitorWidth,_monitorHeight,true,_backgroundColor);
		
		private var _selectScreen:Bitmap = new Bitmap(_selectBuffer);
		private var _cursorScreen:Bitmap = new Bitmap(_cursorBuffer);		
		private var _screen:Bitmap = new Bitmap(_buffer);
		
		private var _rect:Rectangle = new Rectangle(0,0,1,0);
		
		private var _playingTime:int;
		private var _ratio:Number;
		private var _step:int;
		
		private var _zone:Rectangle = new Rectangle(0,0,_playheadWidth,_monitorHeight);
		private var _selectionRect:Rectangle = new Rectangle(0,0,0,_monitorHeight);
		private var _clickedPosition:int;
		
		public static const SELECTION:String="selection"
		
		
		public function SoundSpectrumMonitor()
		{
			super();
			init();
			
		}
    override protected function createChildren():void
    {
      super.createChildren();
      var screens:SpriteVisualElement=new SpriteVisualElement()
      
      screens.addChild(_screen)
      screens.addChild( _selectScreen );
      screens.addChild( _cursorScreen );
      addElement(screens)
    }
		
		public function clear():void
		{
			
			_selectionRect = new Rectangle(0,0,0,_monitorHeight);
			_selectBuffer.fillRect( _selectBuffer.rect, _backgroundColor);
			
			removeEventListener( MouseEvent.CLICK, onClick );
			removeEventListener( MouseEvent.MOUSE_DOWN, onMouseIsDown );

		}
		
		
		private function init():void
		{


		}
		
		public function update(position:Number):void
		{
			_cursorBuffer.fillRect( _cursorBuffer.rect,_backgroundColor );
			_zone.x = (_buffer.width / _playingTime) * position;
			_cursorBuffer.fillRect( _zone , _playheadColor );
			
		}
		
		public function draw(sound:Sound):void
		{
			_buffer.fillRect( _buffer.rect, _backgroundColor );
			var extract:Number = Math.floor ((sound.length/1000)*44100);
			_playingTime = sound.length;
			_ratio = _playingTime / _buffer.width;//
			var lng:Number = sound.extract(_samples,extract);
			
			_samples.position = 0;
			_step = _samples.length/4096;
			
			do _step-- while ( _step % 4 );
			
			var left:Number;
			var right:Number;
			
			for (var c:int = 0; c < 4096; c++)
			{
				_rect.x = c/4;
				left = _samples.readFloat()*128;
				right = _samples.readFloat()*128;
				_samples.position = c*_step;
				
				if (left>0)
				{
					_rect.y = 128-left;
					_rect.height = left;
				} else
				{
					_rect.y = 128;
					_rect.height = -left;
				}
				
				_buffer.fillRect( _rect, _waveColor );
				
				if (right>0)
				{
					_rect.y = 350-right;
					_rect.height = right;
				} else
				{
					_rect.y = 350;
					_rect.height = -right;
				}
				
				_buffer.fillRect( _rect, _waveColor );
			}
			addEventListener( MouseEvent.CLICK, onClick );
			addEventListener( MouseEvent.MOUSE_DOWN, onMouseIsDown );
		}
		
		
		private function onMouseIsDown( e:MouseEvent ):void
		{
			addEventListener( MouseEvent.MOUSE_MOVE, onMove );
			_selectBuffer.fillRect( _selectBuffer.rect, _backgroundColor);
			_clickedPosition = e.stageX;
			_selectionRect.x = _clickedPosition;
			_selectionRect.width = 0;
		}
		
		private function onMove( e:MouseEvent ):void
		{
			if ( e.stageX > _clickedPosition )
			{
				_selectionRect.width = e.stageX-_clickedPosition;
			} else
			{
				_selectionRect.x = e.stageX;
				_selectionRect.width = Math.abs (e.stageX-_clickedPosition);
			}
			_selectBuffer.fillRect( _selectionRect, _selectionColor );
		}
		
		private function onClick( e:MouseEvent ):void
		{
			dispatchEvent(new Event(SELECTION))
			removeEventListener( MouseEvent.MOUSE_MOVE, onMove );
			
		}
		
		public function get selectionRect():Rectangle
		{
			return _selectionRect;
		}
		
		public function get ratio():Number
		{
			return _ratio;
		}
		
		public function set backgroundColor(value:uint):void{
			_backgroundColor=value;
		}
		
		public function set waveColor(value:uint):void{
			_waveColor=value;
		}
		
		public function set selectionColor(value:uint):void{
			_selectionColor=value;
		}
		
		public function set playheadColor(value:uint):void
		{
			_playheadColor=value;
		}
		
		public function set playheadWidth(value:Number):void
		{
			_playheadWidth=value;
		}

	}
}