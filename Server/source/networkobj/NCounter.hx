package networkobj;

import flixel.FlxG;
import flixel.text.FlxText;
import enet.ENet;

/**
 * ...
 * @author Ohmnivore
 */
class NCounter extends NHUD
{
	public var ID:Int;
	public var t:FlxText;
	public var x:Int;
	public var y:Int;
	
	public var base:String;
	public var color:Int;
	public var count:Int = 0;
	
	public function new(Base:String, Color:Int = 0xff000000, X:Int, Y:Int, P:Int = 0, Local:Bool = false) 
	{
		super();
		local = Local;
		player = P;
		x = X;
		y = Y;
		base = Base;
		color = Color;
		
		ID = NReg.getID();
		
		if (local)
		{
			t = new FlxText(x, y, FlxG.width, '$base: $count', 12);
			t.color = color;
			t.setBorderStyle(FlxText.BORDER_OUTLINE, 0xff000000);
			t.scrollFactor.set();
			Reg.state.hud.add(t);
		}
		
		announce(player);
	}
	
	override public function announce(P:Int = 0):Void
	{
		super.announce(P);
		Msg.NewCounter.data.set("id", ID);
		Msg.NewCounter.data.set("base", base);
		Msg.NewCounter.data.set("x", x);
		Msg.NewCounter.data.set("y", y);
		
		Msg.SetCounter.data.set("id", ID);
		Msg.SetCounter.data.set("base", base);
		Msg.SetCounter.data.set("color", color);
		Msg.SetCounter.data.set("count", count);
		
		if (player == 0)
		{
			for (p in Reg.server.playermap.keys())
			{
				Reg.server.sendMsg(p, Msg.NewCounter.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
				Reg.server.sendMsg(p, Msg.SetCounter.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
			}
		}
		
		else
		{
			Reg.server.sendMsg(player, Msg.NewCounter.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
			Reg.server.sendMsg(player, Msg.SetCounter.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
	}
	
	public function setCount(Count:Int, NewColor:Int = null, NewBase:String = null):Void
	{
		count = Count;
		
		if (NewColor != null)
			color = NewColor;
		if (NewBase != null)
			base = NewBase;
		
		Msg.SetCounter.data.set("id", ID);
		Msg.SetCounter.data.set("base", base);
		Msg.SetCounter.data.set("color", color);
		Msg.SetCounter.data.set("count", count);
		
		if (player == 0)
		{
			for (p in Reg.server.playermap.keys())
			{
				Reg.server.sendMsg(p, Msg.SetCounter.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
			}
		}
		
		else
		{
			Reg.server.sendMsg(player, Msg.SetCounter.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
		
		if (local)
		{
			t.text = '$base: $count';
			t.color = color;
		}
	}
	
	override public function delete():Void
	{
		super.delete();
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