package gevents;

import flash.events.Event;
import gevents.HurtInfo;

class DeathEvent extends Event
{
	public static inline var DEATH_EVENT:String = "death_event";
	public var deathinfo:HurtInfo;
	
	public function new(type:String, info:HurtInfo, bubbles:Bool=false, cancelable:Bool=false) 
	{
		super(type, bubbles, cancelable);
		deathinfo = info;
	}
	
	public override function clone():Event
	{
		return new DeathEvent(type, deathinfo, bubbles, cancelable);
	}
}