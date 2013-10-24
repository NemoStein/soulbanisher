package sourbit.games.soulbanisher.entities.hero
{
	import com.greensock.easing.Circ;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.utils.getTimer;
	import sourbit.games.soulbanisher.entities.Entity;
	import sourbit.games.soulbanisher.GamePlay;
	
	public class Bubble extends Entity
	{
		[Embed(source="../../assets/outerCircle.png")]
		private static const AssetOuterCircle:Class;
		
		[Embed(source="../../assets/innerCircle.png")]
		private static const AssetInnerCircle:Class;
		
		[Embed(source="../../assets/dodecagram.png")]
		private static const AssetDodecagram:Class;
		
		[Embed(source="../../assets/moon.png")]
		private static const AssetMoon:Class;
		
		static public const MAX_RADIUS:int = 200;
		
		private var _scale:Number;
		
		private var _magicCircle:Sprite;
		private var _outerCircle:Sprite;
		private var _innerCircle:Sprite;
		private var _dodecagram:Sprite;
		private var _moon:Sprite;
		
		private var _bubbleStartTime:int;
		private var _fake:Boolean;
		
		public function Bubble(fake:Boolean = false)
		{
			_fake = fake;
		}
		
		override protected function initialize():void
		{
			_magicCircle = new Sprite();
			
			var outerCircleBitmap:Bitmap = new AssetOuterCircle();
			var innerCircleBitmap:Bitmap = new AssetInnerCircle();
			var dodecagramBitmap:Bitmap = new AssetDodecagram();
			var moonBitmap:Bitmap = new AssetMoon();
			
			outerCircleBitmap.smoothing = true;
			innerCircleBitmap.smoothing = true;
			dodecagramBitmap.smoothing = true;
			moonBitmap.smoothing = true;
			
			outerCircleBitmap.x = -outerCircleBitmap.width * 0.5;
			outerCircleBitmap.y = -outerCircleBitmap.height * 0.5;
			
			innerCircleBitmap.x = -innerCircleBitmap.width * 0.5;
			innerCircleBitmap.y = -innerCircleBitmap.height * 0.5;
			
			dodecagramBitmap.x = -dodecagramBitmap.width * 0.5;
			dodecagramBitmap.y = -dodecagramBitmap.height * 0.5;
			
			moonBitmap.x = -moonBitmap.width * 0.5;
			moonBitmap.y = outerCircleBitmap.y
			
			_outerCircle = new Sprite();
			_innerCircle = new Sprite();
			_dodecagram = new Sprite();
			_moon = new Sprite();
			
			_outerCircle.addChild(outerCircleBitmap);
			_innerCircle.addChild(innerCircleBitmap);
			_dodecagram.addChild(dodecagramBitmap);
			_moon.addChild(moonBitmap);
			
			_scale = 0;
			scaleX = scaleY = _scale;
			
			_magicCircle.addChild(_outerCircle);
			_magicCircle.addChild(_innerCircle);
			_magicCircle.addChild(_dodecagram);
			_magicCircle.addChild(_moon);
			
			_magicCircle.width = MAX_RADIUS * 2;
			_magicCircle.height = MAX_RADIUS * 2;
			
			addChild(_magicCircle);
		}
		
		public function grow():void
		{
			if (!GamePlay.bubbleGrowing)
			{
				_scale = 0;
				
				GamePlay.bubbleGrowing = true;
				_bubbleStartTime = getTimer();
			}
		}
		
		public function explode():void
		{
			if (GamePlay.bubbleGrowing)
			{
				GamePlay.bubbleGrowing = false;
				
				TweenMax.to(this, 0.12, {alpha: 1, ease: Cubic.easeIn});
				TweenMax.to(this, 0.4, {scaleX: _scale + 0.15, scaleY: _scale + 0.15, ease: Cubic.easeOut});
				TweenMax.to(this, 0.28, {delay: 0.2, alpha: 0, ease: Cubic.easeOut});
				
				TweenMax.to(_moon, 0.4, {rotation: _moon.rotation - 90, ease: Circ.easeIn});
				TweenMax.to(_dodecagram, 0.4, {rotation: _dodecagram.rotation - 90, ease: Circ.easeIn});
				TweenMax.to(_innerCircle, 0.4, {rotation: _innerCircle.rotation + 90, ease: Circ.easeIn});
				TweenMax.to(_outerCircle, 0.4, {rotation: _outerCircle.rotation + 90, ease: Circ.easeIn});
				
				if (!_fake)
				{
					GamePlay.hitMonsters(_scale);
				}
			}
		}
		
		override protected function update():void
		{
			if (GamePlay.bubbleGrowing)
			{
				_scale += time * 0.3;
				alpha = 0.8 - _scale * 0.4;
				
				if (_scale > 1)
				{
					_scale = 1;
				}
				
				_moon.rotation -= time * 15;
				_dodecagram.rotation -= time * 45;
				_innerCircle.rotation += time * 30;
				_outerCircle.rotation += time * 60;
				
				scaleX = scaleY = _scale;
			}
		}
	}
}