package networkobj;
import enet.ENet;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

/**
 * ...
 * @author Ohmnivore
 */
class NLabel extends NHUD
{
	public var ID:Int;
	public var t:FlxText;
	public var x:Int;
	public var y:Int;
	public var color:Int;
	
	public function new(X:Int, Y:Int, Color:Int = 0xff000000, P:Int = 0, Local:Bool = false) 
	{
		super();
		local = Local;
		player = P;
		x = X;
		y = Y;
		color = Color;
		
		ID = NReg.getID();
		
		if (local)
		{
			t = new FlxText(x, y, FlxG.width, "", 12);
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
	
	override public function announce(P:Int = 0):Void
	{
		super.announce(P);
		
		Msg.NewLabel.data.set("id", ID);
		Msg.NewLabel.data.set("x", x);
		Msg.NewLabel.data.set("y", y);
		
		Msg.SetLabel.data.set("id", ID);
		Msg.SetLabel.data.set("text", " ");
		Msg.SetLabel.data.set("color", color);
		
		if (player == 0)
		{
			Reg.server.sendMsgToAll(Msg.NewLabel.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
			Reg.server.sendMsgToAll(Msg.SetLabel.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
		
		else
		{
			Reg.server.sendMsg(player, Msg.NewLabel.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
			Reg.server.sendMsg(player, Msg.SetLabel.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
	}
	
	public function setLabel(Text:String, NewColor:Int = null):Void
	{
		if (NewColor != null)
			color = NewColor;
		
		Msg.SetLabel.data.set("id", ID);
		Msg.SetLabel.data.set("text", Text);
		Msg.SetLabel.data.set("color", color);
		
		if (player == 0)
		{
			Reg.server.sendMsgToAll(Msg.SetLabel.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
		
		else
		{
			Reg.server.sendMsg(player, Msg.SetLabel.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
		
		if (local)
		{
			t.text = Text;
			t.color = color;
		}
	}
	
	override public function delete():Void
	{
		super.delete();
		Msg.DeleteHUD.data.set("id", ID);
		
		if (player == 0)
		{
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
			//t.destroy();
		}
	}
	
}