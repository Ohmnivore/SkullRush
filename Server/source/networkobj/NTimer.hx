package networkobj;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.text.FlxText;
import enet.ENet;

/**
 * ...
 * @author Ohmnivore
 */
class NTimer extends FlxObject
{
	public var local:Bool;
	public var player:Int;
	public var t:FlxText;
	
	public var base:String;
	public var count:Float = 0;
	
	public var status:Int;
	static public inline var STOPPED:Int = 0;
	static public inline var TICKING:Int = 1;
	static public inline var UNTICKING:Int = 2;
	
	public function new(Base:String, X:Int, Y:Int, P:Int = 0, Local:Bool = false) 
	{
		super();
		local = Local;
		player = P;
		x = X;
		y = Y;
		base = Base;
		status = STOPPED;
		
		ID = NReg.getID();
		
		Reg.state.hud.add(this);
		
		if (local)
		{
			t = new FlxText(x, y, FlxG.width, "0:00", 12);
			t.scrollFactor.set();
			Reg.state.hud.add(t);
		}
		
		announce(player);
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (status == TICKING)
		{
			count += FlxG.elapsed;
			//trace(count);
		}
		
		if (status == UNTICKING)
		{
			count -= FlxG.elapsed;
			
			if (count < 0)
				count = 0;
		}
		
		if (local && status != STOPPED)
		{
			var m:Int = Math.floor(count / 60);
			
			var s:Int = Std.int(count - 60 * m);
			
			if (s < 10)
			{
				t.text = '$base:  $m:0$s';
			}
			
			else
			{
				t.text = '$base:  $m:$s';
			}
		}
	}
	
	public function announce(P:Int = 0):Void
	{
		Msg.NewTimer.data.set("id", ID);
		Msg.NewTimer.data.set("base", base);
		Msg.NewTimer.data.set("x", x);
		Msg.NewTimer.data.set("y", y);
		
		if (player == 0)
		{
			NReg.timers.push(this);
			
			for (p in Reg.server.playermap.keys())
			{
				Reg.server.sendMsg(p, Msg.NewTimer.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
			}
		}
		
		else
		{
			Reg.server.sendMsg(player, Msg.NewTimer.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
	}
	
	public function setTimer(Count:Int, Color:Int, Status:Int = TICKING, NewBase:String = null):Void
	{
		count = Count;
		status = Status;
		
		if (NewBase != null)
			base = NewBase;
		
		Msg.SetTimer.data.set("id", ID);
		Msg.SetTimer.data.set("base", base);
		Msg.SetTimer.data.set("color", Color);
		Msg.SetTimer.data.set("count", Count);
		Msg.SetTimer.data.set("status", Status);
		
		if (player == 0)
		{
			for (p in Reg.server.playermap.keys())
			{
				Reg.server.sendMsg(p, Msg.SetTimer.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
			}
		}
		
		else
		{
			Reg.server.sendMsg(player, Msg.SetTimer.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
		
		if (local)
		{
			t.text = '$base: $count';
			t.color = Color;
		}
	}
	
	public function delete():Void
	{
		Msg.DeleteHUD.data.set("id", ID);
		
		if (player == 0)
		{
			NReg.timers.remove(this);
			
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
			
			Reg.state.hud.remove(this, true);
			kill();
			destroy();
		}
	}
	
}