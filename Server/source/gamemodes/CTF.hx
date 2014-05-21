package gamemodes;

import enet.ENet;
import entities.Flag;
import entities.Holder;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.util.FlxPoint;
import gevents.ConfigEvent;
import gevents.DeathEvent;
import gevents.HurtEvent;
import gevents.HurtInfo;
import gevents.JoinEvent;
import gevents.LeaveEvent;
import gevents.ReceiveEvent;
import networkobj.NCounter;
import networkobj.NReg;
import networkobj.NScoreboard;
import networkobj.NSprite;
import networkobj.NTemplate;
import networkobj.NTimer;
import networkobj.NWeapon;

/**
 * ...
 * @author Ohmnivore
 */
class CTF extends BaseGamemode
{
	public var flags:FlxGroup;
	public var holders:FlxGroup;
	public var greenCounter:NCounter;
	public var blueCounter:NCounter;
	public var timeLeft:NTimer;
	public var maxtime:Int;
	public var maxcaps:Int;
	public var score:NScoreboard;
	public var captures:Map<Int, Int>;
	
	public function new() 
	{
		super();
		
		teams.push(new Team("Blue", 0xff0086BF, "assets/images/playerblue.png"));
		teams.push(new Team("Yellow", 0xffE0DD00, "assets/images/playeryellow.png"));
		
		name = "CTF";
		DefaultHooks.hookEvents(this);
		
		Assets.loadConfig();
		
		flags = new FlxGroup();
		holders = new FlxGroup();
		
		greenCounter = new NCounter("Blue captures", 0xff0086BF, 5, 5, 0, true);
		greenCounter.setCount(0);
		blueCounter = new NCounter("Yellow captures", 0xffE0DD00, 5, 25, 0, true);
		blueCounter.setCount(0);
		
		timeLeft = new NTimer("Time left", 0xffffffff, 5, 45, 0, true);
		timeLeft.setTimer(maxtime * 60, NTimer.UNTICKING);
		
		score = new NScoreboard("Scores", ["Score", "Kills", "Deaths", "Captures"],
											["0", "0", "0", "0"], 0xffffffff);
		Reg.state.hud.add(score.group);
		captures = new Map<Int, Int>();
	}
	
	override public function onSpawn(P:Player):Void 
	{
		DefaultHooks.onSpawn(P);
	}
	
	override public function makeWeapons():Void 
	{
		super.makeWeapons();
		
		DefaultHooks.makeWeapons();
	}
	
	public function setPlayerScoreboard(P:Player):Void
	{
		score.setPlayer(P, [Std.string(P.score), Std.string(P.kills),
						Std.string(P.deaths), Std.string(captures.get(P.ID))]);
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
		
		if (Holder.captures[0] != greenCounter.count)
		{
			greenCounter.setCount(Holder.captures[0]);
		}
		
		if (Holder.captures[1] != blueCounter.count)
		{
			blueCounter.setCount(Holder.captures[1]);
		}
	}
	
	override public function onHurt(e:HurtEvent):Void
	{
		DefaultHooks.handleDamage(e.hurtinfo, true);
		
		if (e.hurtinfo.attacker > 0)
		{
			var p:Player = Reg.server.playermap.get(e.hurtinfo.attacker);
			p.score += e.hurtinfo.dmg;
			setPlayerScoreboard(p);
		}
	}
	
	override public function onDeath(e:DeathEvent):Void
	{
		DefaultHooks.handleDeath(e.deathinfo);
		
		var loser:Player = Reg.server.playermap.get(e.deathinfo.victim);
		loser.deaths++;
		setPlayerScoreboard(loser);
		
		if (e.deathinfo.attacker > 0)
		{
			var winner:Player = Reg.server.playermap.get(e.deathinfo.attacker);
			winner.kills++;
			setPlayerScoreboard(winner);
		}
		
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
	
	override public function initPlayer(P:Player):Void 
	{
		super.initPlayer(P);
		
		DefaultHooks.initPlayer(P);
		
		score.addPlayer(Reg.server.playermap.get(P.ID));
		captures.set(P.ID, 0);
	}
	
	override public function setTeam(P:Player, T:Team):Void 
	{
		super.setTeam(P, T);
		
		DefaultHooks.setTeam(P, T);
	}
	
	override public function onLeave(e:LeaveEvent):Void
	{
		score.removePlayer(Reg.server.playermap.get(e.leaveinfo.ID));
		captures.remove(e.leaveinfo.ID);
		
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
	}
}