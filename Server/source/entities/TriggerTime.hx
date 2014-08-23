package entities;

import flixel.util.FlxTimer;
import haxe.xml.Fast;

/**
 * ...
 * @author ...
 */
class TriggerTime extends Trigger
{
	public var startInterval:Int;
	public var interval:Int;
	public var doToggle:Bool;
	
	public function new(Parent:Dynamic, StartInterval:Int, Interval:Int, DoToggle:Bool) 
	{
		super(Parent, 0);
		
		startInterval = StartInterval;
		interval = Interval;
		doToggle = DoToggle;
		
		new FlxTimer(startInterval, go);
	}
	
	public function go(T:FlxTimer = null):Void
	{
		if (doToggle)
		{
			toggle();
		}
		else
		{
			activate();
		}
		
		new FlxTimer(interval, go);
	}
	
	static public function makeFromXML(D:Fast):TriggerTime
	{
		var doToggle:Bool = false;
		if (D.att.doToggle == "True")
			doToggle = true;
		
		return new TriggerTime(D.att.parent,
			Std.parseInt(D.att.startInterval),
			Std.parseInt(D.att.interval),
			doToggle);
	}
	
	static public function init():Void
	{
		
	}
}