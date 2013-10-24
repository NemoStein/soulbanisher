package sourbit.games.soulbanisher 
{
	import flash.net.SharedObject;

	public class ScoreData 
	{
		static private var _local:SharedObject = SharedObject.getLocal("sourbit.games.soulbanisher");
		
		static public function getCurrentHighScore():int
		{
			return int(_local.data.score);
		}
		
		static public function setCurrentHighScore(value:int):void
		{
			_local.data.score = value;
		}
	}
}