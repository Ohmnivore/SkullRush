package gevents;
import flash.events.Event;

/**
 * ...
 * @author Ohmnivore
 */
class RespawnEvent extends Event
{
	public static inline var RESPAWN_EVENT:String = "respawn_event";
	
	public var player:Player;
	
	public function new(type:String, player_:Player, bubbles:Bool=false, cancelable:Bool=false) 
	{
		super(type, bubbles, cancelable);
		player = player_;
	}
	
	public override function clone():Event
	{
		return new RespawnEvent(type, player, bubbles, cancelable);
	}
}