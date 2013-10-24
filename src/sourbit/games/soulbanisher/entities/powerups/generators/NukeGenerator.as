package sourbit.games.soulbanisher.entities.powerups.generators
{
	import sourbit.games.soulbanisher.entities.powerups.NukePowerUp;
	import sourbit.games.soulbanisher.entities.powerups.PowerUp;
	
	public class NukeGenerator extends PowerUpGenerator
	{
		private var _cuteCombo:int;
		private var _uglyCombo:int;
		private var _monsterCount:int;
		private var _chance:Number;
		private var _defaultChance:Number;
		
		public function NukeGenerator()
		{
			_defaultChance = 0.015;
			_chance = _defaultChance;
		}
		
		override public function generate():PowerUp
		{
			if (_cuteCombo - _uglyCombo > 0)
			{
				if (Math.random() < _chance + Math.sqrt(_monsterCount) * 0.0025)
				{
					_chance = _defaultChance;
					return new NukePowerUp();
				}
				else
				{
					_chance += _defaultChance;
				}
			}
			
			return null;
		}
		
		public function feed(cuteCombo:int, uglyCombo:int, monsterCount:int):void
		{
			_cuteCombo = cuteCombo;
			_uglyCombo = uglyCombo;
			_monsterCount = monsterCount;
		}
	}
}