package sourbit.games.soulbanisher.entities.monsters
{
	import flash.display.Bitmap;
	import sourbit.games.soulbanisher.audio.SkullDeathAudio;
	import sourbit.games.soulbanisher.GamePlay;
	import sourbit.games.soulbanisher.views.SkullView;
	
	public class UglyMonster extends Monster
	{
		override protected function initialize():void
		{
			super.initialize();
			
			view = new SkullView();
			view.rotation = -90;
			view.scaleX = view.scaleY = 0.2;
			
			addChild(view);
		}
		
		override protected function update():void
		{
			if (GamePlay.bubbleGrowing)
			{
				chase();
			}
			
			super.update();
		}
		
		override protected function get soundClass():Class 
		{
			return SkullDeathAudio;
		}
	}
}