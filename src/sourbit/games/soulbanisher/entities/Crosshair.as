package sourbit.games.soulbanisher.entities
{
	
	public class Crosshair extends Entity
	{
		override protected function initialize():void
		{
			graphics.beginFill(0, 0.5);
			graphics.drawCircle(0, 0, 2.5);
			graphics.endFill();
		}
		
		override protected function update():void
		{
			super.update();
			
			x = stage.mouseX;
			y = stage.mouseY;
		}
	}
}