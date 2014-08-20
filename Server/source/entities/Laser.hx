package entities;

import entities.JumpPad.JumpPadSprite;
import entities.Platform.PlatformSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxMath;
import flixel.util.FlxPath;
import flixel.util.FlxPoint;
import networkobj.NEmitter;
import networkobj.NSprite;
import networkobj.NTemplate;
import networkobj.NFlxSprite;
import networkobj.NReg;
import ext.FlxEmitterAuto;
import flixel.tile.FlxTilemap;
import gevents.HurtInfo;
import gevents.HurtEvent;
import gamemodes.BaseGamemode;
import haxe.xml.Fast;
import gamemodes.DefaultHooks;

/**
 * ...
 * @author ...
 */

class Laser extends NSprite
{
	static public var TEMPL:NTemplate;
	
	public function new(X:Float, Y:Float) 
	{
		super(X, Y, TEMPL, LaserSprite);
	}
	
	override public function announce(PlayerID:Int):Void
	{
		super.announce(PlayerID);
		
		setFields(0, ["health"], [0]);
		setFields(0, ["immovable"], [true]);
	}
	
	static public function makeFromXML(D:Fast):Laser
	{
		return new Laser(Std.parseInt(D.att.x), Std.parseInt(D.att.y));
	}
	
	static public function init():Void
	{
		TEMPL = new NTemplate("assets/images/laser_base.png", 0, 0, 400);
		NReg.registerTemplate(TEMPL);
	}
}

class LaserSprite extends NFlxSprite
{
	public var laser:Laser;
	
	public function new(X:Float, Y:Float, GraphicString:String, Parent:Laser)
	{
		super(X, Y, GraphicString, Parent);
		
		laser = Parent;
	}
	
	override public function update():Void 
	{
		//FlxG.collide(this, Reg.state.players, collisionHandler);
		//FlxG.overlap(Reg.state.bullets, this, DefaultHooks.bulletCollide);
		
		super.update();
	}
	
	private function collisionHandler(Platf:JumpPadSprite, Pl:Player):Void
	{
		Pl.velocity.y -= 550;
	}
}