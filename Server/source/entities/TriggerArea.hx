package entities;

import entities.TriggerArea.TriggerHitbox;
import flixel.FlxG;
import flixel.FlxSprite;
import haxe.xml.Fast;

/**
 * ...
 * @author ...
 */
class TriggerArea extends Trigger
{
	public var teams:Array<Bool>;
	public var doToggle:Bool;
	
	public function new(Parent:Dynamic, Cooldown:Int, DoToggle:Bool, Teams:Array<Bool>,
		X:Int, Y:Int, Width:Int, Height:Int) 
	{
		teams = Teams;
		doToggle = DoToggle;
		super(Parent, Cooldown);
		
		new TriggerHitbox(this, X, Y, Width, Height);
	}
	
	static public function makeFromXML(D:Fast):TriggerArea
	{
		var doToggle:Bool = false;
		if (D.att.doToggle == "True")
			doToggle = true;
		
		var teams:Array<Bool> = [];
		var teamtext:String = D.att.teams;
		
		var t:Int = 0;
		while (t < teamtext.length)
		{
			if (teamtext.charAt(t) == "1")
			{
				teams.push(true);
			}
			
			else
			{
				teams.push(false);
			}
			
			t++;
		}
		
		return new TriggerArea(D.att.parent,
			Std.parseInt(D.att.cooldown),
			doToggle,
			teams,
			Std.parseInt(D.att.x),
			Std.parseInt(D.att.y),
			Std.parseInt(D.att.width),
			Std.parseInt(D.att.height));
	}
	
	static public function init():Void
	{
		
	}
}

class TriggerHitbox extends FlxSprite
{
	public var trigger:TriggerArea;
	
	public function new(Trig:TriggerArea, X:Int, Y:Int, Width:Int, Height:Int)
	{
		super(X, Y);
		trigger = Trig;
		
		makeGraphic(Width, Height, 0x00000000);
		
		Reg.state.ent.add(this);
	}
	
	override public function update():Void 
	{
		super.update();
		
		for (p in Reg.server.playermap.iterator())
		{
			if (trigger.teams[p.team] == true)
			{
				if (FlxG.overlap(this, p) && trigger.ready)
				{
					if (trigger.doToggle)
					{
						trigger.toggle();
					}
					else
					{
						trigger.activate();
					}
				}
			}
		}
	}
}