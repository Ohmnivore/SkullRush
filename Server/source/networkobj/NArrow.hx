package networkobj;
import enet.ENet;

/**
 * ...
 * @author ...
 */
class NArrow
{
	static public function create(ParentID:Int, Color:Int, PlayerID:Int = 0):Void
	{
		Msg.ArrowNew.data.set("parentid", ParentID);
		Msg.ArrowNew.data.set("color", Color);
		
		if (PlayerID == 0)
		{
			Reg.server.sendMsgToAll(Msg.ArrowNew.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
		else
		{
			Reg.server.sendMsg(PlayerID, Msg.ArrowNew.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
	}
	
	static public function toggle(ParentID:Int, On:Bool, PlayerID:Int = 0):Void
	{
		Msg.ArrowToggle.data.set("parentid", ParentID);
		Msg.ArrowToggle.data.set("on", On);
		
		if (PlayerID == 0)
		{
			Reg.server.sendMsgToAll(Msg.ArrowToggle.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
		else
		{
			Reg.server.sendMsg(PlayerID, Msg.ArrowToggle.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
	}
	
	static public function destroy(ParentID:Int, PlayerID:Int = 0):Void
	{
		Msg.ArrowDelete.data.set("parentid", ParentID);
		
		if (PlayerID == 0)
		{
			Reg.server.sendMsgToAll(Msg.ArrowDelete.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
		else
		{
			Reg.server.sendMsg(PlayerID, Msg.ArrowDelete.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
	}
}