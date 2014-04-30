package ui;
import flash.geom.Rectangle;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUIPopup;
import flixel.addons.ui.FlxUIText;
import flixel.FlxG;

/**
 * ...
 * @author Ohmnivore
 */
class NoServerAlert extends FlxUIPopup
{
	static public inline var TEXT:String = "There are no public servers at the moment.";
	
	override public function create():Void 
	{
		_xml_id = "empty_popup";
		super.create();
		
		var x:Float = 150;
		var y:Float = 150;
		var width:Float = FlxG.width - 2 * x;
		var height:Float = FlxG.height - 2 * y;
		var chrome = new FlxUI9SliceSprite(x, y, null, new Rectangle(0, 0, width, height));
		chrome.scrollFactor.set();
		add(chrome);
		
		var t:FlxUIText = new FlxUIText();
		t.width = width - 10;
		t.text = TEXT;
		t.color = 0xff000000;
		t.x = x + 5;
		t.y = y + 5;
		add(t);
		
		var b:FlxUIButton = new FlxUIButton(0, 0, "Back", exitPopup);
		b.x = x + width - 5 - b.width;
		b.y = y + height - 5 - b.height;
		add(b);
	}
	
	public function exitPopup():Void
	{
		//_parentState.closeSubState();
		//FlxG.switchState(new Home());
		close();
	}
}