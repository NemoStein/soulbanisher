package sourbit.games.soulbanisher
{
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Timer;

	public class SoundManager
	{
		private var _sound:Sound;
		private var _channel:SoundChannel;
		private var _soundTransform:SoundTransform;
		
		private var _loop:Boolean;
		private var _position:Number;
		
		private var _timer:Timer;
		private var _originalVolume:Number;
		private var _fadingOut:Boolean;
		private var _SoundClass:Class;
		
		public function SoundManager(SoundClass:Class, loop:Boolean = false)
		{
			_SoundClass = SoundClass;
			_timer = new Timer(100, 10);
			_timer.addEventListener(TimerEvent.TIMER, onTimerTimer);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerTimerComplete);
			
			_sound = new SoundClass();
			_loop = loop;
			_position = 0;
			
			_originalVolume = 1;
			_soundTransform = new SoundTransform(1);
		}
		
		public function play(time:Number = NaN):void
		{
			if(_channel)
			{
				_channel.stop();
			}
			
			if (isNaN(time))
			{
				time = _position;
			}
			
			_channel = _sound.play(time, _loop ? int.MAX_VALUE : 0);
			
			if(_channel)
			{
				_channel.soundTransform = _soundTransform;
			}
		}
		
		public function pause():void
		{
			_position = _channel.position;
			if(_channel)
			{
				_channel.stop();
			}
		}
		
		public function stop():void
		{
			_position = 0;
			if(_channel)
			{
				_channel.stop();
			}
		}
		
		public function fadeIn():void
		{
			_fadingOut = false;
			
			setTransformVolume(0);
			play();
			
			_timer.reset();
			_timer.start();
		}
		
		public function fadeOut():void
		{
			_fadingOut = true;
			
			_timer.reset();
			_timer.start();
		}
		
		private function onTimerTimer(event:TimerEvent):void
		{
			if (_fadingOut)
			{
				setTransformVolume(volume - _originalVolume * 0.1);
			}
			else
			{
				setTransformVolume(volume + _originalVolume * 0.1);
			}
		}
		
		private function onTimerTimerComplete(event:TimerEvent):void
		{
			setTransformVolume(_originalVolume);
			
			if (_fadingOut)
			{
				pause();
			}
		}
		
		public function get volume():Number
		{
			return _soundTransform.volume;
		}
		
		public function set volume(value:Number):void
		{
			_originalVolume = value;
			setTransformVolume(value);
		}
		
		private function setTransformVolume(value:Number):void
		{
			_soundTransform.volume = value;
			
			if (_channel)
			{
				_channel.soundTransform = _soundTransform;
			}
		}
	}
}