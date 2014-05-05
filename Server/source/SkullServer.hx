package ;
import enet.ENet;
import enet.ENetEvent;
import enet.Server;
import entities.Spawn;
import flixel.FlxG;
import gamemodes.DefaultHooks;
import gevents.JoinEvent;
import gevents.LeaveEvent;
import gevents.ReceiveEvent;
import haxe.io.Bytes;
import haxe.io.BytesData;
import haxe.io.BytesInput;
import networkobj.NReg;
import sys.io.File;
import hxudp.UdpSocket;

/**
 * ...
 * @author Ohmnivore
 */
class SkullServer extends Server
{
	public var s:UdpSocket;
	public var internal_ip:String;
	
	public var config:Map<String, String>;
	public var manifestURL:String;
	
	public var peermap:Map<Player, Int>;
	public var playermap:Map<Int, Player>;
	
	public var id:Int = 1;
	
	public var s_name:String;
	public var players:Int = 0;
	public var players_max:Int;
	
	public function new(IP:String = null, Port:Int = 0, Channels:Int = 3, Players:Int = 32) 
	{
		playermap = new Map<Int, Player>();
		peermap = new Map<Player, Int>();
		
		super(IP, Port, Channels, Players);
		
		internal_ip = ENet.getLocalIP();
		
		Msg.addToHost(this);
		
		Msg.Manifest.data.set("url", manifestURL);
		
		players_max = Std.parseInt(Assets.config.get("maxplayers"));
		s_name = Assets.config.get("name");
		
		Masterserver.init();
		Masterserver.register(s_name);
		
		s = new UdpSocket();
		s.create();
		s.bind(1945);
		s.setNonBlocking(true);
		s.setEnableBroadcast(true);
		s.connect(ENet.BROADCAST_ADDRESS, 1990);
	}
	
	public function updateS():Void
	{
		var b = Bytes.alloc(80);
		s.receive(b);
		var msg:String = new BytesInput(b).readUntil(0);
		if (msg.length > 0) trace("Msg: ", msg);
		
		if (msg == "get_info")
		{
			var info:String = '';
			info += '[';
			info += '"$s_name", ';
			var mapname:String = Reg.mapname;
			info += '"$mapname", ';
			var gm_name:String = Reg.gm.name;
			info += '"$gm_name", ';
			info += '$players, ';
			info += '$players_max, ';
			info += '"$internal_ip"';
			info += ']';
			trace("Info: ", info);
			
			s.sendAll(Bytes.ofString(info));
		}
	}
	
	override public function onPeerConnect(e:ENetEvent):Void
	{
		super.onPeerConnect(e);
		
		players++;
		
		if (players > players_max)
		{
			peerDisconnect(e.ID, false);
		}
		
		else
		{
			sendMsg(e.ID, Msg.Manifest.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
			
			Masterserver.setPlayers(players, players_max);
		}
	}
	
	override public function onPeerDisonnect(e:ENetEvent):Void 
	{
		super.onPeerDisonnect(e);
		
		players--;
		
		Masterserver.setPlayers(players, players_max);
		
		Reg.gm.dispatchEvent(new LeaveEvent(LeaveEvent.LEAVE_EVENT, e));
	}
	
	public function announce(Text:String, Markup:Array<FlxMarkup>):Void
	{
		var t:FlxTextExt = new FlxTextExt(0, 0, FlxG.width, Text, 12, false, Markup);
		
		//Add locally
		Reg.announcer.addMsg(Text, Markup);
		
		//Send to clients
		Msg.Announce.data.set("message", t.text);
		Msg.Announce.data.set("markup", t.ExportMarkups());
		
		for (ID in peermap.iterator())
		{
			sendMsg(ID, Msg.Announce.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
	}
	
	override public function onReceive(MsgID:Int, E:ENetEvent):Void 
	{
		if (MsgID == Msg.PlayerInfo.ID)
		{
			Reg.gm.dispatchEvent(new JoinEvent(JoinEvent.JOIN_EVENT, E));
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
		
		super.onReceive(MsgID, E);
		
		Reg.gm.dispatchEvent(new ReceiveEvent(ReceiveEvent.RECEIVE_EVENT, MsgID, E));
		
		if (MsgID == Msg.PlayerInfo.ID)
		{
			//Msg.AnnounceTemplates.data.set("serialized", NReg.exportTemplates());
			//
			//sendMsg(E.ID, Msg.AnnounceTemplates.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
			//
			//for (s in NReg.sprites)
			//{
				//s.announce(E.ID);
			//}
			//
			//for (h in NReg.huds)
			//{
				//h.announce(E.ID);
			//}
			//
			//for (t in NReg.timers)
			//{
				//t.announce(E.ID);
			//}
		}
	}
}