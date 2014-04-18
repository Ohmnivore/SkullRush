package;

import enet.Message;
import flixel.addons.display.FlxZoomCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.scaleModes.FillScaleMode;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import enet.ENet;
import enet.ENetEvent;
import networkobj.NReg;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	static private var init:Bool = false;
	public var server:Dynamic = null;
	
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
		
		if (!init)
		{
			//Setup zoom camera
			if (FlxG.camera.zoom > 1)
			{
				var cam:FlxZoomCamera = new FlxZoomCamera(0, 0, Std.int(FlxG.width/2), Std.int(FlxG.height/2), 2);
				FlxG.cameras.reset(cam);
				FlxG.scaleMode = new FillScaleMode();
				FlxG.cameras.bgColor = 0x00000000;
			}
			
			else
			{
				FlxG.scaleMode = new FillScaleMode();
				FlxG.cameras.bgColor = 0xff000000;
			}
			
			ENet.init();
			NReg.init();
			Msg.initMsg();
			Reg.client = new SkullClient(Assets.config.get("ip"), 6666);
			Reg.host = Reg.client;
			
			init = true;
		}
		
		FlxG.switchState(new PlayState());
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