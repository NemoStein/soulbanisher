package sourbit.games.soulbanisher.states
{
	import sourbit.games.soulbanisher.GameButton;
	import sourbit.games.soulbanisher.GamePlay;
	import sourbit.games.soulbanisher.GameText;
	
	public class Credits extends State
	{
		override protected function initialize():void
		{
			super.initialize();
			
			var gameName:GameText = generateText("SoulBanisher");
			
			var aGameBy:GameText = generateText("A Game By");
			var sourBit:GameText = generateText("SourBit");
			sourBit.link("http://www.sourbit.com.br");
			
			var designCoding:GameText = generateText("Design & Coding:");
			var nemoStein:GameText = generateText("NemoStein");
			nemoStein.link("http://www.nemostein.com.br");
			
			var artist:GameText = generateText("Artist:");
			var maru:GameText = generateText("Maru");
			maru.link("http://maruartwork.carbonmade.com/");
			
			var composer:GameText = generateText("Composer:");
			var mattSchiffer:GameText = generateText("Matt Schiffer");
			mattSchiffer.link("http://on.fb.me/XPW8hZ");
			
			aGameBy.scaleX = aGameBy.scaleY = 1.25;
			sourBit.scaleX = sourBit.scaleY = 2.5;
			
			aGameBy.x = (600 - aGameBy.width) * 0.5;
			sourBit.x = (600 - sourBit.width) * 0.5;
			
			aGameBy.y = 100;
			sourBit.y = 120;
			
			designCoding.x = 70;
			artist.x = 390;
			composer.x = 70;
			
			nemoStein.x = designCoding.x + designCoding.width + 7;
			maru.x = artist.x + artist.width + 7;
			mattSchiffer.x = composer.x + composer.width + 7;
			
			designCoding.y = 250;
			nemoStein.y = 250;
			
			artist.y = 300;
			maru.y = 300;
			
			composer.y = 350;
			mattSchiffer.y = 350;
			
			var backToMain:GameButton = new GameButton("Main Menu", GamePlay.enterMainMenu);
			
			backToMain.x = (600 - backToMain.width) * 0.5;
			backToMain.y = 470;
			
			addChild(gameName);
			addChild(aGameBy);
			addChild(sourBit);
			addChild(designCoding);
			addChild(nemoStein);
			addChild(artist);
			addChild(maru);
			addChild(composer);
			addChild(mattSchiffer);
			
			addChild(backToMain);
		}
		
		private function generateText(text:String):GameText
		{
			var gameText:GameText = new GameText();
			
			gameText.text = text;
			gameText.width = gameText.textWidth;
			gameText.height = gameText.textHeight;
			
			return gameText;
		}
	}
}