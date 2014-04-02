package ;
import enet.Client;
import enet.ENetEvent;

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
		super(IP, Port, 2, 1);
		
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
	
	override public function onReceive(MsgID:Int):Void 
	{
		super.onReceive(MsgID);
		
		if (MsgID == Msg.MapMsg.ID)
		{
			Reg.state.loadMap(Msg.MapMsg.data.get("mapname"), Msg.MapMsg.data.get("mapstring"));
		}
	}
	
}