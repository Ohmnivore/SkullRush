package gevents;
import flash.events.Event;

/**
 * ...
 * @author Ohmnivore
 */
class GenEvent extends Event
{
	public static inline var UPDATE_EVENT:String = "gen_update_event";
	public static inline var SHUTDOWN:String = "gen_shutdown_event";
	public static inline var MAKE_WEAPONS:String = "gen_make_weapons_event";
	
	public var info:Dynamic;
	
	public function new(type:String, info_:Dynamic = null, bubbles:Bool=false, cancelable:Bool=false) 
	{
		super(type, bubbles, cancelable);
		info = info_;
	}
	
	public override function clone():Event
	{
		return new GenEvent(type, info, bubbles, cancelable);
	}
}