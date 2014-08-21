package entities;

import entities.JumpPad.JumpPadSprite;
import entities.Platform.PlatformSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxAngle;
import flixel.util.FlxMath;
import flixel.util.FlxPath;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil;
import networkobj.NEmitter;
import networkobj.NFlxEmitterAuto;
import networkobj.NFlxLine;
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
	static public var LASER:String = "laser";
	static public var BURN:Int;
	
	public var angle:Int;
	public var working(get, set):Bool;
	private var _working:Bool;
	
	public function get_working():Bool
	{
		return _working;
	}
	
	public function set_working(Value:Bool):Bool
	{
		_working = Value;
		
		var sprite:LaserSprite = cast s;
		if (_working)
		{
			//if (!sprite.emitter.on)
			NEmitter.resumeEmitter(sprite.emitter, true, 0);
			sprite.beam.setVisible(true, 0);
		}
		else
		{
			//if (sprite.emitter.on)
			NEmitter.pauseEmitter(sprite.emitter, true, 0);
			sprite.beam.setVisible(false, 0);
		}
		
		return _working;
	}
	
	public function new(X:Float, Y:Float, Angle:Int = 0) 
	{
		angle = Angle;
		super(X, Y, TEMPL, LaserSprite);
		
		working = true;
	}
	
	override public function announce(PlayerID:Int):Void
	{
		super.announce(PlayerID);
		
		setFields(0, ["health"], [0]);
		setFields(0, ["immovable"], [true]);
		setFields(0, ["angle"], [s.angle]);
		
		var sprite:LaserSprite = cast s;
		sprite.beam.announce(PlayerID);
		sprite.beam.setVisible(sprite.beam.visible, PlayerID, false);
	}
	
	static public function makeFromXML(D:Fast):Laser
	{
		return new Laser(Std.parseInt(D.att.x), Std.parseInt(D.att.y), Std.parseInt(D.att.angle));
	}
	
	static public function init():Void
	{
		TEMPL = new NTemplate("assets/images/laser_base.png", 0, 0, 400);
		NReg.registerTemplate(TEMPL);
		
		var t_emit:NFlxEmitterAuto = new NFlxEmitterAuto(Reg.state.emitters);
		t_emit.setRotation(0, 0);
		t_emit.setMotion(0, 17, 0.9, 360, 25, 0);
		t_emit.setAlpha(1, 1, 0, 0);
		t_emit.setColor(0xffE80000, 0xffF54242);
		t_emit.setXSpeed(150, 150);
		t_emit.setYSpeed(150, 150);
		t_emit.bounce = 0.5;
		t_emit.autoDestroy = false;
		
		BURN = NEmitter.registerEmitter(t_emit);
	}
}

class LaserSprite extends NFlxSprite
{
	public var laser:Laser;
	public var stop:FlxPoint;
	public var emitter:Int;
	public var beam:NFlxLine;
	
	public function new(X:Float, Y:Float, GraphicString:String, Parent:Laser)
	{
		super(X, Y, GraphicString, Parent);
		
		laser = Parent;
		angle = laser.angle;
		
		var endPoint:FlxPoint = FlxAngle.rotatePoint(400, 0, 0, 0, angle);
		endPoint.x += x + width / 2;
		endPoint.y += y + height / 2;
		
		var finalPoint:FlxPoint = new FlxPoint();
		finalPoint.copyFrom(endPoint);
		
		for (m in Reg.state.maps.members)
		{
			var map:FlxTilemap = cast m;
			
			var res:FlxPoint = new FlxPoint();
			
			if (!map.ray(getMidpoint(), finalPoint, res))
			{
				finalPoint.copyFrom(res);
			}
		}
		
		stop = new FlxPoint();
		stop.copyFrom(finalPoint);
		beam = new NFlxLine(x + width / 2, y + height / 2,
			Std.int(FlxMath.distanceToPoint(this, finalPoint)), angle);
		Reg.state.background.add(beam);
		emitter = NEmitter.playEmitter(Laser.BURN, true, Std.int(finalPoint.x), Std.int(finalPoint.y),
			"assets/images/explosionparticle.png", 0, 0, false, 0);
	}
	
	override public function update():Void 
	{
		super.update();
		
		FlxG.collide(this, Reg.state.players);
		FlxG.overlap(Reg.state.bullets, this, DefaultHooks.bulletCollide);
		
		for (p in Reg.server.playermap.iterator())
		{
			if (rayBoxIntersect2(getMidpoint(), stop, new FlxPoint(p.x, p.y),
				new FlxPoint(p.x + width, p.y + height)).length > 0)
			{
				var info:HurtInfo = new HurtInfo();
				info.attacker = 0;
				info.victim = p.ID;
				info.dmg = 15;
				info.dmgsource = stop;
				info.weapon = null;
				info.type = Laser.LASER;
				info.message = " promptly combusted.";
				
				Reg.gm.dispatchEvent(new HurtEvent(HurtEvent.HURT_EVENT, info));
			}
		}
	}
	
	private static function rayBoxIntersect2(r1:FlxPoint, r2:FlxPoint,
		box1:FlxPoint, box2:FlxPoint):Array<FlxPoint>
	{
		var arr:Array<FlxPoint> = [];
		var intersection:FlxPoint;
		
		intersection = rayRayIntersect(r1, r2, box1, new FlxPoint(box2.x, box1.y));
		if (intersection != null) arr.push(intersection);
		
		intersection = rayRayIntersect(r1, r2, box1, new FlxPoint(box1.x, box2.y));
		if (intersection != null) arr.push(intersection);
		
		intersection = rayRayIntersect(r1, r2, box2, new FlxPoint(box2.x, box1.y));
		if (intersection != null) arr.push(intersection);
		
		intersection = rayRayIntersect(r1, r2, box2, new FlxPoint(box1.x, box2.y));
		if (intersection != null) arr.push(intersection);
		
		return arr;
	}
	
	private static function rayRayIntersect(p1:FlxPoint, p2:FlxPoint, p3:FlxPoint, p4:FlxPoint):FlxPoint
	{
		var denom:Float = ((p4.y - p3.y)*(p2.x - p1.x)) - ((p4.x - p3.x)*(p2.y - p1.y));
		var nume_a:Float = ((p4.x - p3.x)*(p1.y - p3.y)) - ((p4.y - p3.y)*(p1.x - p3.x));
		var nume_b:Float = ((p2.x - p1.x)*(p1.y - p3.y)) - ((p2.y - p1.y)*(p1.x - p3.x));
		
		if(denom == 0.0) {
			if(nume_a == 0.0 && nume_b == 0.0) {
				return null; //COINCIDENT;
			}
			return null; //PARALLEL;
		}
		
		var ua:Float = nume_a / denom;
		var ub:Float = nume_b / denom;
		
		if(ua >= 0.0 && ua <= 1.0 && ub >= 0.0 && ub <= 1.0) {	//INTERSECTING
			// Get the intersection point.
			return new FlxPoint(p1.x + ua*(p2.x - p1.x), p1.y + ua*(p2.y - p1.y));
		}
		
		return null;
	}
}