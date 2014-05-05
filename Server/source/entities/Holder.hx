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
	static public var T_HOLDER_G:NTemplate;
	static public var T_HOLDER_B:NTemplate;
	static public var T_HOLDER_Y:NTemplate;
	static public var T_HOLDER_R:NTemplate;
	
	static public var captures:Array<Int>;
	
	static var did_init:Bool = false;
	public var data:Fast;
	
	public var flag:Flag;
	public var team:Int;
	
	public function new(Data:Fast, Fl:Flag) 
	{
		if (!did_init)
		{
			init();
			did_init = true;
		}
		
		data = Data;
		flag = Fl;
		
		team = Std.parseInt(data.att.team);
		
		switch(team)
		{
			case 0:
				super(Std.parseInt(data.att.x), Std.parseInt(data.att.y), T_HOLDER_G);
			case 1:
				super(Std.parseInt(data.att.x), Std.parseInt(data.att.y), T_HOLDER_B);
			case 2:
				super(Std.parseInt(data.att.x), Std.parseInt(data.att.y), T_HOLDER_Y);
			case 3:
				super(Std.parseInt(data.att.x), Std.parseInt(data.att.y), T_HOLDER_R);
		}
		
		var gm:CTF = cast(Reg.gm, CTF);
		gm.holders.add(s);
		
		s.immovable = true;
	}
	
	static public function captureFlag(P:Player, F:Flag):Void
	{
		F.s.x = F.holder.s.x;
		F.s.y = F.holder.s.y;
		
		F.taken = false;
		if (F.owner != null)
		{
			Flag.taken_flags.remove(F.owner);
			F.owner = null;
		}
		
		captures[F.team]++;
		
		if (P != null)
		{
			var s:String = P.name + " captured the flag!";
			Reg.server.announce(s, [new FlxMarkup(0, P.name.length, false, P.header.color)]);
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
		
		T_HOLDER_G = new NTemplate("assets/images/flag_stand_g.png");
		T_HOLDER_B = new NTemplate("assets/images/flag_stand_b.png");
		T_HOLDER_Y = new NTemplate("assets/images/flag_stand_y.png");
		T_HOLDER_R = new NTemplate("assets/images/flag_stand_r.png");
		T_HOLDER_G.gravity_force = 0;
		T_HOLDER_B.gravity_force = 0;
		T_HOLDER_Y.gravity_force = 0;
		T_HOLDER_R.gravity_force = 0;
		NReg.registerTemplate(T_HOLDER_G);
		NReg.registerTemplate(T_HOLDER_B);
		NReg.registerTemplate(T_HOLDER_Y);
		NReg.registerTemplate(T_HOLDER_R);
	}
}