package gevents;

import flash.events.Event;
import gevents.HurtInfo;

class HurtEvent extends Event
{
	public static inline var HURT_EVENT:String = "hurt_event";
	public var hurtinfo:HurtInfo;
	
	public function new(type:String, info:HurtInfo, bubbles:Bool=false, cancelable:Bool=false) 
	{
		super(type, bubbles, cancelable);
		hurtinfo = info;
	}
	
	public override function clone():Event
	{
		return new HurtEvent(type, hurtinfo, bubbles, cancelable);
	}
}