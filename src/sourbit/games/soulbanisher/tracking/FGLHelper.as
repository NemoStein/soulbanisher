package sourbit.games.soulbanisher.tracking
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class FGLHelper
	{
		static private const FGL_ID:String = "FGL-57";
		
		static private var _fglAds:FGLAds;
		static private var _ready:Boolean;
		static private var _failed:Boolean;
		static private var _container:Sprite;
		
		static public function connect():Sprite
		{
			_container = new Sprite();
			
			//CONFIG::release
			{
				_fglAds = new FGLAds(_container, FGL_ID);
				
				_fglAds.addEventListener(FGLAds.EVT_API_READY, onFglAdsEvtApiReady);
				_fglAds.addEventListener(FGLAds.EVT_AD_LOADING_ERROR, onFglAdsEvtAdLoadingError);
			}
			
			return _container;
		}
		
		static public function showAdd(format:String = "300x250", delay:Number = 3000, timeout:Number = 0):void
		{
			//CONFIG::release
			{
				_fglAds.showAdPopup(format, delay, timeout);
			}
		}
		
		static private function onFglAdsEvtApiReady(e:Event):void
		{
			_ready = true;
		}
		
		static private function onFglAdsEvtAdLoadingError(e:Event):void
		{
			_failed = true;
		}
		
		static public function get ready():Boolean
		{
			return _ready;
		}
		
		static public function get failed():Boolean
		{
			return _failed || _fglAds.status == "Failed";
		}
		
		static public function get container():Sprite
		{
			return _container;
		}
	}
}