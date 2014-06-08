package entities;

import flixel.util.FlxTimer;
import haxe.xml.Fast;

/**
 * ...
 * @author Ohmnivore
 */

class CrateSpawn
{
	static public inline var INTERVAL:Int = 10;
	
	public var x:Int;
	public var y:Int;
	public var crate:Crate;
	
	public function new(X:Int, Y:Int) 
	{
		x = X;
		y = Y;
		
		crate = new Crate(x, y, this);
	}
	
	public function spawnCrate(T:FlxTimer = null):Void
	{
		crate.s.reset(x, y);
		crate.setFields(0, ["alive", "exists"], [true, true], false);
	}
	
	static public function makeFromXML(D:Fast):CrateSpawn
	{
		return new CrateSpawn(Std.parseInt(D.att.x), Std.parseInt(D.att.y));
	}
	
	static public function init():Void
	{
		Crate.init();
	}
}