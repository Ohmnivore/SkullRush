package entities;
import entities.Crate.CrateSprite;
import entities.HealthPack.Pack;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;
import haxe.xml.Fast;
import networkobj.NFlxSprite;
import networkobj.NReg;
import networkobj.NSprite;
import networkobj.NTemplate;
import flixel.FlxSprite;
import networkobj.NWeapon;

/**
 * ...
 * @author Ohmnivore
 */
class Crate extends NSprite
{
	static public var TEMPL:NTemplate;
	public var spawn:CrateSpawn;
	
	public function new(X:Float, Y:Float, S:CrateSpawn = null) 
	{
		super(X, Y, TEMPL, CrateSprite);
		
		spawn = S;
		if (spawn == null)
		{
			spawn = new CrateSpawn(Std.int(X), Std.int(Y));
		}
	}
	
	override public function announce(PlayerID:Int):Void
	{
		super.announce(PlayerID);
	}
	
	static public function makeFromXML(D:Fast):Crate
	{
		return new Crate(Std.parseInt(D.att.x), Std.parseInt(D.att.y));
	}
	
	static public function init():Void
	{
		TEMPL = new NTemplate("assets/images/crate.png", 100, 0, 0);
		NReg.registerTemplate(TEMPL);
	}
}

class CrateSprite extends NFlxSprite
{
	public var crate:Crate;
	
	public function new(X:Float, Y:Float, GraphicString:String, Parent:Crate)
	{
		super(X, Y, GraphicString, Parent);
		
		crate = Parent;
	}
	
	override public function update():Void 
	{
		FlxG.overlap(Reg.state.players, this, giveWeap);
		super.update();
	}
	
	public function giveWeap(P:Player, C:Dynamic):Void
	{
		var wep_arr:Array<Int> = [];
		for (w in NWeapon.weapons.keys())
		{
			wep_arr.push(w);
		}
		
		var found:Bool = false;
		var res:Int = P.current_weap - 1;
		while (!found)
		{
			var weapon:Int = FlxRandom.getObject(wep_arr);
			
			if (res != weapon)
			{
				res = weapon;
				found = true;
			}
		}
		
		for (k in P.grantedWeps.keys())
		{
			P.grantedWeps.set(k, false);
		}
		
		NWeapon.grantWeapon(P.ID, [res + 1]);
		P.setGun(res + 1, true);
		
		P.health += 50;
		if (P.health > 100)
			P.health = 100;
		
		crate.setFields(0, ["alive", "exists"], [false, false]);
		new FlxTimer(CrateSpawn.INTERVAL, crate.spawn.spawnCrate);
	}
}