package entities;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import gamemodes.CTF;
import haxe.xml.Fast;
import networkobj.NFlxSprite;
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
	static public var taken_flags:Map<Player, Flag>;
	
	public var holder:Holder;
	
	public var team:Int;
	public var taken:Bool;
	public var owner:Player;
	
	public function new(Data:Fast) 
	{
		data = Data;
		
		team = Std.parseInt(data.att.team);
		taken = false;
		
		var templ:NTemplate = new NTemplate(data.att.graphic, 0);
		NReg.registerTemplate(templ);
		
		super(Std.parseInt(data.att.x), Std.parseInt(data.att.y), templ, NFlxSprite);
		
		holder = new Holder(data, this);
		
		var gm:CTF = cast(Reg.gm, CTF);
		gm.flags.add(s);
		
		s.x += 4;
		
		s.immovable = true;
	}
	
	static public function makeFromXML(D:Fast):Flag
	{
		return new Flag(D);
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
					//f.s.velocity.x = f.owner.velocity.x;
					//f.s.velocity.y = f.owner.velocity.y;
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
		
		P.score += 100;
		var gm:CTF = cast Reg.gm;
		gm.setPlayerScoreboard(P);
	}
	
	static public function returnFlag(P:Player = null, F:Flag):Void
	{
		F.s.x = F.holder.s.x + 4;
		F.s.y = F.holder.s.y - (33 - F.holder.s.height);
		
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
			
			P.score += 100;
			var gm:CTF = cast Reg.gm;
			gm.setPlayerScoreboard(P);
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
		taken_flags = new Map<Player, Flag>();
		Holder.init();
	}
}