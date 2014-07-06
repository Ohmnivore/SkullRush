package ;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import mloader.Loader.LoaderErrorType;
import flixel.text.FlxText;
import enet.ENet;
import ui.Home;

/**
 * ...
 * @author Ohmnivore
 */

class PreGame extends FlxState
{
	var log:FlxSpriteGroup;
	
	public function new() 
	{
		super();
	}
	
	public function myTrace(Message:String):Void
	{
		var t:FlxText = new FlxText(0, log.height, 0, Message);
		log.add(t);
	}
	
	override public function create():Void 
	{
		super.create();
		
		Reg.pre_state = this;
		Reg.playermap = new Map<Int, Player>();
		
		Assets.initAssets();
		
		SkullClient.initClient();
		
		log = new FlxSpriteGroup(5, 5);
		add(log);
		
		myTrace("Press ESC to return to the main menu");
		myTrace("Initiating connection attempt...");
	}
	
	public function onLoaded():Void
	{
		myTrace("All external assets loaded.");
		
		Msg.PlayerInfo.data.set("name", Assets.config.get("name"));
		Msg.PlayerInfo.data.set("team", Assets.config.get("team"));
		
		Reg.client.send(Msg.PlayerInfo.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
		
		myTrace("Sending player info to server.");
		
		Reg.pre_state = null;
	}
	
	public function downloadError(e:LoaderErrorType):Void
	{
		myTrace("There was an error downloading external assets.");
		
		switch (e)
		{
			case LoaderErrorType.Data:
				
			
			case LoaderErrorType.Format:
				
			
			case LoaderErrorType.IO:
				
			
			case LoaderErrorType.Security:
				
		}
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.switchState(new Home());
		}
		
		Reg.client.poll();
	}
	
}