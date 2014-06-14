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
	public var firstInit:Bool;
	
	public function new(type:String, player_:Player, FirstInit:Bool = false, bubbles:Bool=false, cancelable:Bool=false) 
	{
		super(type, bubbles, cancelable);
		player = player_;
		firstInit = FirstInit;
	}
	
	public override function clone():Event
	{
		return new InitEvent(type, player, bubbles, cancelable);
	}
}