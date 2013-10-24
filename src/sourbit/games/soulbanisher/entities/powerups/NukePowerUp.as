package sourbit.games.soulbanisher.entities.powerups
{
	import sourbit.games.soulbanisher.audio.PowerUpNukeAudio;
	import sourbit.games.soulbanisher.GamePlay;
	
	public class NukePowerUp extends PowerUp
	{
		[Embed(source="../../assets/powerUpNuke.png")]
		static private const Asset:Class;
		
		override public function execute():void
		{
			GamePlay.nuke();
			
			super.execute();
		}
		
		override public function get assetClass():Class 
		{
			return Asset;
		}
		
		override protected function get soundClass():Class 
		{
			return PowerUpNukeAudio;
		}
	}
}