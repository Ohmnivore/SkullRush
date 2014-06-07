package gevents;
import flash.events.Event;

/**
 * ...
 * @author Ohmnivore
 */
class InitEvent extends Event
{
	public static inline var INIT_EVENT:String = "INIT_event";
	
	public var player:Player;
	
	public function new(type:String, player_:Player, bubbles:Bool=false, cancelable:Bool=false) 
	{
		super(type, bubbles, cancelable);
		player = player_;
	}
	
	public override function clone():Event
	{
		return new InitEvent(type, player, bubbles, cancelable);
	}
}