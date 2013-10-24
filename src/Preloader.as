package
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.trace.Trace;
	import flash.utils.getDefinitionByName;
	import flash.utils.Timer;
	import sourbit.games.soulbanisher.GameButton;
	import sourbit.games.soulbanisher.GameText;
	import sourbit.games.soulbanisher.tracking.FGLHelper;
	
	public class Preloader extends MovieClip
	{
		[Embed(source="sourbit/games/soulbanisher/assets/scoreBackground.png")]
		private const AssetScoreBackground:Class;
		
		[Embed(source="sourbit/games/soulbanisher/assets/hud.png")]
		private const AssetHUD:Class;
		
		[Embed(source="sourbit/games/soulbanisher/assets/loadingBackground.png")]
		private const AssetLoadingBackground:Class;
		
		[Embed(source="sourbit/games/soulbanisher/assets/loadingBar.png")]
		private const AssetLoadingBar:Class;
		
		private var _container:Sprite;
		private var _mask:Shape;
		private var _numbers:GameText;
		private var _playButton:GameButton;
		private var _adContainer:Sprite;
		
		private var _adReady:Boolean;
		private var _loadReady:Boolean;
		
		static private var _logger:TextField;
		private var _timer:Timer;
		static public function log(... rest:Array):void
		{
			_logger.appendText("\r" + rest.join(" "));
			_logger.scrollV = _logger.textHeight;
		}
		
		public function Preloader()
		{
			_logger = new TextField();
			_logger.textColor = 0xffffff;
			_logger.selectable = false;
			_logger.mouseEnabled = false;
			_logger.width = 600;
			_logger.height = 600;
			
			initialize();
			
			addChild(_logger);
		}
		
		private function initialize():void
		{
			mouseEnabled = false;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoaderInfoProgress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoaderInfoIoError);
			
			_container = new Sprite();
			
			var background:Bitmap = new AssetScoreBackground();
			var ring:Bitmap = new AssetHUD();
			var barBackground:Bitmap = new AssetLoadingBackground();
			var bar:Bitmap = new AssetLoadingBar();
			
			//_adContainer = new Sprite();
			//_adContainer.graphics.beginFill(0, 0.5);
			//_adContainer.graphics.drawRoundRect(-5, -5, 310, 260, 11);
			//_adContainer.graphics.endFill();
			//
			//_adContainer.x = 150;
			//_adContainer.y = 120;
			
			_mask = new Shape();
			_mask.graphics.beginFill(0);
			_mask.graphics.drawRect(0, 0, 283, 17);
			_mask.graphics.endFill();
			_mask.x = 159;
			_mask.y = 412;
			
			_numbers = new GameText();
			_numbers.text = "0%";
			_numbers.width = 289;
			_numbers.height = _numbers.textHeight;
			_numbers.x = 159;
			_numbers.y = 433;
			
			background.x = 15;
			background.y = 15;
			
			barBackground.x = 156;
			barBackground.y = 406;
			
			bar.x = 159;
			bar.y = 412;
			bar.mask = _mask;
			
			_playButton = new GameButton("Play", startup);
			_playButton.visible = false;
			_playButton.alpha = 0;
			_playButton.x = 205;
			_playButton.y = 475;
			
			_container.addChild(background);
			_container.addChild(ring);
			_container.addChild(barBackground);
			_container.addChild(bar);
			_container.addChild(_playButton);
			_container.addChild(_mask);
			_container.addChild(_numbers);
			
			addChild(_container);
			
			if (stage)
			{
				onAddedToStage();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
			
			_adContainer = FGLHelper.connect()
			addChild(_adContainer);
			
			_timer = new Timer(1000, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerTimerComplete);
			_timer.start();
		}
		
		private function onTimerTimerComplete(event:TimerEvent):void
		{
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerTimerComplete);
			_adReady = true;
		}
		
		private function onAddedToStage(event:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
		
		private function onEnterFrame(event:Event):void
		{
			if (!_loadReady && currentFrame == totalFrames)
			{
				stop();
				loadingFinished();
			}
			
			if (!_adReady)
			{
				if (FGLHelper.ready)
				{
					_adReady = true;
					FGLHelper.showAdd(FGLAds.FORMAT_300x250, 0);
					
				}
				else if (FGLHelper.failed)
				{
					_adReady = true;
				}
				
			}
			else if (_loadReady)
			{
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				
				_playButton.visible = true;
				TweenMax.to(_playButton, 0.75, {alpha: 1, ease: Cubic.easeOut});
			}
		}
		
		private function onLoaderInfoProgress(event:ProgressEvent):void
		{
			var loaded:Number = event.bytesLoaded / event.bytesTotal;
			
			_mask.scaleX = loaded;
			_numbers.text = int(loaded * 100) + "%";
		}
		
		private function onLoaderInfoIoError(event:IOErrorEvent):void
		{
			trace(event.text);
		}
		
		private function loadingFinished():void
		{
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoaderInfoProgress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderInfoIoError);
			
			_loadReady = true;
		}
		
		private function startup():void
		{
			removeChild(_container);
			removeChild(_adContainer);
			
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerTimerComplete);
			_timer = null;
			
			_container = null;
			_mask = null;
			_numbers = null;
			_playButton = null;
			
			System.pauseForGCIfCollectionImminent(0);
			
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass() as DisplayObject);
		}
	}
}