package plugins;

import gamemodes.BaseGamemode;
import gevents.ConfigEvent;
import gevents.GenEvent;
import plugins.BasePlugin;
import gevents.InitEvent;
import enet.ENet;

/**
 * ...
 * @author ...
 */
class Welcomer extends BasePlugin
{
	static private var msg:String;
	
	public function new() 
	{
		pluginName = "Welcomer";
		version = "0.0.1";
		
		super();
	}
	
	override public function hookEvents(Gm:BaseGamemode):Void 
	{
		super.hookEvents(Gm);
		
		Gm.addEventListener(InitEvent.INIT_EVENT, initPlayer, false, 10);
	}
	
	override public function shutdown(E:GenEvent = null):Void 
	{
		super.shutdown(E);
		
		Reg.gm.removeEventListener(InitEvent.INIT_EVENT, initPlayer, false);
	}
	
	override public function initPlayer(E:InitEvent):Void 
	{
		var t:String = "Server: " + msg;
		
		Msg.ChatToClient.data.set("id", E.player.ID);
		Msg.ChatToClient.data.set("message", t);
		Msg.ChatToClient.data.set("color", 0xffff0000);
		
		Reg.server.sendMsg(E.player.ID, Msg.ChatToClient.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
	}
	
	override public function onConfig(e:ConfigEvent):Void 
	{
		super.onConfig(e);
		
		msg = StringTools.trim(Assets.config.get("welcomer_msg"));
	}
}