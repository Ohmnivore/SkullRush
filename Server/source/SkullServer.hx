package ;
import enet.ENet;
import enet.ENetEvent;
import enet.Server;

/**
 * ...
 * @author Ohmnivore
 */
class SkullServer extends Server
{
	public function new(IP:String = null, Port:Int = 0, Channels:Int = 2, Players:Int = 32) 
	{
		super(IP, Port, Channels, Players);
		
		//Msg.addToHost(this);
		addMessage(Msg.MapMsg);
	}
	
	override public function onPeerConnect(e:ENetEvent):Void
	{
		super.onPeerConnect(e);
		
		trace("Peer connected!");
		
		peers.set(ENet.peerKey(e.address, e.port), "");
		
		sendMsg(e.address, e.port, Msg.MapMsg.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
	}
	
	override public function onPeerDisonnect(e:ENetEvent):Void 
	{
		super.onPeerDisonnect(e);
		
		trace("Peer disconnected!");
		
		peers.remove(ENet.peerKey(e.address, e.port));
	}
	
	override public function onReceive(MsgID:Int):Void 
	{
		super.onReceive(MsgID);
	}
}