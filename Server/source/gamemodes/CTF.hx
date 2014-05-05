package gamemodes;

import enet.ENet;
import entities.Flag;
import entities.Holder;
import flixel.FlxG;
import flixel.group.FlxGroup;
import gevents.ConfigEvent;
import gevents.DeathEvent;
import gevents.HurtEvent;
import gevents.HurtInfo;
import gevents.JoinEvent;
import gevents.LeaveEvent;
import gevents.ReceiveEvent;
import networkobj.NCounter;
import networkobj.NReg;
import networkobj.NSprite;
import networkobj.NTemplate;
import networkobj.NTimer;

/**
 * ...
 * @author Ohmnivore
 */
class CTF extends BaseGamemode
{
	static public var init:Bool = false;
	public var flags:FlxGroup;
	public var holders:FlxGroup;
	public var greenCounter:NCounter;
	public var blueCounter:NCounter;
	public var timeLeft:NTimer;
	public var maxtime:Int;
	public var maxcaps:Int;
	
	public function new() 
	{
		super();
		name = "CTF";
		DefaultHooks.hookEvents(this);
		
		Assets.loadConfig();
		
		flags = new FlxGroup();
		holders = new FlxGroup();
		
		Flag.init();
		Holder.init();
		
		greenCounter = new NCounter("Green captures", 0xff00ff00, 5, 5, 0, true);
		greenCounter.setCount(Holder.captures[0]);
		blueCounter = new NCounter("Blue captures", 0xff0000ff, 5, 25, 0, true);
		blueCounter.setCount(Holder.captures[1]);
		
		timeLeft = new NTimer("Time left", 0xff000000, 250, 0, 0, true);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		DefaultHooks.update(elapsed);
		
		Flag.updateFlags();
		
		FlxG.overlap(Reg.state.players, flags, Flag.collideFlag);
		FlxG.overlap(Reg.state.players, holders, Holder.collideStand);
		
		for (f in flags.members)
		{
			var fl:Flag = cast NReg.sprites.get(f.ID);
			
			if (fl.s.y >= Reg.state.collidemap.y + Reg.state.collidemap.height + FlxG.height / 2)
			{
				Flag.returnFlag(null, fl);
			}
		}
		
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
		
		for (p in Flag.taken_flags.keys())
		{
			if (p.ID == e.deathinfo.victim)
			{
				p.solid = false;
				var f:Flag = Flag.taken_flags.get(p);
				
				Flag.taken_flags.remove(f.owner);
				f.owner = null;
			}
		}
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
		
		maxtime = Std.parseInt(Assets.config.get("ctf_maxtime"));
		maxcaps = Std.parseInt(Assets.config.get("ctf_maxcaps"));
		
		if (!init)
		{
			timeLeft.setTimer(maxtime * 60, NTimer.UNTICKING, 0xff000000);
			init = true;
		}
	}
	
	//override public function createScore():Void
	//{
		//DefaultHooks.createScore();
	//}
}