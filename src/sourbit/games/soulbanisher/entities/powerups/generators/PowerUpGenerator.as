package sourbit.games.soulbanisher.entities.powerups.generators
{
	import sourbit.games.soulbanisher.entities.powerups.PowerUp;
	
	public class PowerUpGenerator
	{
		static public var lifeGenerator:LifeGenerator;
		static public var nukeGenerator:NukeGenerator;
		static public var protectionGenerator:ProtectionGenerator;
		
		static public function pickPowerUp():PowerUp
		{
			var life:PowerUp = lifeGenerator.generate();
			var nuke:PowerUp = nukeGenerator.generate();
			var protection:PowerUp = protectionGenerator.generate();
			
			var powerUps:Vector.<PowerUp> = new Vector.<PowerUp>();
			
			if (life)
			{
				powerUps.push(life);
			}
			
			if (nuke)
			{
				powerUps.push(nuke);
			}
			
			if (protection)
			{
				powerUps.push(protection);
			}
			
			var count:int = powerUps.length;
			if(count)
			{
				return powerUps[int(Math.random() * count)];
			}
			
			return null;
		}
		
		public function generate():PowerUp 
		{
			return null;
		}
	}
}