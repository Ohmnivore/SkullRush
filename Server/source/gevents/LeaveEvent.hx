package gevents;

import enet.ENetEvent;
import flash.events.Event;

class LeaveEvent extends Event
{
	public static inline var LEAVE_EVENT:String = "leave_event";
	public var leaveinfo:ENetEvent;
	
	public function new(type:String, info:ENetEvent, bubbles:Bool=false, cancelable:Bool=false) 
	{
		super(type, bubbles, cancelable);
		leaveinfo = info;
	}
	
	public override function clone():Event
	{
		return new LeaveEvent(type, leaveinfo, bubbles, cancelable);
	}
}