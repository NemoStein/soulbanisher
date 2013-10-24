package sourbit.games.soulbanisher.entities.powerups
{
	import sourbit.games.soulbanisher.audio.PowerUpLifeAudio;
	import sourbit.games.soulbanisher.GamePlay;
	
	public class LifePowerUp extends PowerUp
	{
		[Embed(source="../../assets/powerUpLife.png")]
		static private const Asset:Class;
		
		override public function execute():void
		{
			GamePlay.addLife();
			
			super.execute();
		}
		
		override public function get assetClass():Class 
		{
			return Asset;
		}
		
		override protected function get soundClass():Class 
		{
			return PowerUpLifeAudio;
		}
	}
}