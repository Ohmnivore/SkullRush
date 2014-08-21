package networkobj;
import enet.ENet;

/**
 * ...
 * @author ...
 */
class NFlxLine extends FlxLaserLine
{
	private var _X:Float;
	private var _Y:Float;
	private var _Length:Int;
	private var _Angle:Float;
	
	public function new(X:Float, Y:Float, Length:Int, Angle:Float):Void
	{
		super(X, Y, Length, Angle);
		
		_X = X;
		_Y = Y;
		_Length = Length;
		_Angle = Angle;
		
		ID = NReg.getID();
	}
	
	public function announce(P:Int = 0):Void
	{
		Msg.LineNew.data.set("id", ID);
		Msg.LineNew.data.set("x", _X);
		Msg.LineNew.data.set("y", _Y);
		Msg.LineNew.data.set("length", _Length);
		Msg.LineNew.data.set("angle", _Angle);
		
		if (P == 0)
		{
			Reg.server.sendMsgToAll(Msg.LineNew.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
		else
		{
			Reg.server.sendMsg(P, Msg.LineNew.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
	}
	
	public function setVisible(Visible:Bool, P:Int = 0, Local:Bool = true):Void
	{
		if (Local)
		{
			visible = Visible;
		}
		
		Msg.LineToggle.data.set("id", ID);
		Msg.LineToggle.data.set("visible", Visible);
		
		if (P == 0)
		{
			Reg.server.sendMsgToAll(Msg.LineToggle.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
		else
		{
			Reg.server.sendMsg(P, Msg.LineToggle.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
	}
}