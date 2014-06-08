package gamemodes;

import enet.ENet;
import entities.Flag;
import entities.HealthPack;
import entities.Holder;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.util.FlxPoint;
import flixel.util.FlxTimer;
import gevents.ConfigEvent;
import gevents.DeathEvent;
import gevents.GenEvent;
import gevents.HurtEvent;
import gevents.HurtInfo;
import gevents.InitEvent;
import gevents.JoinEvent;
import gevents.LeaveEvent;
import gevents.ReceiveEvent;
import gevents.SetTeamEvent;
import networkobj.NCounter;
import networkobj.NLabel;
import networkobj.NReg;
import networkobj.NScoreboard;
import networkobj.NSprite;
import networkobj.NTemplate;
import networkobj.NTimer;
import networkobj.NWeapon;
import entities.Holder;

/**
 * ...
 * @author Ohmnivore
 */
class CTF extends BaseGamemode
{
	public var greenCounter:NCounter;
	public var blueCounter:NCounter;
	public var timeLeft:NTimer;
	public var maxtime:Int;
	public var maxcaps:Int;
	public var score:NScoreboard;
	public var captures:Map<Int, Int>;
	
	public var finished:Bool = false;
	
	public function new() 
	{
		super();
		
		teams.push(new Team("Blue", 0xff0086BF, "assets/images/playerblue.png"));
		teams.push(new Team("Yellow", 0xffE0DD00, "assets/images/playeryellow.png"));
		
		name = "CTF";
		
		Assets.loadConfig();
		
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
	
	override public function hookEvents():Void 
	{
		super.hookEvents();
		DefaultHooks.hookEvents(this);
	}
	
	override public function onSpawn(E:GenEvent):Void 
	{
		DefaultHooks.onSpawn(E.info);
	}
	
	override public function makeWeapons(E:GenEvent):Void 
	{
		super.makeWeapons(E);
		
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
		
		if (Holder.captures[0] != greenCounter.count && !finished)
		{
			greenCounter.setCount(Holder.captures[0]);
			checkCaps(0);
		}
		
		if (Holder.captures[1] != blueCounter.count && !finished)
		{
			blueCounter.setCount(Holder.captures[1]);
			checkCaps(1);
		}
		
		if (timeLeft.count == 0 && !finished)
		{
			if (Holder.captures[0] > Holder.captures[1])
			{
				endGame(0);
			}
			if (Holder.captures[1] > Holder.captures[0])
			{
				endGame(1);
			}
			if (Holder.captures[1] == Holder.captures[0])
			{
				endGame(-1);
			}
		}
	}
	
	public function checkCaps(FlagTeam:Int):Void
	{
		var caps:Int = Holder.captures[FlagTeam];
		
		if (caps >= maxcaps)
		{
			endGame(FlagTeam);
		}
	}
	
	public function endGame(WinnerTeam:Int):Void
	{
		var winmsg:NLabel = new NLabel(200, 5, 0xffffffff, 0, true);
		
		if (WinnerTeam >= 0)
		{
			var team:Team = teams[WinnerTeam];
			winmsg.setLabel(team.name + " team wins!", team.color);
		}
		else
		{
			winmsg.setLabel("Draw match!");
		}
		
		finished = true;
		new FlxTimer(10, changeMap);
	}
	
	public function changeMap(T:FlxTimer):Void
	{
		Admin.nextMap();
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
	
	override public function initPlayer(E:InitEvent):Void 
	{
		var P:Player = E.player;
		super.initPlayer(E);
		
		DefaultHooks.initPlayer(P);
		
		score.addPlayer(Reg.server.playermap.get(P.ID));
		captures.set(P.ID, 0);
	}
	
	override public function setTeam(E:SetTeamEvent):Void 
	{
		super.setTeam(E);
		
		DefaultHooks.setTeam(E.player, E.team);
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
		spawn_time = Std.parseInt(Assets.config.get("ctf_spawntime"));
	}
}