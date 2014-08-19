package gamemodes;
import enet.ENet;
import enet.ENetEvent;
import entities.Spawn;
import ext.FlxEmitterAuto;
import flixel.addons.weapon.FlxBullet;
import flixel.effects.particles.FlxEmitterExt;
import flixel.FlxG;
import flixel.util.FlxAngle;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxVector;
import gevents.GenEvent;
import gevents.InitEvent;
import gevents.ReceiveEvent;
import gevents.RespawnEvent;
import gevents.SetTeamEvent;
import haxe.Serializer;
import networkobj.NCounter;
import networkobj.NEmitter;
import networkobj.NLabel;
import networkobj.NReg;
import networkobj.NTimer;
import networkobj.NWeapon;
import weapons.Eviscerator;
import weapons.Launcher;
import weapons.Splasher;
import ext.FlxMarkup;
import ext.FlxWeaponExt;
import ext.FlxTextExt;

import gevents.DeathEvent;
import gevents.HurtEvent;
import gevents.HurtInfo;
import gevents.JoinEvent;
import gevents.LeaveEvent;

/**
 * ...
 * @author Ohmnivore
 */
class DefaultHooks
{
	public static inline var FALL:Int = -2;
	
	public static inline var DEFAULT:Int = 0;
	public static inline var ENVIRONMENT:Int = 1;
	public static inline var JUMPKILL:Int = 2;
	public static inline var BULLET:Int = 3;
	
	public static var spawn_timer:Float = 3.0;
	public static var deathEmitter:Int;
	
	public static function hookEvents(gm:BaseGamemode):Void
	{
		gm.addEventListener(HurtEvent.HURT_EVENT, gm.onHurt, false, 10);
		gm.addEventListener(DeathEvent.DEATH_EVENT, gm.onDeath, false, 10);
		gm.addEventListener(JoinEvent.JOIN_EVENT, gm.onJoin, false, 10);
		gm.addEventListener(LeaveEvent.LEAVE_EVENT, gm.onLeave, false, 10);
		gm.addEventListener(ReceiveEvent.RECEIVE_EVENT, gm.onReceive, false, 10);
		gm.addEventListener(RespawnEvent.RESPAWN_EVENT, gm.onSpawn, false, 10);
		gm.addEventListener(GenEvent.SHUTDOWN, gm.shutdown, false, 10);
		gm.addEventListener(InitEvent.INIT_EVENT, gm.initPlayer, false, 10);
		gm.addEventListener(SetTeamEvent.SETTEAM_EVENT, gm.setTeam, false, 10);
		gm.addEventListener(GenEvent.MAKE_WEAPONS, gm.makeWeapons, false, 10);
	}
	
	static public function makeWeapons():Void
	{
		NWeapon.addWeapon(new Launcher(), 1);
		NWeapon.addWeapon(new Splasher(), 2);
		NWeapon.addWeapon(new Eviscerator(), 3);
		
		registerDeathEmitter();
	}
	
	static public function registerDeathEmitter():Void
	{
		var emit:FlxEmitterAuto = new FlxEmitterAuto(Reg.state.emitters);
		emit.setRotation(0, 0);
		emit.setMotion(0, 25, 0.9, 360, 35, 0);
		emit.setAlpha(1, 0.8, 0, 0.2);
		emit.setColor(0xffFF1726, 0xffFF5D17);
		emit.setXSpeed(250, 300);
		emit.setYSpeed(250, 255);
		emit.bounce = 1;
		
		deathEmitter = NEmitter.registerEmitter(emit);
	}
	
	static public function onSpawn(P:Player):Void
	{
		NWeapon.grantWeapon(P.ID, [1, 2, 3]);
	}
	
	static public function announceFall(victim:Player):Void 
	{
		var s:String = victim.name + " fell to his death.";
		Reg.server.announce(s,
			[new FlxMarkup(0, victim.name.length, false, victim.header.color)]);
	}
	
	static public function announceSquish(winner:Player, loser:Player):Void
	{
		var s:String = winner.name + " pummeled " + loser.name;
		Reg.server.announce(s,
			[new FlxMarkup(0, winner.name.length, false, winner.header.color),
			new FlxMarkup(winner.name.length + 10, s.length, false, loser.header.color)]);
	}
	
