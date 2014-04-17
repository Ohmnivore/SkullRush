package gevents;

import enet.ENetEvent;
import flash.events.Event;

class JoinEvent extends Event
{
	public static inline var JOIN_EVENT:String = "join_event";
	public var joininfo:ENetEvent;
	
	public function new(type:String, info:ENetEvent, bubbles:Bool=false, cancelable:Bool=false) 
	{
		super(type, bubbles, cancelable);
		joininfo = info;
	}
	
	public override function clone():Event
	{
		return new JoinEvent(type, joininfo, bubbles, cancelable);
	}
}