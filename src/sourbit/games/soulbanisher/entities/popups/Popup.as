package sourbit.games.soulbanisher.entities.popups
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import sourbit.games.soulbanisher.entities.Entity;
	
	public class Popup extends Entity
	{
		[Embed(source="../../assets/popupStar.png")]
		static private const AssetScoreStar:Class;
		
		private var _star:Sprite;
		
		override protected function initialize():void 
		{
			var popupStarBitmap:Bitmap = new AssetScoreStar();
			popupStarBitmap.alpha = 0.75;
			popupStarBitmap.smoothing = true;
			popupStarBitmap.x = -popupStarBitmap.width * 0.5;
			popupStarBitmap.y = -popupStarBitmap.height * 0.5;
			
			_star = new Sprite();
			_star.addChild(popupStarBitmap);
			
			alpha = 0;
			scaleX = scaleY = 0.25;
			
			animationStep0();
			
			addChild(_star);
		}
		
		override protected function update():void 
		{
			_star.rotation += 2.5;
		}
		
		private function animationStep0():void
		{
			TweenMax.to(this, 0.5, {alpha: 0.75, scaleX: 1, scaleY: 1, onComplete: animationStep1, ease: Cubic.easeOut});
		}
		
		private function animationStep1():void
		{
			TweenMax.to(this, 0.25, {y: y - 35, alpha: 0, scaleX: 0.75, scaleY: 0.75, onComplete: animationStep2, ease: Cubic.easeIn});
		}
		
		private function animationStep2():void
		{
			parent.removeChild(this);
			die();
			dispose();
		}
	}
}