package sourbit.games.soulbanisher
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.system.System;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.utils.getTimer;
	import sourbit.games.soulbanisher.entities.Entity;
	import sourbit.games.soulbanisher.states.Tutorial;
	
	public class SoulBanisher extends Entity
	{
		[Embed(source="assets/background.png")]
		static private const AssetBackground:Class;
		
		private var _underLayer:Sprite;
		private var _overLayer:Sprite;
		
		private var _hud:HUD;
		private var _tutorial:Tutorial;
		
		private var _started:Boolean;
		private var _instructed:Boolean;
		private var _initialized:Boolean;
		
		private var _now:int;
		private var _early:int;
		
		override protected function initialize():void
		{
			stage.addEventListener(Event.DEACTIVATE, onStageDeactivate);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onStageKeyDown);
			
			mouseChildren = true;
			ignorePause = true;
			
			Entity.time = 0;
			GamePlay.soulBanisher = this;
			GamePlay.hud = new HUD();
			GamePlay.reset();
			
			_underLayer = new Sprite();
			_overLayer = new Sprite();
			
			_underLayer.mouseEnabled = false;
			_overLayer.mouseEnabled = false;
			
			GamePlay.pauseOverlay = new PauseOverlay();
			
			_overLayer.addChild(GamePlay.hud);
			_overLayer.addChild(GamePlay.pauseOverlay);
			
			addChild(new AssetBackground());
			addChild(_underLayer);
			addChild(_overLayer);
		}
		
		override protected function update():void
		{
			_now = getTimer();
			time = (_now - _early) / 1000;
			_early = _now;
			
			if (!_initialized)
			{
				_initialized = true;
				
				GamePlay.enterMainMenu();
			}
		}
		
		private function onStageKeyDown(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.M)
			{
				var soundTransform:SoundTransform = SoundMixer.soundTransform;
				
				if (soundTransform.volume == 1)
				{
					soundTransform.volume = 0;
				}
				else
				{
					soundTransform.volume = 1;
				}
				
				SoundMixer.soundTransform = soundTransform;
			}
		}
		
		public function changeState(StateClass:Class):void
		{
			if (GamePlay.currentState)
			{
				GamePlay.currentState.dispose();
				_underLayer.removeChild(GamePlay.currentState);
			}
			
			GamePlay.currentState = new StateClass();
			GamePlay.currentState.resumeCursor();
			_underLayer.addChild(GamePlay.currentState);
			
			System.pauseForGCIfCollectionImminent(0);
		}
		
		private function onStageDeactivate(event:Event):void
		{
			Mouse.show();
			GamePlay.paused = true;
			
			GamePlay.pauseOverlay.show();
		}
	}
}