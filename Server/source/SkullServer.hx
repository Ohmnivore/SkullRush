package ;
import enet.ENet;
import enet.ENetEvent;
import enet.Server;
import sys.io.File;

/**
 * ...
 * @author Ohmnivore
 */
class SkullServer extends Server
{
	public var config:Map<String, String>;
	public var manifestURL:String;
	public var ipmap:Map<Int, String>;
	public var portmap:Map<Int, Int>;
	public var peermap:Map<Int, Player>;
	public var playermap:Map<String, Player>;
	
	public var id:Int = 1;
	
	public function new(IP:String = null, Port:Int = 0, Channels:Int = 3, Players:Int = 32) 
	{
		ipmap = new Map<Int, String>();
		portmap = new Map<Int, Int>();
		peermap = new Map<Int, Player>();
		playermap = new Map<String, Player>();
		
		config = readConfig();
		manifestURL = config.get("manifesturl");
		
		super(IP, Port, Channels, Players);
		
		Msg.addToHost(this);
		
		Msg.Manifest.data.set("url", manifestURL);
	}
	
	override public function onPeerConnect(e:ENetEvent):Void
	{
		super.onPeerConnect(e);
		
		trace("Peer connected!");
		
		sendMsg(e.address, e.port, Msg.Manifest.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
	}
	
	override public function onPeerDisonnect(e:ENetEvent):Void 
	{
		super.onPeerDisonnect(e);
		
		trace("Peer disconnected!");
		
		var p:Player = playermap.get(ENet.peerKey(e.address, e.port));
		
		//Send disconnect to everyone
		Msg.PlayerDisco.data.set("id", p.ID);
		for (pl in peermap.iterator())
		{
			if (p != pl)
			{
				sendMsg(ipmap.get(pl.ID), portmap.get(pl.ID), Msg.PlayerDisco.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
			}
		}
		
		ipmap.remove(p.ID);
		portmap.remove(p.ID);
		peermap.remove(p.ID);
		playermap.remove(ENet.peerKey(e.address, e.port));
		
		p.kill();
	}
	
	override public function onReceive(MsgID:Int, E:ENetEvent):Void 
	{
		super.onReceive(MsgID, E);
		
		if (MsgID == Msg.PlayerInfo.ID)
		{
			trace("PlayerInfo");
			var name:String = Msg.PlayerInfo.data.get("name");
			if (name.length > 15) name = name.substr(0, 15);
			
			for (pl in peermap.iterator())
			{
				if (pl.name == name)
				{
					name += "*";
				}
			}
			
			var p:Player = new Player(id, name, 50, 50);
			
			peermap.set(id, p);
			ipmap.set(id, E.address);
			portmap.set(id, E.port);
			playermap.set(ENet.peerKey(E.address, E.port), p);
			
			Msg.PlayerInfoBack.data.set("id", p.ID);
			Msg.PlayerInfoBack.data.set("name", p.name);
			Msg.PlayerInfoBack.data.set("color", 0xff000000);
			
			sendMsg(E.address, E.port, Msg.MapMsg.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
			sendMsg(E.address, E.port, Msg.PlayerInfoBack.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
			
			id++;
			
			//Send peerinfo to all
		}
		
		if (MsgID == Msg.PlayerInput.ID)
		{
			var p:Player = playermap.get(ENet.peerKey(E.address, E.port));
			
			try
			{
				p.s_unserialize(Msg.PlayerInput.data.get("serialized"));
			}
			catch (e:Dynamic)
			{
				
			}
		}
	}
	
	public function readConfig():Map<String, String>
	{
		var map:Map<String, String> = new Map<String, String>();
		
		var str:String = File.getContent("config.txt");
		
		var key_value:Array<String> = str.split("\n");
		
		for (s in key_value)
		{
			StringTools.rtrim(s);
			
			var delimiter:Int = s.indexOf("=");
			
			var key:String = s.substring(0, delimiter);
			
			var value:String = s.substring(delimiter + 1, s.length);
			
			map.set(key, value);
		}
		
		return map;
	}
}