package sourbit.games.soulbanisher
{
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.system.System;
	import sourbit.games.soulbanisher.entities.Entity;
	import sourbit.games.soulbanisher.tracking.FGLHelper;
	
	public class PauseOverlay extends Entity
	{
		private var _text:GameText;
		private var _adContainer:MovieClip;
		
		override protected function initialize():void
		{
			ignorePause = true;
			mouseEnabled = true;
			mouseChildren = true;
			
			visible = false;
			
			_text = new GameText();
			_text.text = "Click here to continue";
			_text.width = _text.textWidth;
			_text.height = _text.textHeight;
			_text.buttonMode = true;
			_text.x = (600 - _text.width) * 0.5;
			_text.y = (600 - _text.height) * 0.8;
			
			//_adContainer = new MovieClip();
			//_adContainer.graphics.beginFill(0, 0.5);
			//_adContainer.graphics.drawRoundRect(-5, -5, 310, 260, 11);
			//_adContainer.graphics.endFill();
			//
			//_adContainer.x = 150;
			//_adContainer.y = 120;
			
			addChild(_text);
			addChild(FGLHelper.container);
			
			_text.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		public function show():void
		{
			if (!visible)
			{
				System.pauseForGCIfCollectionImminent(0);
				TweenMax.pauseAll();
				
				FGLHelper.showAdd(FGLAds.FORMAT_300x250, 0);
				visible = true;
				
				graphics.clear();
				graphics.beginFill(0, 0.8);
				graphics.drawRect(0, 0, 600, 600);
				graphics.endFill();
			}
		}
		
		public function hide():void
		{
			visible = false;
			
			System.pauseForGCIfCollectionImminent(0);
			TweenMax.resumeAll();
		}
		
		private function onClick(event:MouseEvent):void
		{
			hide();
			
			GamePlay.paused = false;
		}
	}
}