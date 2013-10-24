package sourbit.games.soulbanisher
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import sourbit.games.soulbanisher.entities.Entity;
	import sourbit.games.soulbanisher.entities.popups.ScorePopup;
	
	public class HUD extends Entity
	{
		[Embed(source="assets/hud.png")]
		static private const AssetHUD:Class;
		
		[Embed(source="assets/life.png")]
		static private const AssetLife:Class;
		
		[Embed(source="assets/lifeSlots.png")]
		static private const AssetLifeSlots:Class;
		
		[Embed(source="assets/scoreTypes.png")]
		static private const AssetScoreTypes:Class;
		
		private var _pointsLabel:GameText;
		private var _pointsCount:GameText;
		private var _cuteCount:GameText;
		private var _uglyCount:GameText;
		private var _scoreTypes:Bitmap;
		private var _lifes:Sprite;
		private var _lifeSlots:Bitmap;
		private var _life1:Bitmap;
		private var _life2:Bitmap;
		private var _life3:Bitmap;
		
		private var _menuText:GameText;
		private var _pauseText:GameText;
		private var _keyboardText:GameText;
		private var _muteText:GameText;
		
		public function HUD()
		{
			_menuText = new GameText();
			_pauseText = new GameText();
			_keyboardText = new GameText();
			_muteText = new GameText();
			
			_pointsLabel = new GameText();
			_pointsCount = new GameText();
			_cuteCount = new GameText();
			_uglyCount = new GameText();
			
			_scoreTypes = new AssetScoreTypes();
			_lifeSlots = new AssetLifeSlots();
			_life1 = new AssetLife();
			_life2 = new AssetLife();
			_life3 = new AssetLife();
			
			_lifes = new Sprite();
			_lifes.addChild(_lifeSlots);
			_lifes.addChild(_life1);
			_lifes.addChild(_life2);
			_lifes.addChild(_life3);
			
			addChild(new AssetHUD());
			
			addChild(_pointsLabel);
			addChild(_pointsCount);
			addChild(_scoreTypes);
			addChild(_cuteCount);
			addChild(_uglyCount);
			addChild(_lifes);
			
			addChild(_menuText);
			addChild(_pauseText);
			addChild(_keyboardText);
			addChild(_muteText);
			
			hideAll();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			_menuText.text = "press ESC to exit";
			_menuText.width = _menuText.textWidth;
			_menuText.scaleX = _menuText.scaleY = 0.625;
			_menuText.x = 5;
			_menuText.y = 555;
			
			_pauseText.text = "press P to pause";
			_pauseText.width = _pauseText.textWidth;
			_pauseText.scaleX = _pauseText.scaleY = 0.625;
			_pauseText.x = 5;
			_pauseText.y = 565;
			
			_keyboardText.text = "press K to use keyboard";
			_keyboardText.width = _keyboardText.textWidth;
			_keyboardText.scaleX = _keyboardText.scaleY = 0.625;
			_keyboardText.x = 5;
			_keyboardText.y = 575;
			
			_muteText.text = "press M to mute";
			_muteText.width = _muteText.textWidth;
			_muteText.scaleX = _muteText.scaleY = 0.625;
			_muteText.x = 5;
			_muteText.y = 585;
			
			_pointsLabel.text = "Points:";
			_pointsLabel.width = 600;
			
			_pointsCount.text = "0";
			_pointsCount.width = 600;
			_pointsCount.y = 18;
			
			_cuteCount.text = "0";
			_cuteCount.width = 585;
			_cuteCount.y = 40;
			
			_uglyCount.text = "0";
			_uglyCount.width = 585;
			_uglyCount.y = 58;
			
			_scoreTypes.x = 581;
			_scoreTypes.y = 41;
			
			_lifeSlots.x = 48;
			_lifeSlots.y = 39;
			
			_life1.x = 95;
			_life1.y = 40;
			
			_life2.x = 71;
			_life2.y = 62;
			
			_life3.x = 49;
			_life3.y = 86;
		}
		
		public function setPoints(points:int, cute:int, ugly:int):void
		{
			_pointsCount.text = String(points);
			_cuteCount.text = String(cute);
			_uglyCount.text = String(ugly);
		}
		
		public function setLifes(lifes:int):void
		{
			_life1.visible = (lifes > 2);
			_life2.visible = (lifes > 1);
			_life3.visible = (lifes > 0);
		}
		
		public function showComboScore(points:int, cute:int, ugly:Number):void
		{
			var scorePopup:ScorePopup = new ScorePopup(points, cute, ugly);
			
			scorePopup.x = GamePlay.hero.x;
			scorePopup.y = GamePlay.hero.y;
			
			addChild(scorePopup);
		}
		
		public function showInGame():void
		{
			_pointsLabel.visible = true;
			_pointsCount.visible = true;
			_cuteCount.visible = true;
			_uglyCount.visible = true;
			_scoreTypes.visible = true;
			_lifes.visible = true;
			
			_menuText.visible = true;
			_pauseText.visible = true;
			_keyboardText.visible = true;
		}
		
		public function reset():void
		{
			hideAll();
			
			_muteText.visible = true;
			
			setPoints(0, 0, 0);
			setLifes(3);
			
			_pointsCount.text = "0";
			_cuteCount.text = "0";
			_uglyCount.text = "0";
		}
		
		public function hideAll():void
		{
			_pointsLabel.visible = false;
			_pointsCount.visible = false;
			_cuteCount.visible = false;
			_uglyCount.visible = false;
			_scoreTypes.visible = false;
			_lifes.visible = false;
			
			_menuText.visible = false;
			_pauseText.visible = false;
			_keyboardText.visible = false;
			_muteText.visible = false;
		}
	}
}