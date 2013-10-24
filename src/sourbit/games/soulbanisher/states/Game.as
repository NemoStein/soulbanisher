package sourbit.games.soulbanisher.states
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import sourbit.games.soulbanisher.BackgroundMusic;
	import sourbit.games.soulbanisher.entities.Crosshair;
	import sourbit.games.soulbanisher.entities.hero.Hero;
	import sourbit.games.soulbanisher.entities.monsters.Monster;
	import sourbit.games.soulbanisher.entities.powerups.generators.LifeGenerator;
	import sourbit.games.soulbanisher.entities.powerups.generators.NukeGenerator;
	import sourbit.games.soulbanisher.entities.powerups.generators.PowerUpGenerator;
	import sourbit.games.soulbanisher.entities.powerups.generators.ProtectionGenerator;
	import sourbit.games.soulbanisher.entities.powerups.PowerUp;
	import sourbit.games.soulbanisher.GamePlay;
	
	public class Game extends State
	{
		private var _crosshair:Crosshair;
		
		private var _container:Sprite;
		private var _hero:Hero;
		private var _monsters:Vector.<Monster>;
		private var _powerups:Vector.<PowerUp>;
		
		public function Game()
		{
			_crosshair = new Crosshair();
			_monsters = new Vector.<Monster>();
			_powerups = new Vector.<PowerUp>();
			_container = new Sprite();
			_hero = new Hero();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			Mouse.hide();
			
			GamePlay.paused = false;
			GamePlay.reset();
			GamePlay.hud.showInGame();
			
			BackgroundMusic.playGameMusic();
			
			_hero.x = (600 - _hero.width) * 0.5;
			_hero.y = (600 - _hero.height) * 0.5;
			
			GamePlay.hero = _hero;
			GamePlay.monsters = _monsters;
			GamePlay.powerups = _powerups;
			GamePlay.container = _container;
			
			_container.addChild(_hero);
			
			addChild(_container);
			addChild(_crosshair);
			
			for (var i:int = 0; i < GamePlay.monsterCount; ++i)
			{
				GamePlay.addMonster(createMonster());
			}
			
			PowerUpGenerator.lifeGenerator = new LifeGenerator(_hero);
			PowerUpGenerator.nukeGenerator = new NukeGenerator();
			PowerUpGenerator.protectionGenerator = new ProtectionGenerator();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onStageKeyDown);
		}
		
		private function onStageKeyDown(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.K:
				{
					GamePlay.useKeyboard = !GamePlay.useKeyboard;
					break;
				}
				
				case Keyboard.P:
				{
					GamePlay.paused = !GamePlay.paused;
					break;
				}
				
				case Keyboard.ESCAPE:
				{
					GamePlay.enterMainMenu()
					break;
				}
			}
		}
		
		override protected function update():void
		{
			if (_hero.dead)
			{
				return;
			}
			
			var distanceX:Number;
			var distanceY:Number;
			var distance:Number;
			
			for (var j:int = 0; j < _powerups.length; ++j)
			{
				var powerUp:PowerUp = _powerups[j];
				
				distanceX = _hero.x - powerUp.x;
				distanceY = _hero.y - powerUp.y;
				distance = Math.sqrt(distanceX * distanceX + distanceY * distanceY);
				
				if (distance < 35)
				{
					powerUp.execute();
				}
			}
			
			if (_monsters.length < GamePlay.monsterCount)
			{
				var randomCount:int = int(Math.random() * (GamePlay.monsterCount - _monsters.length) + 0.5);
				
				for (var k:int = 0; k < randomCount; ++k)
				{
					if (Math.random() < 0.1)
					{
						GamePlay.addMonster(createMonster());
					}
				}
			}
			
			if (!_hero.invincible && !_hero.dead)
			{
				for (var i:int = 0; i < _monsters.length; ++i)
				{
					var monster:Monster = _monsters[i];
					
					if (monster.dead || !monster.aggressive)
					{
						continue;
					}
					
					distanceX = _hero.x - monster.x;
					distanceY = _hero.y - monster.y;
					distance = Math.sqrt(distanceX * distanceX + distanceY * distanceY);
					
					if (distance < 35)
					{
						_hero.hit();
						break;
					}
				}
			}
		}
		
		private function createMonster():Monster
		{
			var monster:Monster = GamePlay.getPooledMonster();
			var angle:Number = Math.random() * Math.PI * 2;
			
			monster.x = Math.cos(angle) * 285 + 300;
			monster.y = Math.sin(angle) * 285 + 300;
			monster.rotation = Math.random() * 360;
			
			return monster;
		}
		
		override public function resumeCursor():void
		{
			super.resumeCursor();
			
			Mouse.hide();
		}
		
		override public function pause(value:Boolean):void
		{
			super.pause(value);
			
			if (value)
			{
				GamePlay.pauseOverlay.show();
			}
			else
			{
				GamePlay.pauseOverlay.hide();
			}
		}
		
		override public function dispose():void
		{
			GamePlay.hud.reset();
			
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onStageKeyDown);
			
			_hero.dispose();
			_crosshair.dispose();
			
			for each (var powerUp:PowerUp in _powerups)
			{
				powerUp.dispose();
			}
			
			for each (var monster:Monster in _monsters)
			{
				monster.dispose();
			}
			
			super.dispose();
		}
	}
}