	static public function announceGun(winner:Player, loser:Player, verb:String):Void
	{
		var s:String = winner.name + ' $verb ' + loser.name;
		Reg.server.announce(s,
			[new FlxMarkup(0, winner.name.length, false, winner.header.color),
			new FlxMarkup(winner.name.length + verb.length + 2, s.length, false, loser.header.color)]);
	}
	
	static public function checkIfFall():Void
	{
		for (p in Reg.server.playermap.iterator())
		{
			if (p.y >= Reg.state.collidemap.y + Reg.state.collidemap.height + FlxG.width / 2 && p.alive)
			{
				var info:HurtInfo = new HurtInfo();
				info.attacker = BaseGamemode.ENV_FALL;
				info.victim = p.ID;
				info.dmg = 100;
				info.dmgsource = p.getMidpoint();
				info.type = BaseGamemode.TYPE_ENVIRONMENT;
				
				Reg.gm.dispatchEvent(new HurtEvent(HurtEvent.HURT_EVENT, info));
			}
		}
	}
	
	public static function respawn(player:Player):Void
	{
		player.respawnIn(spawn_timer);
	}
	
	static public function playerCollide(P:Player, P2:Player):Void
	{
		var iskill:Bool = false;
		var isjump:Bool = false;
		var winner:Player = P;
		var loser:Player = P2;
		
		if (P.dashing_down)
		{
			if (P.y < P2.y)
			{
				winner = P;
				loser = P2;
				
				iskill = true;
			}
		}
		else
		{
			if (P.y < P2.y)
			{
				winner = P;
				loser = P2;
				
				isjump = true;
			}
		}
		
		if (P2.dashing_down)
		{
			if (P2.y < P.y)
			{
				winner = P2;
				loser = P;
				
				iskill = true;
			}
		}
		else
		{
			if (P2.y < P.y)
			{
				winner = P2;
				loser = P;
				
				isjump = true;
			}
		}
		
		if (iskill)
		{
			var info:HurtInfo = new HurtInfo();
			info.attacker = winner.ID;
			info.victim = loser.ID;
			if (winner.velocity.y > 0)
			{
				if (winner.y + winner.height <= loser.y)
				{
					info.dmg = 100;
				}
			}
			info.type = BaseGamemode.TYPE_JUMPKILL;
			info.dmgsource = winner.getMidpoint();
			
			Reg.gm.dispatchEvent(new HurtEvent(HurtEvent.HURT_EVENT, info));
		}
		
		if (isjump)
		{
			winner.velocity.y -= 280;
			loser.velocity.y += 100;
		}
	}
	
	public static function handleDamage(info:HurtInfo, useTeams:Bool = false):Void
	{
		if (useTeams && info.attacker > 0)
		{
			var v:Player = Reg.server.playermap.get(info.victim);
			var a:Player = Reg.server.playermap.get(info.attacker);
			
			if (a.team == v.team)
			{
				return;
			}
		}
		
		var p:Player = Reg.server.playermap.get(info.victim);
		if (info.victim != info.attacker) p.health -= info.dmg;
		
		if (p.alive)
			if (p.health <= 0) Reg.gm.dispatchEvent(new DeathEvent(DeathEvent.DEATH_EVENT, info));
	}
	
	public static function handleDeath(info:HurtInfo):Void
	{
		var t:String = info.type;
		var player:Player = Reg.server.playermap.get(info.victim);
		
		if (t == BaseGamemode.TYPE_ENVIRONMENT)
		{
			DefaultHooks.respawn(player);
			
			var k:Int = info.attacker;
			
			if (k == BaseGamemode.ENV_FALL) DefaultHooks.announceFall(player);
		}
		
		if (t == BaseGamemode.TYPE_BULLET)
		{
			var killer:Player = Reg.server.playermap.get(info.attacker);
			var victim:Player = Reg.server.playermap.get(info.victim);
			
			DefaultHooks.respawn(victim);
			DefaultHooks.announceGun(killer, victim, info.weapon.verb);
		}
		
		if (t == BaseGamemode.TYPE_JUMPKILL)
		{
			var killer:Player = Reg.server.playermap.get(info.attacker);
			var victim:Player = Reg.server.playermap.get(info.victim);
			
			DefaultHooks.respawn(victim);
			DefaultHooks.announceSquish(killer, victim);
		}
		
		//Emitter section
		NEmitter.playEmitter(deathEmitter, true, Std.int(player.x + player.width / 2),
				Std.int(player.y + player.height / 2), "assets/images/explosionparticle.png", 1, 0, true, 50);
		//
		
		player.respawnIn(Reg.gm.spawn_time);
	}
	
