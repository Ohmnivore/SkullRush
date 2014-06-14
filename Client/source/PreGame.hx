package ;
import flixel.FlxState;
import mloader.Loader.LoaderErrorType;
import enet.ENet;

/**
 * ...
 * @author Ohmnivore
 */

class PreGame extends FlxState
{

	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		super.create();
		
		Reg.pre_state = this;
		Reg.playermap = new Map<Int, Player>();
		
		Assets.initAssets();
		
		SkullClient.initClient();
	}
	
	public function onLoaded():Void
	{
		trace("Loaded external assets.");
		//if (buffer_string == null)
		//{
			Msg.PlayerInfo.data.set("name", Assets.config.get("name"));
			Msg.PlayerInfo.data.set("team", Assets.config.get("team"));
			
			Reg.client.send(Msg.PlayerInfo.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
		//}
	}
	
	public function downloadError(e:LoaderErrorType):Void
	{
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
		
		Reg.client.poll();
	}
	
}