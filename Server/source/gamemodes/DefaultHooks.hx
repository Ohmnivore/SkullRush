package gamemodes;
import enet.ENet;
import enet.ENetEvent;
import entities.Spawn;
import flixel.addons.weapon.FlxBullet;
import flixel.effects.particles.FlxEmitterExt;
import flixel.FlxG;
import flixel.util.FlxAngle;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxVector;
import gevents.ReceiveEvent;
import haxe.Serializer;
import networkobj.NCounter;
import networkobj.NEmitter;
import networkobj.NLabel;
import networkobj.NReg;
import networkobj.NTimer;

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
	
	public static function hookEvents(gm:BaseGamemode):Void
	{
		gm.addEventListener(HurtEvent.HURT_EVENT, gm.onHurt, false, 10);
		gm.addEventListener(DeathEvent.DEATH_EVENT, gm.onDeath, false, 10);
		gm.addEventListener(JoinEvent.JOIN_EVENT, gm.onJoin, false, 10);
		gm.addEventListener(LeaveEvent.LEAVE_EVENT, gm.onLeave, false, 10);
		gm.addEventListener(ReceiveEvent.RECEIVE_EVENT, gm.onReceive, false, 10);
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
	
	static public function announceGun(winner:Player, loser:Player):Void
	{
		var s:String = winner.name + " gunned down " + loser.name;
		Reg.server.announce(s,
			[new FlxMarkup(0, winner.name.length, false, winner.header.color),
			new FlxMarkup(winner.name.length + 13, s.length, false, loser.header.color)]);
	}
	
	static public function checkIfFall():Void
	{
		for (p in Reg.server.playermap.iterator())
		{
			if (p.y >= Reg.state.collidemap.y + Reg.state.collidemap.height + FlxG.width / 2 && p.alive)
			{
				var info:HurtInfo = new HurtInfo();
				info.attacker = BaseGamemode.FALL;
				info.victim = p.ID;
				info.dmg = 100;
				info.dmgsource = p.getMidpoint();
				info.type = BaseGamemode.ENVIRONMENT;
				
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
		var winner:Player = P;
		var loser:Player = P2;
		
		if (P.dashing_down)
		{
			if (P.y < P2.y)
			{
				winner = P;
				loser = P2;
				
				//P2.health = 0;
				
				//announceSquish(winner, loser);
				
				iskill = true;
			}
		}
		
		if (P2.dashing_down)
		{
			if (P2.y < P.y)
			{
				winner = P2;
				loser = P;
				
				//P.health = 0;
				
				//announceSquish(winner, loser);
				
				iskill = true;
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
			info.type = BaseGamemode.JUMPKILL;
			info.dmgsource = winner.getMidpoint();
			
			Reg.gm.dispatchEvent(new HurtEvent(HurtEvent.HURT_EVENT, info));
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
		var t:Int = info.type;
		var player:Player = Reg.server.playermap.get(info.victim);
		
		if (t == BaseGamemode.ENVIRONMENT)
		{
			DefaultHooks.respawn(player);
			
			var k:Int = info.attacker;
			
			if (k == BaseGamemode.FALL) DefaultHooks.announceFall(player);
		}
		
		if (t == BaseGamemode.BULLET)
		{
			var killer:Player = Reg.server.playermap.get(info.attacker);
			var victim:Player = Reg.server.playermap.get(info.victim);
			
			DefaultHooks.respawn(victim);
			DefaultHooks.announceGun(killer, victim);
		}
		
		if (t == BaseGamemode.JUMPKILL)
		{
			var killer:Player = Reg.server.playermap.get(info.attacker);
			var victim:Player = Reg.server.playermap.get(info.victim);
			
			DefaultHooks.respawn(victim);
			DefaultHooks.announceSquish(killer, victim);
		}
		
		player.respawnIn(Reg.gm.spawn_time);
	}
	
	static public function bulletCollide(Bullet:FlxBullet, Other:Dynamic):Void
	{
		var emitter:FlxEmitterExt = new FlxEmitterExt(Bullet.x + Bullet.width / 2,
													Bullet.y + Bullet.height / 2);
		
		Reg.state.emitters.add(emitter);
		
		emitter.setRotation(0, 0);
		emitter.setMotion(0, 17, 1, 360, 25, 1);
		emitter.setAlpha(1, 1, 0, 0);
		emitter.setColor(0xffE69137, 0xffFFFB17);
		emitter.setXSpeed(150, 150);
		emitter.setYSpeed(150, 150);
		emitter.makeParticles(Assets.getImg("assets/images/explosionparticle.png"), 35);
		
		emitter.start(true, 0.9, 0, 35);
		
		for (p in Reg.state.players.members)
		{
			var pl:Player = cast (p, Player);
			
			var v:FlxVector = new FlxVector(1, 0);
			
			v.rotateByRadians(FlxAngle.angleBetween(Bullet, pl));
			
			//trace(Reg.state.collidemap.ray(Bullet.getMidpoint(), pl.getMidpoint(), new FlxPoint(), 2));
			//var d:FlxPoint = FlxPoint.get(v.x, v.y);
			//var res:FlxPoint = FlxPoint.get();
			//Reg.state.collidemap.rayCast(Bullet.getMidpoint(), d, res);
			//d.put();
			//res.put();
			
			//if (FlxMath.distanceToPoint(Bullet, res) >= FlxMath.distanceBetween(Bullet, pl) - 2)
			//{
				var dist_coeff:Float = (100 - FlxMath.distanceBetween(pl, Bullet)) / 100;
				if (dist_coeff < 0) dist_coeff = 0;
				//if (dist_coeff > 0.5) dist_coeff = 0.5;
				
				pl.velocity.x += v.x * 300 * dist_coeff;
				pl.velocity.y += v.y * 300 * dist_coeff;
				
				//if (pl.team != Reflect.field(Bullet._weapon.parent, "team"))
				if (pl.ID != Reflect.field(Bullet._weapon.parent, "ID"))
				{
					var dmg:Float = dist_coeff * 75;
					//if (pl.health - dmg <= 0)
						//announceGun(cast (Bullet._weapon.parent, Player), pl);
					//pl.health -= dist_coeff * 75;
					
					var info:HurtInfo = new HurtInfo();
					info.attacker = Reflect.field(Bullet._weapon.parent, "ID");
					info.victim = pl.ID;
					info.dmg = Std.int(dmg);
					info.dmgsource = Bullet.getMidpoint();
					info.type = BaseGamemode.BULLET;
					
					Reg.gm.dispatchEvent(new HurtEvent(HurtEvent.HURT_EVENT, info));
				}
				
				else
				{
					pl.canChoose = true;
				}
			//}
		}
		
		Bullet.kill();
	}
	
	static public function onPeerDisconnect(E:LeaveEvent):Void
	{
		var e:ENetEvent = E.leaveinfo;
		
		trace("Peer disconnected! ID: ", e.ID);
		
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
	
	static public function initPlayer(P:Player):Void
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
		
		NEmitter.announceEmitters(P.ID);
		
		var t_arr:Array<String> = [];
		for (t in Reg.gm.teams)
		{
			t_arr.push(t.serialize());
		}
		Msg.Teams.data.set("serialized", Serializer.run(t_arr));
		Reg.server.sendMsg(P.ID, Msg.Teams.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
		
		P.health = 0;
		P.respawnIn(Reg.gm.spawn_time);
	}
	
	static public function onPeerConnect(e:JoinEvent):Void
	{
		var E:ENetEvent = e.joininfo;
		trace("Peer connected. ID: ", E.ID);
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
		
		//var s:Spawn = Spawn.findSpawn(p.team);
		//p.x = s.x;
		//p.y = s.y;
		
		Reg.server.peermap.set(p, p.ID);
		Reg.server.playermap.set(p.ID, p);
		
		Msg.PlayerInfoBack.data.set("id", p.ID);
		Msg.PlayerInfoBack.data.set("name", p.name);
		Msg.PlayerInfoBack.data.set("color", p.header.color);
		Msg.PlayerInfoBack.data.set("graphic", p.graphicKey);
		
		Reg.server.sendMsg(E.ID, Msg.MapMsg.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
		Reg.server.sendMsg(E.ID, Msg.PlayerInfoBack.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
		
		Reg.server.id++;
		
		//Send peerinfo to all
		Msg.PlayerInfoAnnounce.data.set("name", p.name);
		Msg.PlayerInfoAnnounce.data.set("id", p.ID);
		Msg.PlayerInfoAnnounce.data.set("color", p.header.color);
		Msg.PlayerInfoAnnounce.data.set("graphic", p.graphicKey);
		var t:FlxTextExt = new FlxTextExt(0, 0, FlxG.width, name + " has joined!", 12, false,
			[new FlxMarkup(0, name.length, false, p.header.color)]);
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
		
		//initPlayer(p);
		Reg.gm.initPlayer(p);
		
		//p.health = 0;
		//p.respawnIn(Reg.gm.spawn_time);
	}
	
	static public function update(elapsed:Float):Void
	{
		FlxG.collide(Reg.state.tocollide, Reg.state.collidemap);
		FlxG.collide(Reg.state.bullets, Reg.state.collidemap, DefaultHooks.bulletCollide);
		FlxG.collide(Reg.state.bullets, Reg.state.players, DefaultHooks.bulletCollide);
		FlxG.collide(Reg.state.players, DefaultHooks.playerCollide);
		FlxG.collide(Reg.state.players);
		
		DefaultHooks.checkIfFall();
	}
}