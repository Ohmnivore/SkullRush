package;

import crashdumper.CrashDumper;
import enet.Message;
import flixel.addons.display.FlxZoomCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.scaleModes.FillScaleMode;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import enet.ENet;
import enet.ENetEvent;
import flixel.util.FlxTimer;
import networkobj.NReg;
import sys.io.File;
import ui.Home;
import ui.Settings;
import crashdumper.SessionData;

/**
 * A FlxState which can be used for the game's menu.
 */
class InitState extends FlxState
{
	static private var init:Bool = false;
	public var server:Dynamic = null;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		//CrashDumper stuff:
		if (Assets.config.get("crashdump") == "true")
		{
			var unique_id:String = SessionData.generateID("skullrush_client_");
			var crashDumper = new CrashDumperMail(unique_id);
			crashDumper.setMail("ohmnivore@skullrush.elementfx.com",
				"mail.skullrush.elementfx.com",
				"mail.skullrush.elementfx.com");
			
			var configFile:String = File.getContent("config.txt");
			crashDumper.session.files.set("config.txt", configFile);
		}
		
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		#end
		
		super.create();
		FlxG.autoPause = false;
		
		//SkullClient.initClient();
		//Setup zoom camera
		if (FlxG.camera.zoom > 1)
		{
			var cam:FlxZoomCamera = new FlxZoomCamera(0, 0, Std.int(FlxG.width/2), Std.int(FlxG.height/2), 2);
			FlxG.cameras.reset(cam);
			FlxG.scaleMode = new RatioScaleMode();
			FlxG.cameras.bgColor = 0xff000000;
		}
		
		else
		{
			FlxG.scaleMode = new RatioScaleMode();
			FlxG.cameras.bgColor = 0xff000000;
		}
		
		FlxG.switchState(new Settings(true));
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
	}	
}