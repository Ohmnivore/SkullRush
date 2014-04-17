package gevents;

import enet.ENetEvent;
import flash.events.Event;

class ReceiveEvent extends Event
{
	public static inline var RECEIVE_EVENT:String = "receive_event";
	public var joininfo:ENetEvent;
	public var msg_id:Int;
	
	public function new(type:String, MsgID:Int, info:ENetEvent, bubbles:Bool=false, cancelable:Bool=false) 
	{
		super(type, bubbles, cancelable);
		joininfo = info;
		msg_id = MsgID;
	}
	
	public override function clone():Event
	{
		return new ReceiveEvent(type, msg_id, joininfo, bubbles, cancelable);
	}
}