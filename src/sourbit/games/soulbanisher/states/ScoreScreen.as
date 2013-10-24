package sourbit.games.soulbanisher.states
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.ui.Mouse;
	import sourbit.games.soulbanisher.BackgroundMusic;
	import sourbit.games.soulbanisher.entities.Entity;
	import sourbit.games.soulbanisher.GameButton;
	import sourbit.games.soulbanisher.GamePlay;
	import sourbit.games.soulbanisher.GameText;
	import sourbit.games.soulbanisher.ScoreData;
	import sourbit.games.soulbanisher.SoulBanisher;
	import sourbit.games.soulbanisher.tracking.MochiHelper;
	
	public class ScoreScreen extends State
	{
		[Embed(source="../assets/scoreBackground.png")]
		static private const AssetScoreBackground:Class;
		
		private var _scoreBackground:Bitmap;
		private var _currentScoreLabel:GameText;
		private var _currentScore:GameText;
		private var _highScoreLabel:GameText;
		private var _highScore:GameText;
		
		private var _playAgain:GameButton;
		private var _backToMain:GameButton;
		
		override protected function initialize():void
		{
			super.initialize();
			
			Mouse.show();
			
			BackgroundMusic.playMenuMusic();
			
			_scoreBackground = new AssetScoreBackground();
			_currentScoreLabel = new GameText();
			_currentScore = new GameText();
			_highScoreLabel = new GameText();
			_highScore = new GameText();
			_playAgain = new GameButton("Play Again", GamePlay.enterNewGame);
			_backToMain = new GameButton("Main Menu", GamePlay.enterMainMenu);
			
			_scoreBackground.x = 15;
			_scoreBackground.y = 15;
			
			_currentScoreLabel.text = "Your Score";
			_currentScoreLabel.width = _currentScoreLabel.textWidth;
			_currentScoreLabel.scaleX = _currentScoreLabel.scaleY = 2.5;
			_currentScoreLabel.x = (600 - _currentScoreLabel.width) * 0.5;
			_currentScoreLabel.y = 160;
			
			_currentScore.text = "0";
			_currentScore.y = 205;
			
			_highScoreLabel.text = "Your High Score";
			_highScoreLabel.width = _highScoreLabel.textWidth;
			_highScoreLabel.x = (600 - _highScoreLabel.width) * 0.5;
			_highScoreLabel.y = 290;
			
			_highScore.text = "0";
			_highScore.y = 320;
			
			_playAgain.x = (600 - _playAgain.width) * 0.5;
			_playAgain.y = 400;
			
			_backToMain.x = (600 - _backToMain.width) * 0.5;
			_backToMain.y = 470;
			
			var currentScore:int = GamePlay.score.value;
			var currentHighScore:int = ScoreData.getCurrentHighScore();
			
			if (currentScore > currentHighScore)
			{
				currentHighScore = currentScore;
				ScoreData.setCurrentHighScore(currentScore);
			}
			MochiHelper.submitScore(currentScore);
			
			_currentScore.text = String(currentScore);
			_currentScore.width = _currentScore.textWidth;
			_currentScore.scaleX = _currentScore.scaleY = 2.5;
			_currentScore.x = (600 - _currentScore.width) * 0.5;
			
			_highScore.text = String(currentHighScore);
			_highScore.width = _highScore.textWidth;
			_highScore.scaleX = _highScore.scaleY = 1.5;
			_highScore.x = (600 - _highScore.width) * 0.5;
			
			addChild(_scoreBackground);
			
			addChild(_currentScoreLabel);
			addChild(_currentScore);
			addChild(_highScoreLabel);
			addChild(_highScore);
			
			addChild(_playAgain);
			addChild(_backToMain);
			
			//GamePlay.showInterAdd();
		}
	}
}