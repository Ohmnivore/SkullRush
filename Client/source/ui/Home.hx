package ui;
import flash.geom.Rectangle;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxUIText;
import flixel.FlxG;

/**
 * ...
 * @author Ohmnivore
 */
class Home extends FlxUIState
{
	public var browse_p:FlxUIButton;
	public var browse_l:FlxUIButton;
	public var connect:FlxUIButton;
	public var settings:FlxUIButton;
	public var auto_launch:FlxUIButton;
	
	override public function create() 
	{
		//SkullClient.initClient();
		
		Util.initXML(this);
		super.create();
		
		var chrome = new FlxUI9SliceSprite(5, 5, null, new Rectangle(0, 0, 140, 470));
		chrome.scrollFactor.set();
		add(chrome);
		
		browse_p = new FlxUIButton(15, 10, "Browse public servers", browsePublic);
		browse_l = new FlxUIButton(15, 50, "Browse local servers", browseLAN);
		connect = new FlxUIButton(15, 90, "Connect to IP", directConnect);
		settings = new FlxUIButton(15, 130, "Player settings", playerSettings);
		auto_launch = new FlxUIButton(15, 170, "Auto launch", autoLaunch);
		
		browse_p.loadGraphicSlice9(null, 120, 30, null);
		browse_p.autoCenterLabel();
		browse_l.loadGraphicSlice9(null, 120, 30, null);
		browse_l.autoCenterLabel();
		connect.loadGraphicSlice9(null, 120, 30, null);
		settings.loadGraphicSlice9(null, 120, 30, null);
		auto_launch.loadGraphicSlice9(null, 120, 30, null);
		
		add(browse_p);
		add(browse_l);
		add(connect);
		add(settings);
		add(auto_launch);
	}
	
	public function browsePublic():Void
	{
		FlxG.switchState(new Public());
	}
	
	public function browseLAN():Void
	{
		FlxG.switchState(new LAN());
	}
	
	public function playerSettings():Void
	{
		FlxG.switchState(new Settings());
	}
	
	public function directConnect():Void
	{
		FlxG.switchState(new DirectConnect());
	}
	
	public function autoLaunch():Void
	{
		FlxG.switchState(new PlayState());
	}
	
	public override function getEvent(id:String, target:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void {
		//if (params != null) {
			//switch(id) {
				//case "click_button":
					//switch(cast(params[0], String)) {
						//case "public": FlxG.switchState(new PlayState());
				//}
			//}
		//}
	}
	
}