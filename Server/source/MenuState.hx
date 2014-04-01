package;

import enet.Message;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import enet.ENet;
import enet.ENetEvent;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
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
		
		ENet.init();
		
		var m:Message = new Message(0, ["posx", "posy"]);
		m.data.set("posx", 5);
		
		trace(m.serialize());
		
		//trace(separateMessage("1.hello"));
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
		
		if (server != null)
		{
			var e:ENetEvent = ENet.poll(server, 0);
			
			if (e.type != ENetEvent.E_NONE)
			{
				trace(e.type, e.address, e.port);
				
				if (e.type == ENetEvent.E_CONNECT)
				{
					ENet.sendMsg(server, e.address, e.port, "Hullo there", 0, ENet.ENET_PACKET_FLAG_RELIABLE);
				}
			}
		}
		
		else
		{
			if (FlxG.keys.justPressed.S)
				server = ENet.server(null, 1234, 1, 1);
			if (FlxG.keys.justPressed.C)
				server = ENet.client("", 1234, 1, 1);
		}
	}	
}