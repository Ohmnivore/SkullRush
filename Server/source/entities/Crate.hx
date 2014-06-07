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
class Crate extends NSprite
{
	static public var TEMPL:NTemplate;
	
	public function new(X:Float, Y:Float) 
	{
		super(X, Y, TEMPL, CrateSprite);
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
	public function new(X:Float, Y:Float, GraphicString:String, Parent:NSprite)
	{
		super(X, Y, GraphicString, Parent);
	}
	
	override public function update():Void 
	{
		//FlxG.overlap(this, Reg.state.players, addHealth);
		super.update();
	}
}