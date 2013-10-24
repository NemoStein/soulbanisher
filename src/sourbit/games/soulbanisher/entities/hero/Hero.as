package sourbit.games.soulbanisher.entities.hero
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import sourbit.games.soulbanisher.audio.PowerUpProtectionAudio;
	import sourbit.games.soulbanisher.audio.WizardDeathAudio;
	import sourbit.games.soulbanisher.audio.WizardHurtAudio;
	import sourbit.games.soulbanisher.entities.Entity;
	import sourbit.games.soulbanisher.GamePlay;
	import sourbit.games.soulbanisher.SoundManager;
	import sourbit.games.soulbanisher.views.WizardView;
	import sourbit.library.utils.MathUtils;
	
	public class Hero extends Entity
	{
		static private const MOVE_SPEED:Number = 215;
		
		[Embed(source="../../assets/protectionBubble.png")]
		static private const AssetProtectionBubble:Class;
		
		private var _bubble:Bubble;
		private var _wizzard:Sprite;
		private var _blast:Sprite;
		private var _damage:Sprite;
		private var _protection:Bitmap;
		private var _protectionSound:SoundManager;
		
		private var _pressedLeft:Boolean;
		private var _pressedRight:Boolean;
		private var _pressedUp:Boolean;
		private var _pressedDown:Boolean;
		
		private var _normalBlinkDelay:Number;
		private var _alertBlinkDelay:Number;
		
		private var _invincibilitySpam:Number;
		private var _invincibilityAlert:Number;
		private var _invincibilityTime:Number;
		
		private var _blinkDelay:Number;
		private var _blinkTime:Number;
		
		private var _alert:Boolean;
		private var _view:MovieClip;
		
		private var _hurtSound:SoundManager;
		private var _deathSound:SoundManager;
		
		public var invincible:Boolean;
		public var lifes:int;
		
		override protected function initialize():void
		{
			lifes = 3;
			
			_hurtSound = new SoundManager(WizardHurtAudio);
			_deathSound = new SoundManager(WizardDeathAudio);
			_protectionSound = new SoundManager(PowerUpProtectionAudio, true);
			
			_bubble = new Bubble();
			_wizzard = new Sprite();
			_blast = new Sprite();
			_damage = new Sprite();
			_protection = new AssetProtectionBubble();
			
			_normalBlinkDelay = 0.25;
			_alertBlinkDelay = 0.1;
			
			_invincibilitySpam = 3;
			_invincibilityAlert = 1;
			_invincibilityTime = 0;
			
			_blinkDelay = _normalBlinkDelay;
			_blinkTime = _blinkDelay;
			
			_view = new WizardView();
			_view.rotation = -90;
			_view.scaleX = _view.scaleY = 0.2;
			
			_wizzard.addChild(_view);
			
			_protection.x = -_protection.width * 0.5;
			_protection.y = -_protection.height * 0.5;
			_protection.visible = false;
			
			_blast.graphics.lineStyle(50, 0x98d9fc);
			_blast.graphics.beginFill(0xffffff);
			_blast.graphics.drawCircle(0, 0, Bubble.MAX_RADIUS * 5);
			_blast.graphics.endFill();
			_blast.scaleX = _blast.scaleY = 0;
			_blast.visible = false;
			
			_damage.graphics.beginFill(0xa50505);
			_damage.graphics.drawCircle(0, 0, 35);
			_damage.graphics.endFill();
			_damage.scaleX = _damage.scaleY = 0.4;
			_damage.visible = false;
			
			addChild(_bubble);
			addChild(_wizzard);
			addChild(_damage);
			addChild(_protection);
			addChild(_blast);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onStageKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onStageKeyUp);
		}
		
		override protected function update():void
		{
			if (!dead)
			{
				var moveSpeed:Number = MOVE_SPEED * time;
				var distanceX:Number;
				var distanceY:Number;
				var targetX:Number;
				var targetY:Number;
				
				if (GamePlay.useKeyboard)
				{
					targetX = x;
					targetY = y;
					
					distanceX = _pressedLeft ? -moveSpeed : _pressedRight ? moveSpeed : 0;
					distanceY = _pressedUp ? -moveSpeed : _pressedDown ? moveSpeed : 0;
				}
				else
				{
					targetX = stage.mouseX;
					targetY = stage.mouseY;
					
					distanceX = targetX - x;
					distanceY = targetY - y;
				}
				
				var distance:Number = Math.sqrt(distanceX * distanceX + distanceY * distanceY);
				var moveAngle:Number = Math.atan2(distanceY, distanceX);
				
				var fromX:Number = x;
				var fromY:Number = y;
				
				if (distance < moveSpeed)
				{
					x = targetX;
					y = targetY;
				}
				else
				{
					x += Math.cos(moveAngle) * moveSpeed;
					y += Math.sin(moveAngle) * moveSpeed;
				}
				
				var bounds:Number = Math.sqrt((300 - x) * (300 - x) + (300 - y) * (300 - y));
				if (bounds > 275)
				{
					x = fromX;
					y = fromY;
				}
				
				if (distance > 5)
				{
					_wizzard.rotation = MathUtils.deg(moveAngle);
				}
				
				if (invincible)
				{
					_invincibilityTime += time;
					
					if (_invincibilityTime > _invincibilitySpam)
					{
						_blinkDelay = _normalBlinkDelay;
						_blinkTime = _blinkDelay;
						
						_invincibilityTime = 0;
						_alert = false;
						
						invincible = false;
						_protection.visible = false;
						
						_wizzard.alpha = 1;
						_protection.alpha = 1;
						_protectionSound.stop();
						
						return;
					}
					
					if (!_alert && _invincibilitySpam - _invincibilityTime < _invincibilityAlert)
					{
						_alert = true;
						_blinkTime = 0;
						_blinkDelay = _alertBlinkDelay;
					}
					
					_blinkTime += time;
					
					if (_blinkTime > _blinkDelay)
					{
						_wizzard.alpha = _wizzard.alpha < 1 ? 1 : _alert ? 0.35 : 0.65;
						_protection.alpha = _wizzard.alpha;
						_blinkTime -= _blinkDelay;
					}
				}
				
				if (_blast.visible)
				{
					if (_blast.scaleX > 1)
					{
						_blast.alpha -= 1.5 * time;
						
						if (_blast.alpha <= 0)
						{
							_blast.alpha = 1;
							_blast.scaleX = _blast.scaleY = 0;
							_blast.visible = false;
						}
					}
					else
					{
						_blast.scaleX = _blast.scaleY += 4 * time;
					}
				}
				
				if (_damage.visible)
				{
					if (_damage.scaleX < 1)
					{
						_damage.scaleX = _damage.scaleY += (10 - _damage.scaleY * 9) * time;
						
						if (_damage.scaleX > 1)
						{
							_damage.scaleX = _damage.scaleY = 1;
						}
					}
					
					_damage.alpha -= 2 * time;
					
					if (_damage.alpha <= 0)
					{
						_damage.alpha = 1;
						_damage.scaleX = _damage.scaleY = 0.4;
						_damage.visible = false;
					}
				}
			}
		}
		
		private function onStageMouseDown(event:MouseEvent):void
		{
			chargeMagic();
		}
		
		private function onStageMouseUp(event:MouseEvent):void
		{
			castMagic()
		}
		
		private function onStageKeyDown(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.A:
				case Keyboard.LEFT:
				{
					_pressedLeft = true;
					break;
				}
				
				case Keyboard.D:
				case Keyboard.RIGHT:
				{
					_pressedRight = true;
					break;
				}
				
				case Keyboard.W:
				case Keyboard.UP:
				{
					_pressedUp = true;
					break;
				}
				
				case Keyboard.S:
				case Keyboard.DOWN:
				{
					_pressedDown = true;
					break;
				}
				
				case Keyboard.SPACE:
				case Keyboard.ENTER:
				{
					chargeMagic();
					break;
				}
			}
		}
		
		private function onStageKeyUp(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.A:
				case Keyboard.LEFT:
				{
					_pressedLeft = false;
					break;
				}
				
				case Keyboard.D:
				case Keyboard.RIGHT:
				{
					_pressedRight = false;
					break;
				}
				
				case Keyboard.W:
				case Keyboard.UP:
				{
					_pressedUp = false;
					break;
				}
				
				case Keyboard.S:
				case Keyboard.DOWN:
				{
					_pressedDown = false;
					break;
				}
				
				case Keyboard.SPACE:
				case Keyboard.ENTER:
				{
					castMagic();
					break;
				}
			}
		}
		
		private function chargeMagic():void
		{
			if (!GamePlay.paused)
			{
				_view.gotoAndPlay("cast");
				_bubble.grow();
			}
		}
		
		private function castMagic():void
		{
			if (!GamePlay.paused)
			{
				_view.gotoAndPlay("roam");
				_bubble.explode();
			}
		}
		
		public function hit():void
		{
			_hurtSound.play();
			--lifes;
			
			_bubble.explode();
			GamePlay.setLifes(lifes);
			
			_damage.visible = true;
			
			if (lifes > 0)
			{
				_invincibilitySpam = 3;
				invincible = true;
			}
			else
			{
				die();
			}
		}
		
		override public function die():void
		{
			_deathSound.play();
			_view.gotoAndPlay("death");
			_view.addEventListener(Event.COMPLETE, onViewComplete);
			
			removeListeners();
			
			super.die();
		}
		
		private function onViewComplete(event:Event):void
		{
			GamePlay.showScoreScreen();
		}
		
		override public function dispose():void
		{
			removeListeners();
			
			super.dispose();
		}
		
		public function nuke():void
		{
			_blast.visible = true;
		}
		
		public function protect():void
		{
			_protectionSound.play();
			
			invincible = true;
			_protection.visible = true;
			_invincibilitySpam = 5;
			
			_blinkDelay = _normalBlinkDelay;
			_invincibilityTime = 0;
			_blinkTime = 0;
			_alert = false;
		}
		
		private function removeListeners():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onStageKeyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onStageKeyUp);
		}
	}
}