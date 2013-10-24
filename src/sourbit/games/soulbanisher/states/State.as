package sourbit.games.soulbanisher.states
{
	import flash.ui.Mouse;
	import sourbit.games.soulbanisher.entities.Entity;
	
	public class State extends Entity
	{
		protected var paused:Boolean;
		
		override protected function initialize():void
		{
			mouseChildren = true;
			
			super.initialize();
		}
		
		public function resumeCursor():void
		{
			Mouse.show();
		}
		
		public function pause(value:Boolean):void
		{
			paused = value;
		}
	}
}