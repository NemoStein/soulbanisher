package sourbit.games.soulbanisher.entities.powerups
{
	import sourbit.games.soulbanisher.audio.PowerUpProtectionAudio;
	import sourbit.games.soulbanisher.GamePlay;
	
	public class ProtectionPowerUp extends PowerUp
	{
		[Embed(source="../../assets/powerUpProtection.png")]
		static private const Asset:Class;
		
		override public function execute():void
		{
			GamePlay.protectWizard();
			
			super.execute();
		}
		
		override public function get assetClass():Class 
		{
			return Asset;
		}
		
		override protected function get soundClass():Class 
		{
			return null;
		}
	}
}