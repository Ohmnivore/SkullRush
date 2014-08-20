package entities;

import entities.JumpPad.JumpPadSprite;
import entities.Platform.PlatformSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxAngle;
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

class JumpPad extends NSprite
{
	static public var TEMPL:NTemplate;
	
	public function new(X:Float, Y:Float, Angle:Int = 0) 
	{
		super(X, Y, TEMPL, JumpPadSprite);
		
		s.angle = Angle;
	}
	
	override public function announce(PlayerID:Int):Void
	{
		super.announce(PlayerID);
		
		setFields(0, ["health"], [0]);
		setFields(0, ["immovable"], [true]);
		setFields(0, ["angle"], [s.angle]);
	}
	
	static public function makeFromXML(D:Fast):JumpPad
	{
		return new JumpPad(Std.parseInt(D.att.x), Std.parseInt(D.att.y), Std.parseInt(D.att.angle));
	}
	
	static public function init():Void
	{
		TEMPL = new NTemplate("assets/images/jump_pad.png", 0, 0, 400);
		NReg.registerTemplate(TEMPL);
	}
}

class JumpPadSprite extends NFlxSprite
{
	public var pad:JumpPad;
	
	public function new(X:Float, Y:Float, GraphicString:String, Parent:JumpPad)
	{
		super(X, Y, GraphicString, Parent);
		
		pad = Parent;
	}
	
	override public function update():Void 
	{
		super.update();
		
		FlxG.collide(this, Reg.state.players, collisionHandler);
		FlxG.overlap(Reg.state.bullets, this, DefaultHooks.bulletCollide);
	}
	
	private function collisionHandler(Platf:JumpPadSprite, Pl:Player):Void
	{
		var impulse:FlxPoint = FlxAngle.rotatePoint(0, 550, 0, 0, angle);
		
		Pl.velocity.x += impulse.x;
		Pl.velocity.y += impulse.y;
	}
}