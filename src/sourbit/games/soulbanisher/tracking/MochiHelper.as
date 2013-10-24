package sourbit.games.soulbanisher.tracking
{
	import flash.display.DisplayObject;
	import mochi.as3.MochiEvents;
	import mochi.as3.MochiScores;
	import mochi.as3.MochiServices;
	
	dynamic public class MochiHelper
	{
		static private const MOCHI_ID:String = "3fe2483a789d8263";
		
		static public function connect(root:DisplayObject):void
		{
			CONFIG::release
			{
				MochiServices.connect(MOCHI_ID, root, function(status:String):void
				{
					trace(status);
				});
			}
		}
		
		static public function startPlay():void
		{
			CONFIG::release
			{
				MochiScores.closeLeaderboard();
				MochiEvents.startPlay("Game");
			}
		}
		
		static public function endPlay():void
		{
			CONFIG::release
			{
				MochiEvents.endPlay();
			}
		}
		
		static public function submitScore(playerScore:int):void
		{
			CONFIG::release
			{
				MochiScores.showLeaderboard(new MochiHelper(playerScore));
			}
		}
		
		//{ Leaderboard
		public var boardID:String;
		public var score:int;
		
		private const _parameters:Array = [2, 13, 9, 1, 15, 14, 3, 7, 4, 8, 15, 4, 0, 4, 9, 15];
		
		public function MochiHelper(playerScore:int)
		{
			score = playerScore;
			boardID = generateBoardId(0, "");
		}
		
		private function generateBoardId(index:Number, string:String):String
		{
			if (string.length == 16)
			{
				return string;
			}
			
			return generateBoardId(index + 1, string + _parameters[index].toString(16));
		}
		//}
	}
}