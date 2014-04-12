package ;
import enet.ENet;
import enet.ENetEvent;
import enet.Server;
//import flixel.text.FlxText;
import sys.io.File;

/**
 * ...
 * @author Ohmnivore
 */
class SkullServer extends Server
{
	public var config:Map<String, String>;
	public var manifestURL:String;
	
	public var peermap:Map<Player, Int>;
	public var playermap:Map<Int, Player>;
	
	public var id:Int = 1;
	//private var _pingtext:FlxText;
	
	public function new(IP:String = null, Port:Int = 0, Channels:Int = 3, Players:Int = 32) 
	{
		playermap = new Map<Int, Player>();
		peermap = new Map<Player, Int>();
		
		manifestURL = Assets.config.get("manifesturl");
		
		super(IP, Port, Channels, Players);
		
		Msg.addToHost(this);
		
		Msg.Manifest.data.set("url", manifestURL);
	}
	
	override public function onPeerConnect(e:ENetEvent):Void
	{
		super.onPeerConnect(e);
		
		trace("Peer connected!", e.ID);
		
		sendMsg(e.ID, Msg.Manifest.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
	}
	
	override public function onPeerDisonnect(e:ENetEvent):Void 
	{
		super.onPeerDisonnect(e);
		
		trace("Peer disconnected!", e.ID);
		
		var p:Player = playermap.get(e.ID);
		
		//Send disconnect to everyone
		Msg.PlayerDisco.data.set("id", e.ID);
		for (pl in playermap.iterator())
		{
			if (e.ID != pl.ID)
			{
				sendMsg(pl.ID, Msg.PlayerDisco.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
			}
		}
		
		peermap.remove(p);
		playermap.remove(p.ID);
		
		p.kill();
	}
	
	override public function onReceive(MsgID:Int, E:ENetEvent):Void 
	{
		super.onReceive(MsgID, E);
		
		if (MsgID == Msg.PlayerInfo.ID)
		{
			var name:String = Msg.PlayerInfo.data.get("name");
			name = StringTools.trim(name);
			if (name.length > 15) name = name.substr(0, 15);
			
			for (pl in playermap.iterator())
			{
				if (pl.name == name)
				{
					name += "*";
				}
			}
			
			var p:Player = new Player(E.ID, name, 50, 50);
			
			//_pingtext = new FlxText(0, 0, 70, "0");
			//_pingtext.scrollFactor.set();
			//Reg.state.over_players.add(_pingtext);
			
			var color:Int = Msg.PlayerInfo.data.get("team");
			if (color == 0)
			{
				p.team = 0;
				p.setColor(0xff13BF00, "assets/images/playergreen.png");
			}
			if (color == 1)
			{
				p.team = 1;
				p.setColor(0xff0086BF, "assets/images/playerblue.png");
			}
			if (color == 2)
			{
				p.team = 2;
				p.setColor(0xffE0DD00, "assets/images/playeryellow.png");
			}
			if (color == 3)
			{
				p.team = 3;
				p.setColor(0xffD14900, "assets/images/playerred.png");
			}
			
			peermap.set(p, p.ID);
			playermap.set(p.ID, p);
			
			Msg.PlayerInfoBack.data.set("id", p.ID);
			Msg.PlayerInfoBack.data.set("name", p.name);
			Msg.PlayerInfoBack.data.set("color", p.header.color);
			Msg.PlayerInfoBack.data.set("graphic", p.graphicKey);
			
			sendMsg(E.ID, Msg.MapMsg.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
			sendMsg(E.ID, Msg.PlayerInfoBack.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
			
			id++;
			
			//Send peerinfo to all
			Msg.PlayerInfoAnnounce.data.set("name", p.name);
			Msg.PlayerInfoAnnounce.data.set("id", p.ID);
			Msg.PlayerInfoAnnounce.data.set("color", p.header.color);
			Msg.PlayerInfoAnnounce.data.set("graphic", p.graphicKey);
			for (pl in playermap.iterator())
			{
				if (p.ID != pl.ID)
				{
					sendMsg(pl.ID, Msg.PlayerInfoAnnounce.ID, 1,
							ENet.ENET_PACKET_FLAG_RELIABLE);
				}
			}
			
			for (pl in playermap.iterator())
			{
				if (p.ID != pl.ID)
				{
					Msg.PlayerInfoAnnounce.data.set("name", pl.name);
					Msg.PlayerInfoAnnounce.data.set("id", pl.ID);
					Msg.PlayerInfoAnnounce.data.set("color", pl.header.color);
					Msg.PlayerInfoAnnounce.data.set("graphic", pl.graphicKey);
					
					sendMsg(p.ID, Msg.PlayerInfoAnnounce.ID, 1,
							ENet.ENET_PACKET_FLAG_RELIABLE);
				}
			}
		}
		
		if (MsgID == Msg.PlayerInput.ID)
		{
			var p:Player = playermap.get(E.ID);
			
			try
			{
				p.s_unserialize(Msg.PlayerInput.data.get("serialized"));
			}
			catch (e:Dynamic)
			{
				trace("ah");
			}
		}
		
		if (MsgID == Msg.ChatToServer.ID)
		{
			var p:Player = playermap.get(E.ID);
			
			if (p != null)
			{
				var t:String = Msg.ChatToServer.data.get("message");
				
				t = StringTools.trim(t);
				
				if (t.length > 0)
				{
					t = p.name + ": " + t;
					
					Msg.ChatToClient.data.set("id", p.ID);
					Msg.ChatToClient.data.set("color", p.header.color);
					Msg.ChatToClient.data.set("message", t);
					
					Reg.chatbox.addMsg(t, p.header.color);
					
					for (ID in peermap.iterator())
					{
						sendMsg(ID, Msg.ChatToClient.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
					}
				}
			}
		}
	}
}