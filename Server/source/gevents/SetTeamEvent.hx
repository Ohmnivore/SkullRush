package gevents;
import flash.events.Event;

/**
 * ...
 * @author Ohmnivore
 */
class SetTeamEvent extends Event
{
	public static inline var SETTEAM_EVENT:String = "SETTEAM_event";
	
	public var player:Player;
	public var team:Team;
	
	public function new(type:String, P:Player, T:Team, bubbles:Bool=false, cancelable:Bool=false) 
	{
		super(type, bubbles, cancelable);
		player = P;
		team = T;
	}
	
	public override function clone():Event
	{
		return new SetTeamEvent(type, player, team, bubbles, cancelable);
	}
}