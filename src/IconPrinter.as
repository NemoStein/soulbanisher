package  
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import sourbit.games.soulbanisher.entities.hero.Bubble;
	import sourbit.games.soulbanisher.views.GhostView;
	import sourbit.games.soulbanisher.views.WizardView;
	
	public class IconPrinter extends Sprite 
	{
		[Embed(source = "sourbit/games/soulbanisher/assets/background.png")]
		static private const BackgroundView:Class;
		
		[Embed(source = "sourbit/games/soulbanisher/assets/hud.png")]
		static private const HudView:Class;
		
		public function IconPrinter() 
		{
			var backgroundView:Bitmap = new BackgroundView();
			var hudView:Bitmap = new HudView();
			
			var wizardView:WizardView = new WizardView();
			wizardView.scaleX = wizardView.scaleY = 0.35;
			wizardView.stop();
			
			wizardView.x = 200;
			wizardView.y = 400;
			wizardView.rotation = -70;
			
			var bubble:Bubble = new Bubble(true);
			bubble.x = 200;
			bubble.y = 400;
			
			var ghostView:GhostView = new GhostView();
			ghostView.scaleX = ghostView.scaleY = 0.35;
			ghostView.stop();
			
			ghostView.x = 340;
			ghostView.y = 400;
			ghostView.rotation = -110;
			
			addChild(backgroundView);
			addChild(hudView);
			addChild(bubble);
			addChild(wizardView);
			addChild(ghostView);
			
			wizardView.gotoAndPlay("cast");
			bubble.scaleX = bubble.scaleY = 1;
			
			//var sprite:Sprite = new Sprite();
			//sprite.graphics.beginFill(0);
			//sprite.graphics.drawRect(-125, -125, 250, 250);
			//sprite.graphics.endFill();
			//
			//sprite.x = 150;
			//sprite.y = 150;
			//
			//sprite.addChild(ghostView);
			//addChild(sprite);
		}
	}
}