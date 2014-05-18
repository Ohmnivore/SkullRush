package entities;
import entities.HealthPack.Pack;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxTimer;
import haxe.xml.Fast;
import networkobj.NFlxSprite;
import networkobj.NReg;
import networkobj.NSprite;
import networkobj.NTemplate;
import flixel.FlxSprite;

/**
 * ...
 * @author Ohmnivore
 */
class HealthPack extends NSprite
{
	static public var TEMPL:NTemplate;
	static public var reappearTime:Float = 30;
	static public var healthAdded:Int = 50;
	
	public function new(X:Float, Y:Float) 
	{
		super(X, Y, TEMPL, Pack);
	}
	
	static public function makeFromXML(D:Fast):HealthPack
	{
		return new HealthPack(Std.parseFloat(D.att.x), Std.parseFloat(D.att.y));
	}
	
	static public function init():Void
	{
		TEMPL = new NTemplate("assets/images/powerup_health.png", 100, 0, 0);
		NReg.registerTemplate(TEMPL);
	}
}

class Pack extends NFlxSprite
{
	public function new(X:Float, Y:Float, GraphicString:String, Parent:NSprite)
	{
		super(X, Y, GraphicString, Parent);
		alive = true;
	}
	
	override public function update():Void 
	{
		FlxG.overlap(this, Reg.state.players, addHealth);
		super.update();
	}
	
	public function addHealth(H:Pack, P:Player):Void
	{
		if (P.health < 100 && H.alive)
		{
			P.health += HealthPack.healthAdded;
			if (P.health > 100)
			{
				P.health = 100;
			}
			
			new FlxTimer(HealthPack.reappearTime, reAppear);
			
			parent.setFields(0, ["visible", "active", "alive"], [false, false, false]);
		}
	}
	
	public function reAppear(T:FlxTimer):Void
	{
		parent.setFields(0, ["visible", "active", "alive"], [true, true, true]);
	}
}