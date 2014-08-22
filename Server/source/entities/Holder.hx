package entities;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxTimer;
import gamemodes.CTF;
import haxe.xml.Fast;
import networkobj.NArrow;
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
class Holder extends NSprite
{
	static public var TEMPL:NTemplate;
	static public var captures:Array<Int>;
	
	public var flag:Flag;
	public var team:Int;
	public var graphic:String;
	
	public function new(X:Float, Y:Float, TeamFlag:Int, Fl:Flag, Graphic:String) 
	{
		team = TeamFlag;
		flag = Fl;
		graphic = Graphic;
		
		var g:String = graphic;
		g = g.substr(0, g.length - 4);
		g += "h.png";
		graphic = g;
		
		super(X, Y, TEMPL, Stand);
	}
	
	override public function announce(PlayerID:Int):Void
	{
		super.announce(PlayerID);
		
		setImage(PlayerID, graphic);
	}
	
	static public function makeFromXML(D:Fast):Dynamic
	{
		return null;
	}
	
	static public function init():Void
	{
		TEMPL = new NTemplate("assets/images/flag_gh.png", 0);
		NReg.registerTemplate(TEMPL);
		
		captures = [0, 0, 0, 0];
	}
}

class Stand extends NFlxSprite
{
	public var holder:Holder;
	
	public function new(X:Float, Y:Float, GraphicString:String, Parent:Holder)
	{
		super(X, Y, GraphicString, Parent);
		immovable = true;
		holder = Parent;
	}
	
	override public function update():Void 
	{
		FlxG.overlap(Reg.state.players, this, collideStand);
		super.update();
	}
	
	public function collideStand(P:Player, H:Stand):Void
	{
		if (P.team == H.holder.team)
		{
			if (!H.holder.flag.taken)
			{
				if (Flag.taken_flags.exists(P))
				{
					captureFlag(P, Flag.taken_flags.get(P));
				}
			}
		}
		
	}
	
	public function captureFlag(P:Player, F:Flag):Void
	{
		F.s.x = F.holder.s.x + 4;
		F.s.y = F.holder.s.y - (33 - F.holder.s.height);
		
		F.taken = false;
		if (F.owner != null)
		{
			Flag.taken_flags.remove(F.owner);
			F.owner = null;
		}
		
		Holder.captures[P.team]++;
		
		if (P != null)
		{
			var s:String = P.name + " captured the flag!";
			Reg.server.announce(s, [new FlxMarkup(0, P.name.length, false, P.header.color)]);
			
			P.score += 400;
			var gm:CTF = cast Reg.gm;
			var cur:Int = gm.captures.get(P.ID);
			gm.captures.set(P.ID, cur + 1);
			gm.setPlayerScoreboard(P);
		}
		
		NArrow.toggle(F.ID, F.taken);
	}
}