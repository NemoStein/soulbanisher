package sourbit.games.soulbanisher.entities.monsters
{
	import flash.display.Bitmap;
	import sourbit.games.soulbanisher.audio.SoulDeathAudio;
	import sourbit.games.soulbanisher.views.GhostView;
	
	public class CuteMonster extends Monster
	{
		override protected function initialize():void
		{
			super.initialize();
			
			view = new GhostView();
			view.rotation = -90;
			view.scaleX = view.scaleY = 0.2;
			
			addChild(view);
		}
		
		override protected function get soundClass():Class 
		{
			return SoulDeathAudio;
		}
	}
}