package entities;
import entities.Flag.FlagSprite;
import entities.HealthPack.Pack;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxTimer;
import gamemodes.CTF;
import haxe.xml.Fast;
import networkobj.NFlxSprite;
import networkobj.NReg;
import networkobj.NSprite;
import networkobj.NTemplate;
import flixel.FlxSprite;
import ext.FlxMarkup;

/**
 * ...
 * @author Ohmnivore
 */
class Flag extends NSprite
{
	static public var TEMPL:NTemplate;
	static public var taken_flags:Map<Player, Flag>;
	
	public var holder:Holder;
	
	public var team:Int;
	public var taken:Bool;
	public var owner:Player;
	public var graphic:String;
	
	public function new(X:Float, Y:Float, TeamFlag:Int, Graphic:String) 
	{
		team = TeamFlag;
		graphic = Graphic;
		taken = false;
		
		super(X, Y, TEMPL, FlagSprite);
		
		holder = new Holder(X, Y + 26,
			team, this, Graphic);
		
		s.x += 4;
		s.immovable = true;
	}
	
	override public function announce(PlayerID:Int):Void
	{
		super.announce(PlayerID);
		
		setImage(PlayerID, graphic);
	}
	
	static public function makeFromXML(D:Fast):Flag
	{
		return new Flag(Std.parseInt(D.att.x), Std.parseInt(D.att.y),
			Std.parseInt(D.att.team), D.att.graphic);
	}
	
	static public function init():Void
	{
		TEMPL = new NTemplate("assets/images/flag_g.png", 0);
		NReg.registerTemplate(TEMPL);
		
		taken_flags = new Map<Player, Flag>();
		Holder.init();
	}
}

class FlagSprite extends NFlxSprite
{
	public var flag:Flag;
	
	public function new(X:Float, Y:Float, GraphicString:String, Parent:Flag)
	{
		super(X, Y, GraphicString, Parent);
		
		flag = Parent;
	}
	
	override public function update():Void 
	{
		FlxG.overlap(Reg.state.players, this, collideFlag);
		super.update();
		
		checkIfFall();
		followOwner();
	}
	
	public function checkIfFall():Void
	{
		if (flag.s.y >= Reg.state.collidemap.y + Reg.state.collidemap.height + FlxG.height / 2)
		{
			returnFlag(null, flag);
		}
	}
	
	public function collideFlag(P:Player, F:FlagSprite):Void
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
	
	public function followOwner():Void
	{
		if (flag.owner != null)
		{
			if (flag.owner.alive)
			{
				flag.s.x = flag.owner.x;
				flag.s.y = flag.owner.y;
			}
			
			else
			{
				Flag.taken_flags.remove(flag.owner);
				flag.owner = null;
			}
		}
	}
	
	static public function takeFlag(P:Player, F:Flag):Void
	{
		F.owner = P;
		
		F.taken = true;
		
		Flag.taken_flags.set(P, F);
		
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
			Flag.taken_flags.remove(F.owner);
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
}