package entities;

import entities.JumpPad.JumpPadSprite;
import entities.Platform.PlatformSprite;
import entities.Teleporter.TeleporterSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxAngle;
import flixel.util.FlxMath;
import flixel.util.FlxPath;
import flixel.util.FlxPoint;
import flixel.util.FlxTimer;
import networkobj.NEmitter;
import networkobj.NFlxEmitterAuto;
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

class Teleporter extends NSprite
{
	static public var TEMPL:NTemplate;
	static public var EMITTER:Int;
	static public var TELEPORTERS:Array<Teleporter>;
	
	public var emitterGraphic:String;
	public var ready:Bool = true;
	public var emitter:Int;
	public var working(get, set):Bool;
	private var _working:Bool;
	
	public function get_working():Bool
	{
		return _working;
	}
	
	public function set_working(Value:Bool):Bool
	{
		_working = Value;
		
		if (_working)
		{
			NEmitter.resumeEmitter(emitter, true, 0);
		}
		else
		{
			NEmitter.pauseEmitter(emitter, true, 0);
		}
		
		return _working;
	}
	
	public function new(X:Float, Y:Float,
		EmitterGraphic:String = "assets/images/explosionparticle_purple.png") 
	{
		emitterGraphic = EmitterGraphic;
		
		super(X, Y, TEMPL, TeleporterSprite);
		
		working = true;
		TELEPORTERS.push(this);
	}
	
	override public function announce(PlayerID:Int):Void
	{
		super.announce(PlayerID);
		
		setFields(0, ["health"], [0]);
		setFields(0, ["immovable"], [true]);
		
		if (!working)
		{
			NEmitter.pauseEmitter(emitter, true, PlayerID);
		}
	}
	
	static public function makeFromXML(D:Fast):Teleporter
	{
		var Graph:String = "assets/images/explosionparticle_purple.png";
		var Color:String = D.att.Color;
		
		switch(Color)
		{
			case "Green":
				Graph = "assets/images/explosionparticle_green.png";
			case "Blue":
				Graph = "assets/images/explosionparticle_blue.png";
			case "Yellow":
				Graph = "assets/images/explosionparticle_yellow.png";
			case "Red":
				Graph = "assets/images/explosionparticle_red.png";
		}
		
		return new Teleporter(Std.parseInt(D.att.x), Std.parseInt(D.att.y), Graph);
	}
	
	static public function init():Void
	{
		TELEPORTERS = [];
		
		TEMPL = new NTemplate("assets/images/teleporter_base.png", 0, 0, 400);
		NReg.registerTemplate(TEMPL);
		
		var t_emit:NFlxEmitterAuto = new NFlxEmitterAuto(Reg.state.emitters);
		t_emit.setRotation(0, 0);
		t_emit.setMotion(-90, 17, 0.9, 0, 25, 0);
		t_emit.width = 26;
		t_emit.frequency = 0.02;
		t_emit.life.set(1.0, 1.5);
		t_emit.setAlpha(1, 1, 0, 0);
		t_emit.setXSpeed(0, 0);
		t_emit.setYSpeed(-150, -150);
		t_emit.autoDestroy = false;
		
		EMITTER = NEmitter.registerEmitter(t_emit);
	}
}

class TeleporterSprite extends NFlxSprite
{
	public var teleport:Teleporter;
	
	public function new(X:Float, Y:Float, GraphicString:String, Parent:Teleporter)
	{
		super(X, Y, GraphicString, Parent);
		
		teleport = Parent;
		
		teleport.emitter = NEmitter.playEmitter(Teleporter.EMITTER, true, Std.int(x) + 3, Std.int(y) + 6,
			teleport.emitterGraphic, 0, 0, false, 0);
	}
	
	override public function update():Void 
	{
		super.update();
		
		FlxG.collide(this, Reg.state.players, collisionHandler);
		FlxG.overlap(Reg.state.bullets, this, DefaultHooks.bulletCollide);
	}
	
	private function collisionHandler(Platf:TeleporterSprite, Pl:Player):Void
	{
		if (teleport.ready && teleport.working)
		{
			for (t in Teleporter.TELEPORTERS)
			{
				if (t.ID != teleport.ID && t.emitterGraphic == teleport.emitterGraphic
					&& t.ready && t.working)
				{
					Pl.x = t.s.x + 4;
					Pl.y = t.s.y - 36;
					Pl.velocity.x = 0;
					Pl.velocity.y = 0;
					teleport.ready = false;
					t.ready = false;
					new FlxTimer(3, function(T:FlxTimer) { teleport.ready = true; } );
					new FlxTimer(3, function(T:FlxTimer) { t.ready = true; } );
					break;
				}
			}
		}
	}
}