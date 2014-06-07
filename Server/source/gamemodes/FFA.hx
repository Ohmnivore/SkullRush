package gamemodes;

import enet.ENet;
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
class FFA extends BaseGamemode
{
	public var testt:NTemplate;
	public var tests:NSprite;
	public var score:NScoreboard;
	
	public var time:NTimer;
	public var finished:Bool = false;
	
	public var maxkills:Int = 25;
	public var maxtime:Int = 10;
	
	public function new() 
	{
		super();
		
		time = new NTimer("Time left", 0xffffffff, 20, 20, 0, true);
		time.setTimer(maxtime * 60, NTimer.UNTICKING);
		
		teams.push(new Team("Green", 0xff13BF00, "assets/images/playergreen.png"));
		teams.push(new Team("Blue", 0xff0086BF, "assets/images/playerblue.png"));
		teams.push(new Team("Yellow", 0xffE0DD00, "assets/images/playeryellow.png"));
		teams.push(new Team("Red", 0xffD14900, "assets/images/playerred.png"));
		
		name = "FFA";
		
		score = new NScoreboard("Scores", ["Score", "Kills", "Deaths"], ["0", "0", "0"], 0xffffffff);
		Reg.state.hud.add(score.group);
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
		
		if (time.count == 0 && !finished)
		{
			timeElapsed();
		}
		
		for (p in Reg.server.playermap.iterator())
		{
			var player:Player = p;
			
			if (player.kills >= maxkills && !finished)
			{
				var winner:NLabel = new NLabel(20, 40, 0xffffffff, 0, true);
				winner.setLabel(player.name + " wins!", player.header.color);
				
				endMatch();
			}
		}
	}
	
	public function timeElapsed():Void
	{
		var arr:Array<Player> = Lambda.array(Reg.server.playermap);
		
		arr.sort(function(a:Player,b:Player):Int {
			if (a.kills == b.kills)
				return 0;
			if (a.kills > b.kills)
				return 1;
			else
				return -1;
		});
		
		if (arr.length > 0)
		{
			var player:Player = cast arr[0];
			var winner:NLabel = new NLabel(20, 40, 0xffffffff, 0, true);
			winner.setLabel(player.name + " wins!", player.header.color);
		}
		
		endMatch();
	}
	
	public function endMatch():Void
	{
		finished = true;
		
		new FlxTimer(10, changeMap);
	}
	
	public function changeMap(T:FlxTimer):Void
	{
		Admin.nextMap();
	}
	
	public function setPlayerScoreboard(P:Player):Void
	{
		score.setPlayer(P, [Std.string(P.score), Std.string(P.kills), Std.string(P.deaths)]);
	}
	
	override public function onHurt(e:HurtEvent):Void
	{
		DefaultHooks.handleDamage(e.hurtinfo);
		
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
	}
	
	override public function setTeam(E:SetTeamEvent):Void 
	{
		super.setTeam(E);
		
		DefaultHooks.setTeam(E.player, E.team);
	}
	
	override public function onLeave(e:LeaveEvent):Void
	{
		score.removePlayer(Reg.server.playermap.get(e.leaveinfo.ID));
		
		DefaultHooks.onPeerDisconnect(e);
	}
	
	override public function onReceive(e:ReceiveEvent):Void
	{
		super.onReceive(e);
	}
	
	override public function onConfig(e:ConfigEvent):Void 
	{
		super.onConfig(e);
		
		maxkills = Std.parseInt(Assets.config.get("ffa_maxkills"));
		maxtime = Std.parseInt(Assets.config.get("ffa_maxtime"));
	}
}