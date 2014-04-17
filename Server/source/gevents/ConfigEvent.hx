package gevents;

import enet.ENetEvent;
import flash.events.Event;

class ConfigEvent extends Event
{
	public static inline var CONFIG_EVENT:String = "config_event";
	
	public function new(type:String, bubbles:Bool=false, cancelable:Bool=false) 
	{
		super(type, bubbles, cancelable);
	}
	
	public override function clone():Event
	{
		return new ConfigEvent(type, bubbles, cancelable);
	}
}