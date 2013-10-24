package sourbit.games.soulbanisher
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.ui.Mouse;
	import mochi.as3.MochiDigits;
	import sourbit.games.soulbanisher.entities.hero.Bubble;
	import sourbit.games.soulbanisher.entities.hero.Hero;
	import sourbit.games.soulbanisher.entities.monsters.CuteMonster;
	import sourbit.games.soulbanisher.entities.monsters.Monster;
	import sourbit.games.soulbanisher.entities.monsters.UglyMonster;
	import sourbit.games.soulbanisher.entities.powerups.generators.PowerUpGenerator;
	import sourbit.games.soulbanisher.entities.powerups.PowerUp;
	import sourbit.games.soulbanisher.states.Credits;
	import sourbit.games.soulbanisher.states.Game;
	import sourbit.games.soulbanisher.states.MainMenu;
	import sourbit.games.soulbanisher.states.ScoreScreen;
	import sourbit.games.soulbanisher.states.State;
	import sourbit.games.soulbanisher.states.Tutorial;
	
	public class GamePlay
	{
		static private const MONSTER_COUNT:int = 10;
		
		static private var _cuteCount:int;
		static private var _uglyCount:int;
		static private var _paused:Boolean;
		
		static public var soulBanisher:SoulBanisher;
		static public var bubbleGrowing:Boolean;
		static public var currentState:State;
		static public var pauseOverlay:PauseOverlay;
		
		static public var hud:HUD;
		static public var hero:Hero;
		static public var container:Sprite;
		static public var monsters:Vector.<Monster>;
		static public var powerups:Vector.<PowerUp>;
		
		static private var _cutePool:Vector.<Monster>;
		static private var _uglyPool:Vector.<Monster>;
		static private var _addClip:MovieClip;
		
		static public var score:MochiDigits;
		static public var scoreCuteCount:MochiDigits;
		static public var scoreUglyCount:MochiDigits;
		
		static public var useKeyboard:Boolean;
		
		static public function hitMonsters(scale:Number):void
		{
			var radius:Number = Bubble.MAX_RADIUS * scale;
			var cuteCombo:int;
			var uglyCombo:int;
			
			for (var i:int = 0; i < monsters.length; ++i)
			{
				var monster:Monster = monsters[i];
				if (monster.dead)
				{
					continue;
				}
				
				var distanceX:Number = hero.x - monster.x;
				var distanceY:Number = hero.y - monster.y;
				var distance:Number = Math.sqrt(distanceX * distanceX + distanceY * distanceY);
				
				if (distance < radius)
				{
					monster.die();
					
					if (monster is CuteMonster)
					{
						cuteCombo++;
					}
					else
					{
						uglyCombo++;
					}
				}
			}
			
			addScore(cuteCombo, uglyCombo);
		}
		
		static public function addMonster(monster:Monster):void
		{
			if (monster is CuteMonster)
			{
				_cuteCount++;
			}
			else
			{
				_uglyCount++;
			}
			
			monsters.push(monster);
			container.addChild(monster);
		}
		
		static public function removeMonster(monster:Monster):void
		{
			if (monsters && monster)
			{
				if (monster is CuteMonster)
				{
					_cuteCount--;
					_cutePool.push(monster);
				}
				else
				{
					_uglyCount--;
					_uglyPool.push(monster);
				}
				
				monsters.splice(monsters.indexOf(monster), 1);
				container.removeChild(monster);
			}
		}
		
		static public function addPowerUp(powerUp:PowerUp):void
		{
			powerups.push(powerUp);
			container.addChild(powerUp);
		}
		
		static public function removePowerUp(powerUp:PowerUp):void
		{
			powerups.splice(powerups.indexOf(powerUp), 1);
			container.removeChild(powerUp);
		}
		
		static private function addScore(cuteCombo:int, uglyCombo:int):void
		{
			var cuteScore:Number = cuteCombo * cuteCombo;
			var uglyScore:Number = 1 - uglyCombo / cuteCombo;
			
			if (isNaN(uglyScore))
			{
				uglyScore = 1;
			}
			else if (uglyScore < 0)
			{
				uglyScore = 0;
			}
			
			var comboScore:Number = cuteScore * uglyScore;
			
			scoreCuteCount.addValue(cuteCombo);
			scoreUglyCount.addValue(uglyCombo);
			score.addValue(comboScore);
			
			hud.showComboScore(comboScore, cuteScore, uglyScore);
			hud.setPoints(score.value, scoreCuteCount.value, scoreUglyCount.value);
			
			PowerUpGenerator.lifeGenerator.feed(cuteCombo, uglyCombo, monsters.length);
			PowerUpGenerator.nukeGenerator.feed(cuteCombo, uglyCombo, monsters.length);
			PowerUpGenerator.protectionGenerator.feed(cuteCombo, uglyCombo, monsters.length);
			
			var powerUp:PowerUp = PowerUpGenerator.pickPowerUp();
			if (powerUp)
			{
				addPowerUp(powerUp);
			}
		}
		
		static public function setLifes(lifes:int):void
		{
			hud.setLifes(lifes);
		}
		
		static public function reset():void
		{
			bubbleGrowing = false;
			hero = null;
			container = null;
			monsters = null;
			score = new MochiDigits(0);
			scoreCuteCount = new MochiDigits(0);
			scoreUglyCount = new MochiDigits(0);
			
			_cutePool = new Vector.<Monster>();
			_uglyPool = new Vector.<Monster>();
			
			hud.reset();
		}
		
		static public function enterNewGame():void
		{
			soulBanisher.changeState(Game);
		}
		
		static public function enterMainMenu():void
		{
			soulBanisher.changeState(MainMenu);
		}
		
		static public function enterTutorial():void
		{
			soulBanisher.changeState(Tutorial);
		}
		
		static public function enterScoreScreen():void
		{
			soulBanisher.changeState(ScoreScreen);
		}
		
		static public function enterCredits():void
		{
			soulBanisher.changeState(Credits);
		}
		
		static public function addLife():void
		{
			if (hero.lifes < 3)
			{
				setLifes(++hero.lifes);
			}
		}
		
		static public function showScoreScreen():void
		{
			for each (var monster:Monster in monsters)
			{
				monster.dispose();
			}
			
			for each (var powerUp:PowerUp in powerups)
			{
				powerUp.dispose();
			}
			
			enterScoreScreen();
		}
		
		static public function showInterAdd():void
		{
			if (!_addClip)
			{
				_addClip = new MovieClip();
				soulBanisher.addChild(_addClip);
			}
			
			// TODO: Show InterAdd
		}
		
		static public function protectWizard():void
		{
			hero.protect();
		}
		
		static public function nuke():void
		{
			hitMonsters(5);
			hero.nuke();
		}
		
		static public function getPooledMonster():Monster
		{
			var monster:Monster;
			
			if (GamePlay.uglyCount < GamePlay.cuteCount * 0.05)
			{
				monster = _uglyPool.length ? _uglyPool.pop() : new UglyMonster();
			}
			else
			{
				monster = _cutePool.length ? _cutePool.pop() : new CuteMonster();
			}
			
			monster.reset();
			return monster;
		}
		
		static public function get monsterCount():int
		{
			return MONSTER_COUNT + int(Math.sqrt(score.value));
		}
		
		static public function get cuteCount():int
		{
			return _cuteCount;
		}
		
		static public function get uglyCount():int
		{
			return _uglyCount;
		}
		
		static public function get paused():Boolean
		{
			return _paused;
		}
		
		static public function set paused(value:Boolean):void
		{
			if (value)
			{
				Mouse.show();
			}
			else
			{
				currentState.resumeCursor();
			}
			
			currentState.pause(value);
			_paused = value;
		}
	}
}