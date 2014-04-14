package ;
import enet.Client;
import enet.ENet;
import enet.ENetEvent;
import flixel.FlxG;
import haxe.Unserializer;

/**
 * ...
 * @author Ohmnivore
 */
class SkullClient extends Client
{
	public var rIP:String;
	public var rPort:Int;
	private var _s_id:Int;
	
	public function new(IP:String = "", Port:Int = 6666)
	{
		super(IP, Port, 3, 1);
		
		rIP = IP;
		rPort = Port;
		
		Msg.addToHost(this);
	}
	
	public function updatePingText():Void
	{
		if (_s_id > 0)
			Reg.state.ping_text.text = Std.string(ENet.getPeerPing(_s_id));
	}
	
	override public function onPeerConnect(e:ENetEvent):Void
	{
		super.onPeerConnect(e);
		
		trace("Connected successfully!");
		
		_s_id = e.ID;
	}
	
	override public function onPeerDisonnect(e:ENetEvent):Void 
	{
		super.onPeerDisonnect(e);
		
		trace("Disconnected!");
	}
	
	override public function onReceive(MsgID:Int, E:ENetEvent):Void 
	{
		super.onReceive(MsgID, E);
		
		if (MsgID == Msg.Manifest.ID)
		{
			if (Msg.Manifest.data.get("url") == "")
			{
				Reg.state.onLoaded();
			}
			else
			{
				var d:Downloader = new Downloader(Msg.Manifest.data.get("url"));
				d.whenfinished = Reg.state.onLoaded;
			}
		}
		
		if (MsgID == Msg.MapMsg.ID)
		{
			Reg.state.loadMap(Msg.MapMsg.data.get("mapname"), Msg.MapMsg.data.get("mapstring"));
		}
		
		if (MsgID == Msg.PlayerInfoBack.ID)
		{
			Reg.state.player = new Player(Msg.PlayerInfoBack.data.get("id"),
								Msg.PlayerInfoBack.data.get("name"),
								50,
								50);
			
			Reg.state.player.setColor(Msg.PlayerInfoBack.data.get("color"),
										Msg.PlayerInfoBack.data.get("graphic"));
			
			Reg.state.playermap.set(Reg.state.player.ID, Reg.state.player);
			
			FlxG.camera.follow(Reg.state.player);
			FlxG.camera.followLerp = 15.0;
		}
		
		if (MsgID == Msg.PlayerInfoAnnounce.ID)
		{
			var p:Player = new Player(Msg.PlayerInfoAnnounce.data.get("id"),
										Msg.PlayerInfoAnnounce.data.get("name"),
										50,
										50);
			
			p.setColor(Msg.PlayerInfoAnnounce.data.get("color"),
						Msg.PlayerInfoAnnounce.data.get("graphic"));
			
			Reg.state.playermap.set(p.ID, p);
		}
		
		if (MsgID == Msg.PlayerDisco.ID)
		{
			var p:Player = Reg.state.playermap.get(Msg.PlayerDisco.data.get("id"));
			
			if (p != null)
			{
				Reg.state.playermap.remove(Msg.PlayerDisco.data.get("id"));
				
				p.kill();
			}
		}
		
		if (MsgID == Msg.PlayerOutput.ID)
		{
			var arr:Array<String> = Unserializer.run(Msg.PlayerOutput.data.get("serialized"));
			
			for (s in arr)
			{
				var parr:Array<Dynamic> = Unserializer.run(s);
				
				try
				{
					if (parr != null)
					{
						if (parr[0] != null)
						{
							var p:Player = Reg.state.playermap.get(parr[0]);
							
							if (p != null)
							{
								p.c_unserialize(parr);
							}
						}
					}
				}
				catch (e:Dynamic)
				{
					
				}
			}
		}
		
		if (MsgID == Msg.ChatToClient.ID)
		{
			var ID:Int = Msg.ChatToClient.data.get("id");
			
			if (ID == 0)
			{
				Reg.chatbox.addMsg(Msg.ChatToClient.data.get("message"),
									Msg.ChatToClient.data.get("color"));
			}
			
			else
			{
				Reg.chatbox.addMsg(Msg.ChatToClient.data.get("message"),
									Msg.ChatToClient.data.get("color"));
			}
		}
		
		if (MsgID == Msg.Announce.ID)
		{
			Reg.announcer.parseMsg(Msg.Announce.data.get("message"), Msg.Announce.data.get("markup"));
		}
	}
	
	/**
	 * Does what it says. Also returns the target client's RTT.
	 * 
	 * @param	MsgID	The ID of the message you intend to send. It's contents at the moment of the call will be sent.
	 * @param	Channel Which channel to send through
	 * @param	Flags	ENet flags, use | to unite flags, if they don't conflict
	 * @return	Returns the target client's RTT, divide by two to obtain the traditional "ping"
	 */
	public function send(MsgID:Int, Channel:Int = 0, Flags:Int = 0):Void 
	{
		super.sendMsg(_s_id, MsgID, Channel, Flags);
	}
}