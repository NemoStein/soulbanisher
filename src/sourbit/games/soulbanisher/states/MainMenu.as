package sourbit.games.soulbanisher.states
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import sourbit.games.soulbanisher.BackgroundMusic;
	import sourbit.games.soulbanisher.entities.hero.Bubble;
	import sourbit.games.soulbanisher.GameButton;
	import sourbit.games.soulbanisher.GamePlay;
	
	public class MainMenu extends State
	{
		[Embed(source="../assets/logo.png")]
		static private const AssetGameName:Class;
		
		private var _bubble:Bubble;
		
		override protected function initialize():void
		{
			super.initialize();
			
			GamePlay.paused = false;
			BackgroundMusic.playMenuMusic();
			
			var assetGameName:Bitmap = new AssetGameName();
			assetGameName.x = 125;
			assetGameName.y = 85;
			
			_bubble = new Bubble(true);
			_bubble.x = 300;
			_bubble.y = 300;
			_bubble.grow();
			
			var playButton:GameButton = new GameButton("Play", onPlayClick);
			var howToButton:GameButton = new GameButton("How To Play", onHowToPlayClick);
			var creditsButton:GameButton = new GameButton("Credits", onCreditsClick);
			
			playButton.x = 205;
			howToButton.x = 205;
			creditsButton.x = 205;
			
			playButton.y = 380;
			howToButton.y = 435;
			creditsButton.y = 490;
			
			addChild(_bubble);
			addChild(assetGameName);
			addChild(playButton);
			addChild(howToButton);
			addChild(creditsButton);
		}
		
		private function onPlayClick():void
		{
			GamePlay.enterNewGame();
		}
		
		private function onHowToPlayClick():void
		{
			GamePlay.enterTutorial();
		}
		
		private function onCreditsClick():void
		{
			GamePlay.enterCredits();
		}
		
		override public function dispose():void
		{
			_bubble.explode();
			_bubble.dispose();
			
			super.dispose();
		}
	}
}