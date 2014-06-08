package gamemodes;

import enet.ENet;
import entities.CapturePoint;
import entities.HealthPack;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxEmitterExt;
import flixel.FlxG;
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
import networkobj.NEmitter;
import networkobj.NLabel;
import networkobj.NReg;
import networkobj.NScoreboard;
import networkobj.NSprite;
import networkobj.NTemplate;
import networkobj.NTimer;
import networkobj.NWeapon;
import weapons.Launcher;
import flixel.FlxSprite;

/**
 * ...
 * @author Ohmnivore
 */
class KOTH extends BaseGamemode
{
	//public var testt:NTemplate;
	//public var tests:NSprite;
	//public var score:NScoreboard;
	
	public var time_1:NTimer;
	public var time_2:NTimer;
	
	public var captime:Int = 3;
	
	public var finished:Bool = false;
	
	public function new() 
	{
		super();
		Assets.loadConfig();
		
		teams.push(new Team("Green", 0xff13BF00, "assets/images/playergreen.png"));
		teams.push(new Team("Blue", 0xff0086BF, "assets/images/playerblue.png"));
		
		time_1 = new NTimer("Time left", teams[0].color, 5, 5, 0, true);
		time_1.setTimer(captime * 60, NTimer.STOPPED);
		
		time_2 = new NTimer("Time left", teams[1].color, 5, 25, 0, true);
		time_2.setTimer(captime * 60, NTimer.STOPPED);
		
		name = "KOTH";
		
		//score = new NScoreboard("Scores", ["Score", "Kills", "Deaths"], ["0", "0", "0"], 0xffffffff);
		//Reg.state.hud.add(score.group);
	}
	
	public function setFlagTeam(F:CapturePoint, T:Int):Void
	{
		if (T == 0)
		{
			time_1.setTimer(Std.int(time_1.count), NTimer.UNTICKING);
			time_2.setTimer(Std.int(time_2.count), NTimer.STOPPED);
		}
		if (T == 1)
		{
			time_2.setTimer(Std.int(time_2.count), NTimer.UNTICKING);
			time_1.setTimer(Std.int(time_1.count), NTimer.STOPPED);
		}
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
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		DefaultHooks.update(elapsed);
		
		if (time_1.count == 0 && !finished)
		{
			grantWin(0);
		}
		if (time_2.count == 0)
		{
			grantWin(1);
		}
	}
	
	public function grantWin(WinnerTeam:Int):Void
	{
		var winmsg:NLabel = new NLabel(200, 5, 0xffffffff, 0, true);
		
		var team:Team = teams[WinnerTeam];
		winmsg.setLabel(team.name + " team wins!", team.color);
		
		finished = true;
		new FlxTimer(10, changeMap);
	}
	
	public function changeMap(T:FlxTimer):Void
	{
		Admin.nextMap();
	}
	
	//public function setPlayerScoreboard(P:Player):Void
	//{
		//score.setPlayer(P, [Std.string(P.score), Std.string(P.kills), Std.string(P.deaths)]);
	//}
	
	override public function onHurt(e:HurtEvent):Void
	{
		DefaultHooks.handleDamage(e.hurtinfo);
		
		if (e.hurtinfo.attacker > 0)
		{
			var p:Player = Reg.server.playermap.get(e.hurtinfo.attacker);
			//p.score += e.hurtinfo.dmg;
			//setPlayerScoreboard(p);
		}
	}
	
	override public function onDeath(e:DeathEvent):Void
	{
		DefaultHooks.handleDeath(e.deathinfo);
		
		var loser:Player = Reg.server.playermap.get(e.deathinfo.victim);
		//loser.deaths++;
		//setPlayerScoreboard(loser);
		
		if (e.deathinfo.attacker > 0)
		{
			//var winner:Player = Reg.server.playermap.get(e.deathinfo.attacker);
			//winner.kills++;
			//setPlayerScoreboard(winner);
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
		
		//score.addPlayer(Reg.server.playermap.get(P.ID));
	}
	
	override public function setTeam(E:SetTeamEvent):Void 
	{
		super.setTeam(E);
		
		DefaultHooks.setTeam(E.player, E.team);
	}
	
	override public function onLeave(e:LeaveEvent):Void
	{
		//score.removePlayer(Reg.server.playermap.get(e.leaveinfo.ID));
		
		DefaultHooks.onPeerDisconnect(e);
	}
	
	override public function onReceive(e:ReceiveEvent):Void
	{
		super.onReceive(e);
	}
	
	override public function onConfig(e:ConfigEvent):Void 
	{
		super.onConfig(e);
		
		captime = Std.parseInt(Assets.config.get("koth_captime"));
		spawn_time = Std.parseInt(Assets.config.get("koth_spawntime"));
	}
}