package sourbit.games.soulbanisher.entities.popups
{
	import sourbit.games.soulbanisher.GameText;
	
	public class ScorePopup extends Popup
	{
		private var _points:int;
		private var _cute:int;
		private var _ugly:Number;
		
		public function ScorePopup(points:int, cute:int, ugly:Number)
		{
			_points = points;
			_cute = cute;
			_ugly = ugly;
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			var formula:GameText = new GameText();
			formula.text = _cute + " - " + Math.round((1 - _ugly) * 100) + "%";
			formula.width = formula.textWidth;
			formula.height = formula.textHeight;
			formula.scaleX = formula.scaleY = 0.8;
			formula.x = -formula.width * 0.5;
			formula.y = -formula.height - 1;
			
			var score:GameText = new GameText();
			score.text = String(_points);
			score.width = score.textWidth;
			score.height = score.textHeight;
			score.scaleX = score.scaleY = 1.4;
			score.x = -score.width * 0.5;
			score.y = 1;
			
			addChild(formula);
			addChild(score);
		}
	}
}