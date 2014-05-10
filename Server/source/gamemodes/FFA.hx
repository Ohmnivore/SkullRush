package gamemodes;

import enet.ENet;
import gevents.ConfigEvent;
import gevents.DeathEvent;
import gevents.HurtEvent;
import gevents.HurtInfo;
import gevents.JoinEvent;
import gevents.LeaveEvent;
import gevents.ReceiveEvent;
import networkobj.NReg;
import networkobj.NScoreboard;
import networkobj.NSprite;
import networkobj.NTemplate;

/**
 * ...
 * @author Ohmnivore
 */
class FFA extends BaseGamemode
{
	public var testt:NTemplate;
	public var tests:NSprite;
	public var score:NScoreboard;
	
	public var maxkills:Int = 25;
	
	public function new() 
	{
		super();
		
		teams.push(new Team("Green", 0xff13BF00, "assets/images/playergreen.png"));
		teams.push(new Team("Blue", 0xff0086BF, "assets/images/playerblue.png"));
		teams.push(new Team("Yellow", 0xffE0DD00, "assets/images/playeryellow.png"));
		teams.push(new Team("Red", 0xffD14900, "assets/images/playerred.png"));
		
		name = "FFA";
		DefaultHooks.hookEvents(this);
		
		testt = new NTemplate("assets/images/gun.png");
		NReg.registerTemplate(testt);
		
		tests = new NSprite(10, 50, testt);
		
		score = new NScoreboard("Scores", ["Score", "Kills", "Deaths"], ["0", "0", "0"], 0xffffffff);
		Reg.state.hud.add(score.group);
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
	
	public function setPlayerScoreboard(P:Player):Void
	{
		score.setPlayer(P, [Std.string(P.score), Std.string(P.kills), Std.string(P.deaths)]);
	}
	
	override public function onHurt(e:HurtEvent):Void
	{
		DefaultHooks.handleDamage(e.hurtinfo);
		
		if (e.hurtinfo.type == BaseGamemode.BULLET)
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
	
	override public function initPlayer(P:Player):Void 
	{
		super.initPlayer(P);
		
		DefaultHooks.initPlayer(P);
		
		score.addPlayer(Reg.server.playermap.get(P.ID));
	}
	
	override public function setTeam(P:Player, T:Team):Void 
	{
		super.setTeam(P, T);
		
		DefaultHooks.setTeam(P, T);
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
		
		maxkills = Std.parseInt(Assets.config.get("maxkills"));
	}
	
	//override public function createScore():Void
	//{
		//DefaultHooks.createScore();
	//}
}