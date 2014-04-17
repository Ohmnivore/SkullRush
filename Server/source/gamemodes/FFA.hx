package gamemodes;

import gevents.ConfigEvent;
import gevents.DeathEvent;
import gevents.HurtEvent;
import gevents.HurtInfo;
import gevents.JoinEvent;
import gevents.LeaveEvent;
import gevents.ReceiveEvent;

/**
 * ...
 * @author Ohmnivore
 */
class FFA extends BaseGamemode
{

	public var maxkills:Int = 25;
	
	public function new() 
	{
		super();
		DefaultHooks.hookEvents(this);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		DefaultHooks.update(elapsed);
		
		//for each (var p:Player in Registry.playstate.players)
		//{
			//if (p.kills >= 25)
			//{
			//var announce:String = p.name.concat(" won the game!");
			//var pmarkup:Markup = new Markup(0, p.name.length, 11, p.teamcolor);
			//PlayState.announcer.add(new MarkupText(0, 0, 500, announce, true, true, [pmarkup]));
			//
			//new delayedFunctionCall(Registry.nextmap, 3000);
			//}
		//}
	}
	
	override public function onHurt(e:HurtEvent):Void
	{
		DefaultHooks.handleDamage(e.hurtinfo);
	}
	
	override public function onDeath(e:DeathEvent):Void
	{
		DefaultHooks.handleDeath(e.deathinfo);
	}
	
	override public function onJoin(e:JoinEvent):Void
	{
		DefaultHooks.onPeerConnect(e);
	}
	
	override public function onLeave(e:LeaveEvent):Void
	{
		DefaultHooks.onPeerDisconnect(e);
	}
	
	override public function onReceive(e:ReceiveEvent):Void
	{
		super.onReceive(e);
	}
	
	override public function onConfig(e:ConfigEvent):Void 
	{
		super.onConfig(e);
		
		maxkills = Std.parseInt(Assets.config.get("maxkills"));
	}
	
	//override public function createScore():Void
	//{
		//DefaultHooks.createScore();
	//}
}