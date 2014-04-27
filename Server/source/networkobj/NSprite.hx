package networkobj;
import enet.ENet;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Ohmnivore
 */
class NSprite
{
	public var template:NTemplate;
	public var s:FlxSprite;
	public var ID:Int;
	
	public var oldpos:FlxPoint;
	
	public var move_timer:FlxTimer;
	
	public function new(X:Float, Y:Float, Template:NTemplate) 
	{
		template = Template;
		
		s = new FlxSprite(X, Y, Assets.images.get(template.graphicKey));
		s.drag.x = template.drag_x;
		s.acceleration.y = template.gravity_force;
		s.maxVelocity.x = template.maxspeed_x;
		
		oldpos = new FlxPoint(s.x, s.y);
		move_timer = new FlxTimer(2);
		//move_timer = FlxTimer.start(2);
		
		ID = NReg.getID();
		
		Reg.state.ent.add(s);
		
		NReg.sprites.push(this);
		announce(0);
	}
	
	public function announce(PlayerID:Int):Void
	{
		Msg.NewSprite.data.set("id", ID);
		Msg.NewSprite.data.set("x", s.x);
		Msg.NewSprite.data.set("y", s.y);
		Msg.NewSprite.data.set("template_id", template.ID);
		
		if (PlayerID == 0)
		{
			for (id in Reg.server.playermap.keys())
			{
				Reg.server.sendMsg(id, Msg.NewSprite.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
			}
		}
		
		else
		{
			Reg.server.sendMsg(PlayerID, Msg.NewSprite.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
	}
	
	public function sendUpdate():Void
	{
		if (oldpos.x == s.x && oldpos.y == s.y)
		{
			
		}
		
		else
		{
			move_timer.reset(2);
		}
		
		if (!move_timer.finished)
		{
			Msg.UpdateSprite.data.set("id", ID);
			Msg.UpdateSprite.data.set("x", s.x);
			Msg.UpdateSprite.data.set("y", s.y);
			Msg.UpdateSprite.data.set("velocity.x", s.velocity.x);
			Msg.UpdateSprite.data.set("velocity.y", s.velocity.y);
			
			for (id in Reg.server.playermap.keys())
			{
				Reg.server.sendMsg(id, Msg.UpdateSprite.ID, 2);
			}
		}
		
		oldpos.x = s.x;
		oldpos.y = s.y;
	}
	
	public function delete():Void
	{
		Msg.DeleteSprite.data.set("id", ID);
		for (id in Reg.server.playermap.keys())
		{
			Reg.server.sendMsg(id, Msg.DeleteSprite.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
		
		Reg.state.ent.remove(s);
		s.kill();
		s.destroy();
		
		NReg.sprites.remove(this);
	}
}