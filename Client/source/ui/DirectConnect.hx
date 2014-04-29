package ui;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxUIText;
import flixel.FlxG;
import flixel.FlxGame;

/**
 * ...
 * @author Ohmnivore
 */
class DirectConnect extends FlxUIState
{
	public var inp:FlxUIInputText;
	
	override public function create() 
	{
		Util.initXML(this);
		super.create();
		Util.addBackBtn(this);
		
		var t:FlxUIText = new FlxUIText();
		t.x = 10;
		t.y = 10;
		t.text = "Server's IP: ";
		add(t);
		
		inp = new FlxUIInputText();
		inp.x = 75;
		inp.y = 10;
		add(inp);
		
		var go:FlxUIButton = new FlxUIButton(240, 10, "Connect", connect);
		add(go);
	}
	
	public function connect():Void
	{
		Assets.config.set("ip", inp.text);
		Assets.saveConfig();
		Util.launchGame();
	}
	
}