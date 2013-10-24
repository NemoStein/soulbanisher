package sourbit.games.soulbanisher
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class GameText extends Sprite
	{
		[Embed(source="assets/bankgothic.ttf",fontName="BankGothic",unicodeRange="U+0020, U+0025-U+0026, U+002d, U+0030-U+003a, U+0041-U+005a, U+0061-U+007a",embedAsCFF="false")]
		static private const AssetBankGothic:Class;
		
		private var _textFieldA:TextField;
		private var _textFieldB:TextField;
		
		private var _urlRequest:URLRequest;
		
		public function GameText()
		{
			_textFieldA = createField();
			_textFieldB = createField(true);
			
			_textFieldA.x = -2;
			_textFieldA.y = -2;
			
			_textFieldB.x = -2;
			
			addChild(_textFieldB);
			addChild(_textFieldA);
		}
		
		private function createField(shadow:Boolean = false):TextField
		{
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = "BankGothic";
			textFormat.size = 20;
			textFormat.color = shadow ? 0x0d212c : 0xcdac10;
			textFormat.align = TextFormatAlign.RIGHT;
			textFormat.leading = -2;
			
			var textField:TextField = new TextField();
			textField.embedFonts = true;
			textField.selectable = false;
			textField.mouseEnabled = false;
			textField.defaultTextFormat = textFormat;
			textField.autoSize = TextFieldAutoSize.NONE;
			
			return textField;
		}
		
		public function link(url:String):void
		{
			buttonMode = true;
			color = 0xc02018;
			
			_urlRequest = new URLRequest(url);
			
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		private function onClick(event:MouseEvent):void
		{
			navigateToURL(_urlRequest, "_blank");
		}
		
		private function onMouseOver(event:MouseEvent):void
		{
			color = 0xffffff;
		}
		
		private function onMouseOut(event:MouseEvent):void
		{
			color = 0xc02018;
		}
		
		public function get textWidth():Number
		{
			return _textFieldA.textWidth + 2;
		}
		
		public function get textHeight():Number
		{
			return _textFieldA.textHeight + 2;
		}
		
		public function get text():String
		{
			return _textFieldA.text;
		}
		
		public function set text(value:String):void
		{
			_textFieldA.text = value;
			_textFieldB.text = value;
		}
		
		private function get color():uint
		{
			return uint(_textFieldA.getTextFormat().color);
		}
		
		private function set color(value:uint):void
		{
			var textFormat:TextFormat = _textFieldA.defaultTextFormat;
			textFormat.color = value;
			
			_textFieldA.setTextFormat(textFormat);
		}
		
		override public function get width():Number
		{
			return _textFieldA.width * scaleX;
		}
		
		override public function set width(value:Number):void
		{
			_textFieldA.width = value;
			_textFieldB.width = value;
		}
		
		override public function get height():Number
		{
			return _textFieldA.height * scaleY;
		}
		
		override public function set height(value:Number):void
		{
			_textFieldA.height = value;
			_textFieldB.height = value;
		}
	}
}