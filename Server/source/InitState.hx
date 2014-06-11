package;

import crashdumper.CrashDumper;
import crashdumper.SessionData;
import enet.Message;
import flixel.addons.display.FlxZoomCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.scaleModes.FillScaleMode;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.system.scaleModes.StageSizeScaleMode;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import enet.ENet;
import enet.ENetEvent;
import haxe.Log;
import networkobj.NReg;
import sys.io.File;
import haxe.PosInfos;

/**
 * A FlxState which can be used for the game's menu.
 */
class InitState extends FlxState
{
	public var server:Dynamic = null;
	
	public static dynamic function old_trace (A:Dynamic, ?B:PosInfos):Void {};
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		#end
		
		super.create();
		FlxG.autoPause = false;
		
		//CrashDumper stuff:
		if (Assets.config.get("crashdump") == "true")
		{
			var unique_id:String = SessionData.generateID("skullrush_server_");
			var crashDumper = new CrashDumper(unique_id);
			
			var configFile:String = File.getContent("config.txt");
			crashDumper.session.files.set("config.txt", configFile);
		}
		
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
		
		//Make trace also write to flixel's debugger's log
		old_trace = Log.trace;
		//Log.trace = new_trace;
		
		//Setup networking
		Reg.maps = Reg.parseMaps();
		Reg.mapname = Reg.maps[Reg.map_index];
		ENet.init();
		Msg.initMsg();
		NReg.init();
		Reg.server = new SkullServer(null, 6666, 3, 32);
		Reg.host = Reg.server;
		
		//FlxG.fixedTimestep = false;
		//FlxG.maxElapsed = 0.25;
		FlxG.switchState(new PlayState());
	}
	
	private static function new_trace(v:Dynamic, ?inf:haxe.PosInfos)
	{
        old_trace(v, inf);
		FlxG.log.add(v);
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