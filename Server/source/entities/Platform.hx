package entities;

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

class Platform extends NSprite
{
	static public var TEMPL:NTemplate;
	
	public var speed:Int;
	public var nodes:Array<FlxPoint>;
	public var mode:Int;
	
	public function new(X:Float, Y:Float, Nodes:Array<FlxPoint>, Mode:Int, Speed:Int = 100) 
	{
		nodes = Nodes;
		mode = Mode;
		speed = Speed;
		
		super(X, Y, TEMPL, PlatformSprite);
	}
	
	override public function announce(PlayerID:Int):Void
	{
		super.announce(PlayerID);
		
		setFields(0, ["health"], [0]);
	}
	
	static public function makeFromXML(D:Fast):Platform
	{
		var speed:Int = Std.parseInt(D.att.Speed);
		var mode:String = D.att.Mode;
		var realmode:Int = FlxPath.LOOP_FORWARD;
		if (mode == "YOYO")
			realmode = FlxPath.YOYO;
		var nodes:Array<FlxPoint> = [];
		nodes.push(new FlxPoint(Std.parseInt(D.att.x), Std.parseInt(D.att.y)));
		
		for (n in D.elements)
		{
			if (n.name == "node")
			{
				nodes.push(new FlxPoint(Std.parseInt(n.att.x), Std.parseInt(n.att.y)));
			}
		}
		
		return new Platform(Std.parseInt(D.att.x), Std.parseInt(D.att.y), nodes, realmode, speed);
	}
	
	static public function init():Void
	{
		TEMPL = new NTemplate("assets/images/platform.png", 0, 0, 400);
		NReg.registerTemplate(TEMPL);
	}
}

class PlatformSprite extends NFlxSprite
{
	public var platform:Platform;
	
	public function new(X:Float, Y:Float, GraphicString:String, Parent:Platform)
	{
		super(X, Y, GraphicString, Parent);
		
		platform = Parent;
		
		var path:FlxPath = new FlxPath(this, platform.nodes, platform.speed, platform.mode);
	}
	
	override public function update():Void 
	{
		FlxG.collide(this, Reg.state.players, collisionHandler);
		FlxG.overlap(Reg.state.bullets, this, DefaultHooks.bulletCollide);
		
		super.update();
	}
	
	private function collisionHandler(Platf:PlatformSprite, Pl:Player):Void
	{
		Pl.velocity.y = Platf.velocity.y;
		Pl.velocity.x = Platf.velocity.x;
	}
}