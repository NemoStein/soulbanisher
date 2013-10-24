package sourbit.games.soulbanisher.entities
{
	import flash.display.Sprite;
	import flash.events.Event;
	import sourbit.games.soulbanisher.entities.hero.Hero;
	import sourbit.games.soulbanisher.GamePlay;
	
	public class Entity extends Sprite
	{
		static public var time:Number;
		
		public var ignorePause:Boolean;
		public var dead:Boolean;
		
		public function Entity()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			mouseEnabled = false;
			mouseChildren = false;
			
			initialize();
		}
		
		private function onEnterFrame(event:Event):void
		{
			if (!dead && (ignorePause || !GamePlay.paused))
			{
				update();
			}
		}
		
		protected function initialize():void
		{
		
		}
		
		protected function update():void
		{
		
		}
		
		public function die():void
		{
			dead = true;
		}
		
		public function dispose():void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
	}
}