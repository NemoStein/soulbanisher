package sourbit.games.soulbanisher
{
	import sourbit.games.soulbanisher.audio.GameBGMAudio;
	import sourbit.games.soulbanisher.audio.MenuBGMAudio;
	
	public class BackgroundMusic
	{
		static private var _menu:SoundManager;
		static private var _game:SoundManager;
		
		static private var _playingMenu:Boolean;
		static private var _playingGame:Boolean;
		
		{
			_menu = new SoundManager(MenuBGMAudio, true);
			_menu.volume = 0.25;
			
			_game = new SoundManager(GameBGMAudio, true);
			_game.volume = 0.25;
		}
		
		static public function playGameMusic():void
		{
			if (_playingMenu)
			{
				_playingMenu = false;
				_menu.fadeOut();
			}
			
			if (!_playingGame)
			{
				_playingGame = true;
				_game.fadeIn();
			}
		}
		
		static public function playMenuMusic():void
		{
			if (_playingGame)
			{
				_playingGame = false;
				_game.fadeOut();
			}
			if (!_playingMenu)
			{
				_playingMenu = true;
				_menu.fadeIn();
			}
		}
	}
}