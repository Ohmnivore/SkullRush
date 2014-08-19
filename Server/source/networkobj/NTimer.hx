package networkobj;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.text.FlxText;
import enet.ENet;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

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
	public var color:Int;
	public var count:Float = 0;
	
	public var status:Int;
	static public inline var STOPPED:Int = 0;
	static public inline var TICKING:Int = 1;
	static public inline var UNTICKING:Int = 2;
	
	public function new(Base:String, Color:Int = 0xff000000, X:Int, Y:Int, P:Int = 0, Local:Bool = false) 
	{
		super();
		local = Local;
		player = P;
		x = X;
		y = Y;
		base = Base;
		color = Color;
		status = STOPPED;
		
		ID = NReg.getID();
		
		Reg.state.hud.add(this);
		
		if (local)
		{
			t = new FlxText(x, y, FlxG.width, "0:00", 12);
			t.color = Color;
			t.setBorderStyle(FlxText.BORDER_OUTLINE, 0xff000000);
			t.scrollFactor.set();
			Reg.state.hud.add(t);
			
			t.alpha = 0;
			FlxTween.tween(t, { alpha:1 }, 1, { type:FlxTween.ONESHOT, ease:FlxEase.cubeIn } );
			FlxTween.linearMotion(t, t.x, t.y - 20, t.x, t.y, 1, true, { type:FlxTween.ONESHOT, ease:FlxEase.quadIn});
		}
		
		announce(player);
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (status == TICKING)
		{
			count += FlxG.elapsed;
		}
		
		if (status == UNTICKING)
		{
			count -= FlxG.elapsed;
			
			if (count < 0)
				count = 0;
		}
		
		if (local && status != STOPPED)
		{
			t.text = countToText(count);
		}
	}
	
	private function countToText(Count:Float):String
	{
		var ret:String = "";
		
		var m:Int = Math.floor(Count / 60);
		
		var s:Int = Std.int(Count - 60 * m);
		
		if (s < 10)
		{
			ret = '$base:  $m:0$s';
		}
		
		else
		{
			ret = '$base:  $m:$s';
		}
		
		return ret;
	}
	
	public function announce(P:Int = 0):Void
	{
		Msg.NewTimer.data.set("id", ID);
		Msg.NewTimer.data.set("base", base);
		Msg.NewTimer.data.set("x", x);
		Msg.NewTimer.data.set("y", y);
		
		Msg.SetTimer.data.set("id", ID);
		Msg.SetTimer.data.set("base", base);
		Msg.SetTimer.data.set("color", color);
		Msg.SetTimer.data.set("count", count);
		Msg.SetTimer.data.set("status", status);
		
		if (P == 0)
		{
			NReg.timers.push(this);
			
			Reg.server.sendMsgToAll(Msg.NewTimer.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
			Reg.server.sendMsgToAll(Msg.SetTimer.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
		
		else
		{
			Reg.server.sendMsg(P, Msg.NewTimer.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
			Reg.server.sendMsg(P, Msg.SetTimer.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
	}
	
	public function setTimer(Count:Int, Status:Int = TICKING, NewColor:Int = null, NewBase:String = null):Void
	{
		if (local && Status != status)
		{
			FlxTween.tween(t, { x:t.x + 10 }, 1, { type:FlxTween.ONESHOT, ease:FlxEase.bounceOut, complete:stopTween } );
		}
		
		count = Count;
		status = Status;
		
		if (NewColor != null)
			color = NewColor;
		if (NewBase != null)
			base = NewBase;
		
		Msg.SetTimer.data.set("id", ID);
		Msg.SetTimer.data.set("base", base);
		Msg.SetTimer.data.set("color", color);
		Msg.SetTimer.data.set("count", count);
		Msg.SetTimer.data.set("status", status);
		
		if (player == 0)
		{
			Reg.server.sendMsgToAll(Msg.SetTimer.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
		
		else
		{
			Reg.server.sendMsg(player, Msg.SetTimer.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
		
		if (local)
		{
			t.text = '$base: $count';
			t.color = color;
			t.text = countToText(count);
		}
	}
	
	private function stopTween(T:FlxTween):Void
	{
		FlxTween.tween(t, { x:t.x - 10 }, 1, { type:FlxTween.ONESHOT, ease:FlxEase.bounceOut } );
	}
	
	public function delete():Void
	{
		Msg.DeleteHUD.data.set("id", ID);
		
		if (player == 0)
		{
			NReg.timers.remove(this);
			
			Reg.server.sendMsgToAll(Msg.DeleteHUD.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
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