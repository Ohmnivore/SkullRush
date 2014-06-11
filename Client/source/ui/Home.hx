package ui;
import flash.geom.Rectangle;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxUIText;
import flixel.FlxG;
import flixel.system.scaleModes.RatioScaleMode;

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
	public var open_update:FlxUIButton;
	
	override public function create() 
	{
		FlxG.scaleMode = new RatioScaleMode();
		
		Util.initXML(this);
		super.create();
		
		var chrome = new FlxUI9SliceSprite(5, 5, UIAssets.CHROME, new Rectangle(0, 0, 140, 470));
		chrome.scrollFactor.set();
		add(chrome);
		
		browse_p = new FlxUIButton(15, 10, "Browse public servers", browsePublic);
		browse_l = new FlxUIButton(15, 50, "Browse local servers", browseLAN);
		connect = new FlxUIButton(15, 90, "Connect to IP", directConnect);
		settings = new FlxUIButton(15, 130, "Settings", playerSettings);
		auto_launch = new FlxUIButton(15, 170, "Auto launch", autoLaunch);
		open_update = new FlxUIButton(15, 210, "Update", openUpdate);
		
		browse_p.loadGraphicSlice9(null, 120, 30, null);
		browse_p.autoCenterLabel();
		browse_l.loadGraphicSlice9(null, 120, 30, null);
		browse_l.autoCenterLabel();
		connect.loadGraphicSlice9(null, 120, 30, null);
		settings.loadGraphicSlice9(null, 120, 30, null);
		auto_launch.loadGraphicSlice9(null, 120, 30, null);
		open_update.loadGraphicSlice9(null, 120, 30, null);
		
		UIAssets.setBtnGraphic(browse_p);
		UIAssets.setBtnGraphic(browse_l);
		UIAssets.setBtnGraphic(connect);
		UIAssets.setBtnGraphic(settings);
		UIAssets.setBtnGraphic(auto_launch);
		UIAssets.setBtnGraphic(open_update);
		
		browse_p.resize(120, 30);
		browse_l.resize(120, 30);
		connect.resize(120, 30);
		settings.resize(120, 30);
		auto_launch.resize(120, 30);
		open_update.resize(120, 30);
		
		add(browse_p);
		add(browse_l);
		add(connect);
		add(settings);
		add(auto_launch);
		add(open_update);
	}
	
	public function browsePublic():Void
	{
		FlxG.switchState(new Public());
	}
	
	public function browseLAN():Void
	{
		//FlxG.switchState(new LAN());
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
	
	public function openUpdate():Void
	{
		FlxG.switchState(new Update());
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