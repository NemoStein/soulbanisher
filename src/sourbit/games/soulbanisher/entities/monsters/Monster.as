package sourbit.games.soulbanisher.entities.monsters
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import sourbit.games.soulbanisher.entities.Entity;
	import sourbit.games.soulbanisher.entities.hero.Hero;
	import sourbit.games.soulbanisher.GamePlay;
	import sourbit.games.soulbanisher.SoundManager;
	import sourbit.library.utils.MathUtils;
	
	public class Monster extends Entity
	{
		static private const MOVE_SPEED:Number = 85;
		static private const TURN_SPEED:Number = 65;
		
		public var aggressive:Boolean;
		
		private var _randomAngle:Number;
		private var _hero:Hero;
		private var _sound:SoundManager;
		
		private var _deathTimer:Number;
		
		protected var view:MovieClip;
		
		override protected function initialize():void
		{
			_sound = new SoundManager(soundClass);
			_sound.volume = Math.random() + 0.5;
			
			reset();
		}
		
		override protected function update():void
		{
			if (_deathTimer >= 0)
			{
				_deathTimer -= time;
				
				if (_deathTimer <= 0)
				{
					super.die();
					
					view.addEventListener(Event.COMPLETE, onComplete);
					view.gotoAndPlay("death");
					_sound.play();
				}
			}
			else
			{
				roam();
				wrapAround();
			}
		}
		
		protected function roam():void
		{
			var moveSpeed:Number = MOVE_SPEED * time;
			var turnSpeed:Number = TURN_SPEED * time;
			var targetDistance:Number = 10;
			var targetRadius:Number = 0.5;
			var targetVariance:Number = 0.75;
			
			var angle:Number = MathUtils.rad(rotation);
			
			if (isNaN(_randomAngle))
			{
				_randomAngle = angle;
			}
			
			var areaX:Number = x + Math.cos(angle) * targetDistance;
			var areaY:Number = y + Math.sin(angle) * targetDistance;
			
			var targetX:Number = areaX + Math.cos(_randomAngle) * targetRadius;
			var targetY:Number = areaY + Math.sin(_randomAngle) * targetRadius;
			
			_randomAngle = Math.atan2(targetY - areaY, targetX - areaX) + (Math.random() * targetVariance - targetVariance * 0.5);
			
			angle += MathUtils.piWrap(Math.atan2(targetY - y, targetX - x) - angle) * turnSpeed;
			
			x += Math.cos(angle) * moveSpeed;
			y += Math.sin(angle) * moveSpeed;
			rotation = MathUtils.deg(angle);
		}
		
		protected function chase():void
		{
			if (_hero.dead)
			{
				return;
			}
			
			var distanceX:Number = _hero.x - x;
			var distanceY:Number = _hero.y - y;
			
			if (distanceX || distanceY)
			{
				var moveSpeed:Number = MOVE_SPEED * time;
				var turnSpeed:Number = TURN_SPEED * time;
				
				var angle:Number = MathUtils.rad(rotation);
				
				var desiredAngle:Number = Math.atan2(distanceY, distanceX);
				var angleDifference:Number = MathUtils.piWrap(desiredAngle - angle);
				
				angle += angleDifference * turnSpeed * 0.05;
				
				x += Math.cos(angle) * moveSpeed * 0.5;
				y += Math.sin(angle) * moveSpeed * 0.5;
				rotation = MathUtils.deg(angle);
			}
		}
		
		private function wrapAround():void
		{
			var distance:Number = Math.sqrt((300 - x) * (300 - x) + (300 - y) * (300 - y));
			if (distance > 300)
			{
				super.die();
				GamePlay.removeMonster(this);
			}
		}
		
		override public function die():void
		{
			aggressive = false;
			_deathTimer = Math.random() * 0.5;
		}
		
		private function onComplete(event:Event):void
		{
			view.removeEventListener(Event.COMPLETE, onComplete);
			GamePlay.removeMonster(this);
		}
		
		public function reset():void
		{
			dead = false;
			aggressive = true;
			
			if (view)
			{
				view.gotoAndPlay("roam");
			}
			
			_hero = GamePlay.hero;
		}
		
		protected function get soundClass():Class
		{
			return null;
		}
	}
}