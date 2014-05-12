package entities;
import flixel.FlxObject;
import flixel.FlxSprite;
import gamemodes.CTF;
import haxe.xml.Fast;
import networkobj.NCounter;
import networkobj.NReg;
import networkobj.NSprite;
import networkobj.NTemplate;

/**
 * ...
 * @author Ohmnivore
 */
class Holder extends NSprite
{
	static public var captures:Array<Int>;
	
	public var data:Fast;
	
	public var flag:Flag;
	public var team:Int;
	
	public function new(Data:Fast, Fl:Flag) 
	{
		data = Data;
		flag = Fl;
		
		team = Std.parseInt(data.att.team);
		
		var g:String = Std.string(data.att.graphic);
		g = g.substr(0, g.length - 4);
		g += "h.png";
		var templ:NTemplate = new NTemplate(g, 0);
		NReg.registerTemplate(templ);
		
		super(Std.parseInt(data.att.x), Std.parseInt(data.att.y), templ);
		
		var gm:CTF = cast(Reg.gm, CTF);
		gm.holders.add(s);
		
		s.y += 33 - s.height;
		
		s.immovable = true;
	}
	
	static public function captureFlag(P:Player, F:Flag):Void
	{
		F.s.x = F.holder.s.x + 4;
		F.s.y = F.holder.s.y - (33 - F.holder.s.height);
		
		F.taken = false;
		if (F.owner != null)
		{
			Flag.taken_flags.remove(F.owner);
			F.owner = null;
		}
		
		captures[P.team]++;
		
		if (P != null)
		{
			var s:String = P.name + " captured the flag!";
			Reg.server.announce(s, [new FlxMarkup(0, P.name.length, false, P.header.color)]);
			
			P.score += 400;
			var gm:CTF = cast Reg.gm;
			gm.setPlayerScoreboard(P);
		}
	}
	
	static public function collideStand(P:Player, H:FlxSprite):Void
	{
		var h:Holder = cast(NReg.sprites.get(H.ID), Holder);
		
		if (P.team == h.team)
		{
			if (!h.flag.taken)
			{
				if (Flag.taken_flags.exists(P))
				{
					captureFlag(P, Flag.taken_flags.get(P));
				}
			}
		}
		
	}
	
	static public function init():Void
	{
		captures = [0, 0, 0, 0];
	}
}