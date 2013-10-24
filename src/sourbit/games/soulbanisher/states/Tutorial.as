package sourbit.games.soulbanisher.states
{
	import com.greensock.easing.Circ;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	import com.greensock.TimelineLite;
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import sourbit.games.soulbanisher.BackgroundMusic;
	import sourbit.games.soulbanisher.entities.Entity;
	import sourbit.games.soulbanisher.entities.hero.Bubble;
	import sourbit.games.soulbanisher.GameButton;
	import sourbit.games.soulbanisher.GamePlay;
	import sourbit.games.soulbanisher.GameText;
	import sourbit.games.soulbanisher.views.GhostView;
	import sourbit.games.soulbanisher.views.WizardView;
	
	public class Tutorial extends State
	{
		[Embed(source="../assets/powerUpLife.png")]
		static private const AssetPowerUpLife:Class;
		
		[Embed(source="../assets/powerUpNuke.png")]
		static private const AssetPowerUpNuke:Class;
		
		[Embed(source="../assets/powerUpProtection.png")]
		static private const AssetPowerUpProtection:Class;
		
		private var _ghostTimeline:TimelineLite;
		
		private var _hero:WizardView;
		private var _bubble:Bubble;
		private var _ghost:GhostView;
		private var _text1:GameText;
		private var _text2:GameText;
		private var _text3:GameText;
		private var _text4:GameText;
		private var _powerUp1:Bitmap;
		private var _powerUp2:Bitmap;
		private var _powerUp3:Bitmap;
		
		private var _backButton:GameButton;
		private var _playButton:GameButton;
		
		override protected function initialize():void
		{
			super.initialize();
			
			BackgroundMusic.playMenuMusic();
			
			mouseEnabled = true;
			mouseChildren = true;
			
			animate();
			
			_backButton = new GameButton("Back", onBackClick);
			_backButton.x = 205;
			_backButton.y = 80;
			
			_playButton = new GameButton("Play", onPlayClick);
			_playButton.x = 205;
			_playButton.y = 475;
			
			addChild(_backButton);
			addChild(_playButton);
		}
		
		private function onBackClick():void
		{
			GamePlay.enterMainMenu();
		}
		
		private function onPlayClick():void
		{
			GamePlay.enterNewGame();
		}
		
		private function animate():void
		{
			_text1 = new GameText();
			_text1.text = "Hold mouse button to charge your magic";
			_text1.width = _text1.textWidth;
			_text1.height = _text1.textHeight;
			_text1.x = (600 - _text1.width) * 0.5;
			_text1.y = (600 - _text1.height) * 0.4;
			_text1.alpha = 0;
			
			_text2 = new GameText();
			_text2.text = "Release to cast and banish souls around you";
			_text2.width = _text2.textWidth;
			_text2.height = _text2.textHeight;
			_text2.x = (600 - _text2.width) * 0.5;
			_text2.y = (600 - _text2.height) * 0.6;
			_text2.alpha = 0;
			
			_text3 = new GameText();
			_text3.text = "Be carefull and do not touch them";
			_text3.width = _text3.textWidth;
			_text3.height = _text3.textHeight;
			_text3.x = (600 - _text3.width) * 0.5;
			_text3.y = (600 - _text3.height) * 0.65;
			_text3.alpha = 0;
			
			_hero = new WizardView();
			_hero.x = 300;
			_hero.y = 300;
			_hero.scaleX = _hero.scaleY = 0.2;
			_hero.alpha = 0;
			
			_bubble = new Bubble(true);
			_bubble.x = 300;
			_bubble.y = 300;
			
			_ghost = new GhostView();
			_ghost.x = 600;
			_ghost.y = 415;
			_ghost.rotation = 45;
			_ghost.scaleX = _ghost.scaleY = 0.2;
			
			var timeline:TimelineLite = new TimelineLite();
			timeline.append(TweenMax.to(_hero, 0.5, {alpha: 1, ease: Cubic.easeOut}));
			timeline.append(TweenMax.to(_text1, 1.5, {alpha: 1, ease: Cubic.easeOut, onComplete: charge}));
			timeline.append(TweenMax.to(_text1, 1, {delay: 3, alpha: 0, ease: Cubic.easeIn}));
			timeline.append(TweenMax.to(_text2, 1.5, {alpha: 1, ease: Cubic.easeOut, onComplete: cast}));
			timeline.append(TweenMax.to(_text2, 1, {delay: 3, alpha: 0, ease: Cubic.easeOut, onComplete: wizardWalk}));
			timeline.append(TweenMax.to(_text3, 1.5, {alpha: 1, ease: Cubic.easeOut, onComplete: animatePowerUps}));
			timeline.append(TweenMax.to(_text3, 1, {delay: 3, alpha: 0, ease: Cubic.easeOut}));
			
			addChild(_bubble);
			addChild(_ghost);
			addChild(_hero);
			addChild(_text1);
			addChild(_text2);
			addChild(_text3);
		}
		
		private function charge():void
		{
			_hero.gotoAndPlay("cast");
			_bubble.grow();
			
			_ghostTimeline = new TimelineLite();
			
			_ghostTimeline.append(TweenMax.to(_ghost, 1, {y: 430, rotation: 90, ease: Cubic.easeOut}));
			_ghostTimeline.append(TweenMax.to(_ghost, 1, {y: 415, rotation: 135, ease: Cubic.easeIn}));
			_ghostTimeline.append(TweenMax.to(_ghost, 1, {y: 400, rotation: 90, ease: Cubic.easeOut}));
			_ghostTimeline.append(TweenMax.to(_ghost, 1, {y: 415, rotation: 45, ease: Cubic.easeIn, onComplete: loop}));
			
			TweenMax.to(_ghost, 10, {x: 0, ease: Linear.easeNone});
		}
		
		private function loop():void
		{
			if (_ghost.visible)
			{
				_ghostTimeline.restart();
			}
		}
		
		private function cast():void
		{
			_hero.gotoAndPlay("roam");
			_ghost.gotoAndPlay("death");
			_bubble.explode();
			
			TweenMax.killTweensOf(_ghost);
			
			_ghost.addEventListener(Event.COMPLETE, onGhostComplete);
		}
		
		private function wizardWalk():void
		{
			TweenMax.to(_hero, 5, {y: 620, ease: Linear.easeInOut})
		}
		
		private function onGhostComplete(event:Event):void
		{
			_ghost.visible = false;
		}
		
		private function animatePowerUps():void
		{
			_text4 = new GameText();
			_text4.text = "Pick up Power Ups to boost your power";
			_text4.width = _text4.textWidth;
			_text4.height = _text4.textHeight;
			_text4.x = (600 - _text4.width) * 0.5;
			_text4.y = (600 - _text4.height) * 0.4;
			_text4.alpha = 0;
			
			_powerUp1 = new AssetPowerUpLife();
			_powerUp2 = new AssetPowerUpNuke();
			_powerUp3 = new AssetPowerUpProtection();
			
			_powerUp1.y = 300;
			_powerUp2.y = 300;
			_powerUp3.y = 300;
			
			_powerUp1.x = 600;
			_powerUp2.x = 600;
			_powerUp3.x = 600;
			
			var timeline:TimelineLite = new TimelineLite();
			var timeline1:TimelineLite = new TimelineLite();
			var timeline2:TimelineLite = new TimelineLite();
			var timeline3:TimelineLite = new TimelineLite();
			
			timeline.append(TweenMax.to(_text4, 1.5, {delay: 1, alpha: 1, ease: Cubic.easeOut}));
			timeline.append(TweenMax.to(_text4, 1, {delay: 2, alpha: 0, ease: Cubic.easeIn, onComplete: restart}));
			
			timeline1.append(TweenMax.to(_powerUp1, 1.5, {x: 244, ease: Circ.easeOut}));
			timeline1.append(TweenMax.to(_powerUp1, 1.5, {delay: 2.5, x: -30, ease: Circ.easeOut}));
			
			timeline2.append(TweenMax.to(_powerUp2, 1.5, {delay: 0.25, x: 284, ease: Circ.easeOut}));
			timeline2.append(TweenMax.to(_powerUp2, 1.5, {delay: 2.5, x: -30, ease: Circ.easeOut}));
			
			timeline3.append(TweenMax.to(_powerUp3, 1.5, {delay: 0.5, x: 324, ease: Circ.easeOut}));
			timeline3.append(TweenMax.to(_powerUp3, 1.5, {delay: 2.5, x: -30, ease: Circ.easeOut}));
			
			addChild(_text4);
			addChild(_powerUp1);
			addChild(_powerUp2);
			addChild(_powerUp3);
		}
		
		private function restart():void
		{
			removeChild(_hero);
			removeChild(_bubble);
			removeChild(_ghost);
			removeChild(_text1);
			removeChild(_text2);
			removeChild(_text3);
			removeChild(_text4);
			removeChild(_powerUp1);
			removeChild(_powerUp2);
			removeChild(_powerUp3);
			
			animate();
			
			addChild(_playButton);
		}
		
		override public function dispose():void
		{
			TweenMax.killAll();
			
			super.dispose();
		}
	}
}