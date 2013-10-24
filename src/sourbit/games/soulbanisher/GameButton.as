package sourbit.games.soulbanisher
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import sourbit.games.soulbanisher.audio.ClickAudio;
	
	public class GameButton extends Sprite
	{
		[Embed(source="assets/buttonBase.png")]
		static private const AssetButtonBase:Class;
		
		private var _callback:Function;
		private var _sound:SoundManager;
		
		public function GameButton(label:String, callback:Function)
		{
			_callback = callback;
			
			mouseChildren = false;
			buttonMode = true;
			
			var buttonBase:Bitmap = new AssetButtonBase();
			var gameText:GameText = new GameText();
			
			_sound = new SoundManager(ClickAudio);
			
			gameText.text = label;
			gameText.width = gameText.textWidth;
			gameText.height = gameText.textHeight;
			
			gameText.x = (buttonBase.width - gameText.width) * 0.5;
			gameText.y = (buttonBase.height - gameText.height) * 0.5;
			
			addChild(buttonBase);
			addChild(gameText);
			
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(event:MouseEvent):void 
		{
			_sound.play();
			_callback();
		}
	}
}