	static public function bulletCollide(Bullet:FlxBullet, Other:Dynamic):Void
	{
		var wep_ext:FlxWeaponExt = cast Bullet._weapon;
		wep_ext.template.collide(Bullet, Other);
		
		return;
	}
	
	static public function onPeerDisconnect(E:LeaveEvent):Void
	{
		var e:ENetEvent = E.leaveinfo;
		
		trace("Peer disconnected! ID: " + Std.string(e.ID));
		
		var p:Player = Reg.server.playermap.get(e.ID);
		
		//BaseGamemode.scores.removePlayer(p);
		
		//Send disconnect to everyone
		Msg.PlayerDisco.data.set("id", e.ID);
		var t:FlxTextExt = new FlxTextExt(0, 0, FlxG.width, p.name + " has left.", 12, false,
			[new FlxMarkup(0, p.name.length, false, p.header.color)]);
		Reg.announcer.addMsg(p.name + " has left!", [new FlxMarkup(0, p.name.length, false, p.header.color)]);
		Msg.Announce.data.set("message", p.name + " has left.");
		Msg.Announce.data.set("markup", t.ExportMarkups());
		for (pl in Reg.server.playermap.iterator())
		{
			if (e.ID != pl.ID)
			{
				Reg.server.sendMsg(pl.ID, Msg.PlayerDisco.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
				Reg.server.sendMsg(pl.ID, Msg.Announce.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
			}
		}
		
		Reg.server.peermap.remove(p);
		Reg.server.playermap.remove(p.ID);
		
		p.kill();
	} 
	
	static public function setTeam(P:Player, T:Team):Void
	{
		P.setColor(T.color, T.graphicKey);
		
		Msg.SetAppearance.data.set("id", P.ID);
		Msg.SetAppearance.data.set("color", P.header.color);
		Msg.SetAppearance.data.set("graphic", P.graphicKey);
		
		for (ID in Reg.server.playermap.keys())
		{
			if (ID != P.ID)
			{
				Reg.server.sendMsg(ID, Msg.SetAppearance.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
			}
		}
	}
	
	static public function preInitPlayer(P:Player):Void
	{
		Msg.AnnounceTemplates.data.set("serialized", NReg.exportTemplates());
		
		Reg.server.sendMsg(P.ID, Msg.AnnounceTemplates.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
		
		for (s in NReg.sprites)
		{
			s.announce(P.ID);
		}
		
		for (h in NReg.huds)
		{
			h.announce(P.ID);
		}
		
		for (t in NReg.timers.iterator())
		{
			t.announce(P.ID);
		}
		
		for (s in BaseGamemode.scores.scores.iterator())
		{
			s.announce(P.ID);
		}
		
		var t_arr:Array<String> = [];
		for (t in Reg.gm.teams)
		{
			t_arr.push(t.serialize());
		}
		Msg.Teams.data.set("serialized", Serializer.run(t_arr));
		Reg.server.sendMsg(P.ID, Msg.Teams.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
		
		NEmitter.announceEmitters(P.ID);
		NWeapon.announceWeapons(P.ID);
	}
	
	static public function initPlayer(P:Player, firstInit:Bool = false):Void
	{
		if (!firstInit)
		{
			Msg.AnnounceTemplates.data.set("serialized", NReg.exportTemplates());
			
			Reg.server.sendMsg(P.ID, Msg.AnnounceTemplates.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
			
			for (s in NReg.sprites)
			{
				s.announce(P.ID);
			}
			
			for (h in NReg.huds)
			{
				h.announce(P.ID);
			}
			
			for (t in NReg.timers.iterator())
			{
				t.announce(P.ID);
			}
			
			for (s in BaseGamemode.scores.scores.iterator())
			{
				s.announce(P.ID);
			}
			
			var t_arr:Array<String> = [];
			for (t in Reg.gm.teams)
			{
				t_arr.push(t.serialize());
			}
			Msg.Teams.data.set("serialized", Serializer.run(t_arr));
			Reg.server.sendMsg(P.ID, Msg.Teams.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
			
			NEmitter.announceEmitters(P.ID);
			NWeapon.announceWeapons(P.ID);
		}
		
		P.health = 0;
		P.respawnIn(Reg.gm.spawn_time, 2);
	}
	
	static public function onPeerConnect(e:JoinEvent):Void
	{
		var E:ENetEvent = e.joininfo;
		trace("Peer connected. ID: " + Std.string(E.ID));
		var name:String = Msg.PlayerInfo.data.get("name");
		name = StringTools.trim(name);
		if (name.length > 15) name = name.substr(0, 15);
		
		for (pl in Reg.server.playermap.iterator())
		{
			if (pl.name == name)
			{
				name += "*";
			}
		}
		
		var p:Player = new Player(E.ID, name, 50, 50);
		
		var color:Int = Msg.PlayerInfo.data.get("team");
		
		Reg.server.peermap.set(p, p.ID);
		Reg.server.playermap.set(p.ID, p);
		
		Reg.server.sendMsg(p.ID, Msg.MapMsg.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
		
		Msg.PlayerInfoBack.data.set("id", p.ID);
		Msg.PlayerInfoBack.data.set("name", p.name);
		Msg.PlayerInfoBack.data.set("color", p.header.color);
		Msg.PlayerInfoBack.data.set("graphic", p.graphicKey);
		
		preInitPlayer(p);
		Reg.server.sendMsg(E.ID, Msg.PlayerInfoBack.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
		
		Reg.server.id++;
		
		//Send peerinfo to all
		Msg.PlayerInfoAnnounce.data.set("name", p.name);
		Msg.PlayerInfoAnnounce.data.set("id", p.ID);
		Msg.PlayerInfoAnnounce.data.set("color", p.header.color);
		Msg.PlayerInfoAnnounce.data.set("graphic", p.graphicKey);
		var t:FlxTextExt = new FlxTextExt(0, 0, FlxG.width, name + " has joined!", 12, false,
			[new FlxMarkup(0, name.length, false, 0xffffffff)]);
		Reg.announcer.addMsg(name + " has joined!", []);
		Msg.Announce.data.set("message", name + " has joined!");
		Msg.Announce.data.set("markup", t.ExportMarkups());
		for (pl in Reg.server.playermap.iterator())
		{
			if (p.ID != pl.ID)
			{
				Reg.server.sendMsg(pl.ID, Msg.PlayerInfoAnnounce.ID, 1,
						ENet.ENET_PACKET_FLAG_RELIABLE);
				Reg.server.sendMsg(pl.ID, Msg.Announce.ID, 1,
						ENet.ENET_PACKET_FLAG_RELIABLE);
			}
		}
		
		for (pl in Reg.server.playermap.iterator())
		{
			if (p.ID != pl.ID)
			{
				Msg.PlayerInfoAnnounce.data.set("name", pl.name);
				Msg.PlayerInfoAnnounce.data.set("id", pl.ID);
				Msg.PlayerInfoAnnounce.data.set("color", pl.header.color);
				Msg.PlayerInfoAnnounce.data.set("graphic", pl.graphicKey);
				
				Reg.server.sendMsg(p.ID, Msg.PlayerInfoAnnounce.ID, 1,
						ENet.ENET_PACKET_FLAG_RELIABLE);
			}
		}
		
		Reg.gm.dispatchEvent(new InitEvent(InitEvent.INIT_EVENT, p, true));
	}
	
	static public function update(elapsed:Float):Void
	{
		FlxG.collide(Reg.state.tocollide, Reg.state.maps); //collidemap
		FlxG.collide(Reg.state.bullets, Reg.state.maps, DefaultHooks.bulletCollide); //collidemap
		FlxG.overlap(Reg.state.bullets, Reg.state.players, DefaultHooks.bulletCollide);
		FlxG.collide(Reg.state.players, DefaultHooks.playerCollide);
		FlxG.collide(Reg.state.players);
		FlxG.collide(Reg.state.emitters, Reg.state.maps); //collidemap
		
		DefaultHooks.checkIfFall();
	}
}