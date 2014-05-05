package entities;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import gamemodes.CTF;
import haxe.xml.Fast;
import networkobj.NReg;
import networkobj.NSprite;
import networkobj.NTemplate;

/**
 * ...
 * @author Ohmnivore
 */
class Flag extends NSprite
{
	public var data:Fast;
	static public var T_FLAG_G:NTemplate;
	static public var T_FLAG_B:NTemplate;
	static public var T_FLAG_Y:NTemplate;
	static public var T_FLAG_R:NTemplate;
	static var did_init:Bool = false;
	static public var taken_flags:Map<Player, Flag>;
	
	public var holder:Holder;
	
	public var team:Int;
	public var taken:Bool;
	public var owner:Player;
	
	public function new(Data:Fast) 
	{
		if (!did_init)
		{
			init();
			did_init = true;
		}
		
		data = Data;
		
		team = Std.parseInt(data.att.team);
		taken = false;
		
		switch(team)
		{
			case 0:
				super(Std.parseInt(data.att.x), Std.parseInt(data.att.y), T_FLAG_G);
			case 1:
				super(Std.parseInt(data.att.x), Std.parseInt(data.att.y), T_FLAG_B);
			case 2:
				super(Std.parseInt(data.att.x), Std.parseInt(data.att.y), T_FLAG_Y);
			case 3:
				super(Std.parseInt(data.att.x), Std.parseInt(data.att.y), T_FLAG_R);
		}
		
		holder = new Holder(data, this);
		
		var gm:CTF = cast(Reg.gm, CTF);
		gm.flags.add(s);
		
		s.immovable = true;
	}
	
	static public function updateFlags():Void
	{
		for (f in taken_flags.iterator())
		{
			if (f.owner != null)
			{
				if (f.owner.alive)
				{
					f.s.x = f.owner.x;
					f.s.y = f.owner.y;
				}
				
				else
				{
					Flag.taken_flags.remove(f.owner);
					f.owner = null;
				}
			}
		}
	}
	
	static public function takeFlag(P:Player, F:Flag):Void
	{
		F.owner = P;
		
		F.taken = true;
		
		taken_flags.set(P, F);
		
		var s:String = P.name + " took the flag!";
		Reg.server.announce(s, [new FlxMarkup(0, P.name.length, false, P.header.color)]);
	}
	
	static public function returnFlag(P:Player = null, F:Flag):Void
	{
		F.s.x = F.holder.s.x;
		F.s.y = F.holder.s.y;
		
		F.taken = false;
		if (F.owner != null)
		{
			taken_flags.remove(F.owner);
			F.owner = null;
		}
		
		if (P != null)
		{
			var s:String = P.name + " returned the flag!";
			Reg.server.announce(s, [new FlxMarkup(0, P.name.length, false, P.header.color)]);
		}
	}
	
	static public function collideFlag(P:Player, F:FlxSprite):Void
	{
		if (P.alive)
		{
			var f:Flag = cast(NReg.sprites.get(F.ID), Flag);
			
			if (P.team == f.team)
			{
				if (f.taken && f.owner == null)
				{
					returnFlag(P, f);
				}
			}
			
			else
			{
				if (f.owner == null)
				{
					takeFlag(P, f);
				}
			}
		}
	}
	
	static public function init():Void
	{
		T_FLAG_G = new NTemplate("assets/images/flag_g.png");
		T_FLAG_B = new NTemplate("assets/images/flag_b.png");
		T_FLAG_Y = new NTemplate("assets/images/flag_y.png");
		T_FLAG_R = new NTemplate("assets/images/flag_r.png");
		T_FLAG_G.gravity_force = 0;
		T_FLAG_B.gravity_force = 0;
		T_FLAG_Y.gravity_force = 0;
		T_FLAG_R.gravity_force = 0;
		NReg.registerTemplate(T_FLAG_G);
		NReg.registerTemplate(T_FLAG_B);
		NReg.registerTemplate(T_FLAG_Y);
		NReg.registerTemplate(T_FLAG_R);
		
		taken_flags = new Map<Player, Flag>();
	}
}