package sourbit.games.soulbanisher.entities.powerups
{
	import com.greensock.easing.Circ;
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import sourbit.games.soulbanisher.entities.Entity;
	import sourbit.games.soulbanisher.GamePlay;
	import sourbit.games.soulbanisher.SoundManager;
	
	public class PowerUp extends Entity
	{
		private var _normalBlinkDelay:Number;
		private var _alertBlinkDelay:Number;
		
		private var _lifeSpam:Number;
		private var _lifeAlert:Number;
		private var _lifeTime:Number;
		
		private var _blinkDelay:Number;
		private var _blinkTime:Number;
		
		private var _alert:Boolean;
		
		private var _sound:SoundManager;
		
		override protected function initialize():void
		{
			if (soundClass)
			{
				_sound = new SoundManager(soundClass);
			}
			
			var bitmap:Bitmap = new assetClass();
			
			bitmap.smoothing = true;
			bitmap.x = -bitmap.width * 0.5;
			bitmap.y = -bitmap.height * 0.5;
			
			addChild(bitmap);
			
			var angle:Number = Math.random() * (Math.PI * 2) - Math.PI;
			var radius:Number = Math.random() * 250;
			
			x = Math.cos(angle) * radius + 300;
			y = Math.sin(angle) * radius + 300;
			
			_normalBlinkDelay = 0.25;
			_alertBlinkDelay = 0.1;
			
			_lifeSpam = 3;
			_lifeAlert = 2;
			_lifeTime = 0;
			
			_blinkDelay = _normalBlinkDelay;
			_blinkTime = 0;
			
			alpha = 0;
			scaleX = scaleY = 5;
			TweenMax.to(this, 0.35, {alpha: 1, scaleX: 1, scaleY: 1, ease: Circ.easeIn});
		}
		
		protected function get soundClass():Class
		{
			return null;
		}
		
		override protected function update():void
		{
			_lifeTime += time;
			
			if (_lifeTime > _lifeSpam)
			{
				die();
				return;
			}
			
			if (!_alert && _lifeTime > _lifeAlert)
			{
				_alert = true;
				_blinkTime = 0;
				_blinkDelay = _alertBlinkDelay;
			}
			
			_blinkTime += time;
			
			if (_blinkTime > _blinkDelay)
			{
				alpha = alpha < 1 ? 1 : _alert ? 0.35 : 0.65;
				_blinkTime -= _blinkDelay;
			}
		}
		
		public function execute():void
		{
			if (_sound)
			{
				_sound.play();
			}
			die();
		}
		
		override public function die():void
		{
			GamePlay.removePowerUp(this);
			
			super.die();
			dispose();
		}
		
		override public function dispose():void
		{
			
			super.dispose();
		}
		
		public function get assetClass():Class
		{
			return null;
		}
	}
}