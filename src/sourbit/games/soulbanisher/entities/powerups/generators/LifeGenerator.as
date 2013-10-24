package sourbit.games.soulbanisher.entities.powerups.generators
{
	import sourbit.games.soulbanisher.entities.hero.Hero;
	import sourbit.games.soulbanisher.entities.powerups.LifePowerUp;
	import sourbit.games.soulbanisher.entities.powerups.PowerUp;
	
	public class LifeGenerator extends PowerUpGenerator
	{
		private var _hero:Hero;
		private var _cuteCombo:int;
		private var _uglyCombo:int;
		private var _monsterCount:int;
		
		private var _defaultChance:Number;
		private var _accumulated:Number;
		
		public function LifeGenerator(hero:Hero)
		{
			_hero = hero;
			_defaultChance = 0.1;
			_accumulated = _defaultChance;
		}
		
		override public function generate():PowerUp
		{
			if (_hero.lifes < 3)
			{
				var chance:Number = (_cuteCombo / _monsterCount * (1 - _uglyCombo / _cuteCombo) + _accumulated) * _accumulated;
				if (isNaN(chance))
				{
					chance = 0;
				}
				
				if (chance > Math.random())
				{
					_accumulated = _defaultChance;
					return new LifePowerUp();
				}
				else
				{
					_accumulated += chance;
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