package ui;
import flixel.addons.ui.FlxUICheckBox;
import flixel.FlxG;
import haxe.macro.MacroStringTools;

/**
 * ...
 * @author Ohmnivore
 */
class SharedSettings
{

	static public function setFullScreen(Fullscreen:Bool):Void
	{
		if (Fullscreen)
		{
			FlxG.fullscreen = true;
		}
		
		else
		{
			FlxG.fullscreen = false;
		}
	}
	
	static public function showPing(Show:Bool):Void
	{
		if (Show)
		{
			Reg.state.ping_text.visible = true;
		}
		
		else
		{
			Reg.state.ping_text.visible = false;
		}
	}
	
	static public function returnGraphicOptions():Map<String, Dynamic>
	{
		var full:FlxUICheckBox = new FlxUICheckBox(0, 0, null, null, "Fullscreen");
		full.id = "full";
		var ping:FlxUICheckBox = new FlxUICheckBox(0, 0, null, null, "Show ping");
		ping.id = "full";
		
		var map:Map<String, Dynamic> = new Map<String, Dynamic>();
		map.set("full", full);
		map.set("ping", ping);
		
		return map;
	}
}