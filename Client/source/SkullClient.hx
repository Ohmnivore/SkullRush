package ;
import enet.Client;
import enet.ENetEvent;
import haxe.Unserializer;

/**
 * ...
 * @author Ohmnivore
 */
class SkullClient extends Client
{
	private var _sIP:String;
	private var _sPort:Int;
	
	public function new(IP:String = "", Port:Int = 6666)
	{
		super(IP, Port, 3, 1);
		
		Msg.addToHost(this);
	}
	
	override public function onPeerConnect(e:ENetEvent):Void
	{
		super.onPeerConnect(e);
		
		trace("Connected successfully!");
		_sIP = e.address;
		_sPort = e.port;
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
			var d:Downloader = new Downloader(Msg.Manifest.data.get("url"));
			d.whenfinished = Reg.state.onLoaded;
		}
		
		if (MsgID == Msg.MapMsg.ID)
		{
			Reg.state.loadMap(Msg.MapMsg.data.get("mapname"), Msg.MapMsg.data.get("mapstring"));
		}
		
		if (MsgID == Msg.PlayerInfoBack.ID)
		{
			Reg.state.player.name = Msg.PlayerInfoBack.data.get("name");
			//TODO: set header.text and team/color
			Reg.state.player.header.text = Msg.PlayerInfoBack.data.get("name");
			
			Reg.state.playermap.set(Msg.PlayerInfoBack.data.get("id"), Reg.state.player);
		}
		
		if (MsgID == Msg.PlayerInfoAnnounce.ID)
		{
			var p:Player = new Player(Msg.PlayerInfoAnnounce.data.get("id"),
										Msg.PlayerInfoAnnounce.data.get("name"),
										50,
										50);
			
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
	}
	
	/**
	 * Does what it says. Also returns the target client's RTT.
	 * 
	 * @param	MsgID	The ID of the message you intend to send. It's contents at the moment of the call will be sent.
	 * @param	Channel Which channel to send through
	 * @param	Flags	ENet flags, use | to unite flags, if they don't conflict
	 * @return	Returns the target client's RTT, divide by two to obtain the traditional "ping"
	 */
	public function send(MsgID:Int, Channel:Int = 0, Flags:Int = 0):Int 
	{
		return super.sendMsg(_sIP, _sPort, MsgID, Channel, Flags);
	}
}