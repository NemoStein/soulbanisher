package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import sourbit.games.soulbanisher.SoulBanisher;
	
	[Frame(factoryClass="Preloader")]
	
	public class Main extends Sprite
	{
		public function Main():void
		{
			if (stage)
			{
				initialize();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, initialize);
			}
		}
		
		private function initialize(event:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			mouseEnabled = false;
			addChild(new SoulBanisher());
		}
	}
}