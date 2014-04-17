package networkobj;
import enet.ENet;
import flixel.FlxG;
import flixel.text.FlxText;

/**
 * ...
 * @author Ohmnivore
 */
class NLabel
{
	public var local:Bool;
	public var player:Int;
	
	public var ID:Int;
	public var t:FlxText;
	public var x:Int;
	public var y:Int;
	
	public function new(X:Int, Y:Int, P:Int = 0, Local:Bool = false) 
	{
		local = Local;
		player = P;
		x = X;
		y = Y;
		
		ID = NReg.getID();
		
		if (local)
		{
			t = new FlxText(x, y, FlxG.width, "", 12);
			t.scrollFactor.set();
			Reg.state.hud.add(t);
		}
		
		announce(player);
	}
	
	public function announce(P:Int = 0):Void
	{
		Msg.NewLabel.data.set("id", ID);
		Msg.NewLabel.data.set("x", x);
		Msg.NewLabel.data.set("y", y);
		
		if (player == 0)
		{
			for (p in Reg.server.playermap.keys())
			{
				Reg.server.sendMsg(p, Msg.NewLabel.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
			}
		}
		
		else
		{
			Reg.server.sendMsg(player, Msg.NewLabel.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
	}
	
	public function setLabel(Text:String, Color:Int):Void
	{
		Msg.SetLabel.data.set("id", ID);
		Msg.SetLabel.data.set("text", Text);
		Msg.SetLabel.data.set("color", Color);
		
		if (player == 0)
		{
			for (p in Reg.server.playermap.keys())
			{
				Reg.server.sendMsg(p, Msg.SetLabel.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
			}
		}
		
		else
		{
			Reg.server.sendMsg(player, Msg.SetLabel.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
		
		if (local)
		{
			t.text = Text;
			t.color = Color;
		}
	}
	
	public function delete():Void
	{
		Msg.DeleteHUD.data.set("id", ID);
		
		if (player == 0)
		{
			for (p in Reg.server.playermap.keys())
			{
				Reg.server.sendMsg(p, Msg.DeleteHUD.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
			}
		}
		
		else
		{
			Reg.server.sendMsg(player, Msg.DeleteHUD.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
		
		if (local)
		{
			Reg.state.hud.remove(t, true);
			t.kill();
			t.destroy();
		}
	}
	
}