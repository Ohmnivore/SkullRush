package ui;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUIState;
import flixel.FlxG;

/**
 * ...
 * @author Ohmnivore
 */
class Util
{
	
	static public function launchGame():Void
	{
		FlxG.switchState(new PreGame());
	}
	
	static public function initXML(S:FlxUIState):Void
	{
		Reflect.setField(S, "_xml_id", "home");
	}
	
	static public function addBackBtn(S:FlxUIState) :Void
	{
		var b:FlxUIButton = new FlxUIButton(0, 0, "Back", goBack);
		UIAssets.setBtnGraphic(b);
		b.x = FlxG.width - b.width - 5;
		b.y = FlxG.height - b.height - 5;
		
		S.add(b);
	}
	
	static public function goBack():Void
	{
		FlxG.switchState(new Home());
	}
}