package ;

import enet.Client;
import enet.ENet;
import enet.ENetEvent;
import flixel.addons.display.FlxZoomCamera;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxEmitterExt;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.scaleModes.FillScaleMode;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.text.FlxText;
import flixel.util.FlxPoint;
import haxe.io.BytesInput;
import haxe.Serializer;
import haxe.Unserializer;
import hxudp.UdpSocket;
import networkobj.NReg;
import networkobj.NScoreboard;
import networkobj.NTemplate;
import networkobj.NTimer;
import haxe.io.Bytes;
import networkobj.NWeapon;
import ui.DirectConnect;
import ui.Spawn;
import ext.FlxEmitterAuto;

/**
 * ...
 * @author Ohmnivore
 */

class SkullClient extends Client
{
	public var s:UdpSocket;
	
	public var rIP:String;
	public var rPort:Int;
	public var _s_id:Int;
	
	public static var execute:Bool = false;
	public static var init:Bool = false;
	
	public static function initClient():Void
	{
		if (!init)
		{
			//Setup zoom camera
			if (FlxG.camera.zoom > 1)
			{
				var cam:FlxZoomCamera = new FlxZoomCamera(0, 0, Std.int(FlxG.width/2), Std.int(FlxG.height/2), 2);
				FlxG.cameras.reset(cam);
				FlxG.scaleMode = new RatioScaleMode();
				FlxG.cameras.bgColor = 0xff000000;
			}
			
			else
			{
				FlxG.scaleMode = new RatioScaleMode();
				FlxG.cameras.bgColor = 0xff000000;
			}
			
			ENet.init();
			NReg.init();
			NWeapon.init();
			Msg.initMsg();
			//trace(Assets.config.get("ip"));
			Reg.client = new SkullClient(Assets.config.get("ip"), 6666);
			Reg.host = Reg.client;
			
			execute = true;
			init = true;
		}
	}
	
	public function new(IP:String = "", Port:Int = 6666)
	{
		super(IP, Port, 3, 1);
		
		rIP = IP;
		rPort = Port;
		
		Msg.addToHost(this);
		
		s = new UdpSocket();
		s.create();
		s.bind(1990);
		s.setNonBlocking(true);
		s.setEnableBroadcast(true);
		s.connect(ENet.BROADCAST_ADDRESS, 1945);
	}
	
	public function updateS():Void
	{
		var b = Bytes.alloc(80);
		s.receive(b);
		var msg:String = new BytesInput(b).readUntil(0);
		
		if (msg.length > 0)
			trace(msg);
	}
	
	public function updatePingText():Void
	{
		if (_s_id > 0)
		try
		{
			Reg.state.ping_text.text = Std.string(ENet.getPeerPing(_s_id));
		}
		catch (E:Dynamic)
		{
			
		}
	}
	
	override public function onPeerConnect(e:ENetEvent):Void
	{
		super.onPeerConnect(e);
		
		trace("Connected successfully!");
		
		_s_id = e.ID;
	}
	
	override public function onPeerDisonnect(e:ENetEvent):Void 
	{
		super.onPeerDisonnect(e);
		
		trace("Disconnected!");
	}
	
	override public function onReceive(MsgID:Int, E:ENetEvent):Void 
	{
		super.onReceive(MsgID, E);
		
		if (MsgID == Msg.Manifest.ID)
		{
			if (Msg.Manifest.data.get("url") == "null")
			{
				Reg.state.onLoaded();
			}
			else
			{
				var d:Downloader = new Downloader(Msg.Manifest.data.get("url"));
				d.whenfinished = Reg.state.onLoaded;
			}
		}
		
		if (MsgID == Msg.MapMsg.ID)
		{
			//if (Reg.state.collidemap != null)
				//FlxG.switchState(new PlayState());
			Reg.state.loadMap(Msg.MapMsg.data.get("mapname"), Msg.MapMsg.data.get("mapstring"));
		}
		
		if (MsgID == Msg.PlayerInfoBack.ID)
		{
			Reg.state.player = new Player(Msg.PlayerInfoBack.data.get("id"),
								Msg.PlayerInfoBack.data.get("name"),
								50,
								50);
			
			Reg.state.player.setColor(Msg.PlayerInfoBack.data.get("color"),
										Msg.PlayerInfoBack.data.get("graphic"));
			
			Reg.state.playermap.set(Reg.state.player.ID, Reg.state.player);
			
			FlxG.camera.follow(Reg.state.player);
			FlxG.camera.followLerp = 15.0;
		}
		
		if (MsgID == Msg.PlayerInfoAnnounce.ID)
		{
			var p:Player = new Player(Msg.PlayerInfoAnnounce.data.get("id"),
										Msg.PlayerInfoAnnounce.data.get("name"),
										50,
										50);
			
			p.setColor(Msg.PlayerInfoAnnounce.data.get("color"),
						Msg.PlayerInfoAnnounce.data.get("graphic"));
			
			Reg.state.playermap.set(p.ID, p);
		}
		
		if (MsgID == Msg.PlayerDisco.ID)
		{
			var p:Player = Reg.state.playermap.get(Msg.PlayerDisco.data.get("id"));
			
			if (p != null)
			{
				Reg.state.playermap.remove(Msg.PlayerDisco.data.get("id"));
				
				p.kill();
			}
		}
		
		if (MsgID == Msg.PlayerOutput.ID)
		{
			var arr:Array<String> = Unserializer.run(Msg.PlayerOutput.data.get("serialized"));
			
			for (s in arr)
			{
				var parr:Array<Dynamic> = Unserializer.run(s);
				
				try
				{
					if (parr != null)
					{
						if (parr[0] != null)
						{
							var p:Player = Reg.state.playermap.get(parr[0]);
							
							if (p != null)
							{
								p.c_unserialize(parr);
							}
						}
					}
				}
				catch (e:Dynamic)
				{
					
				}
			}
		}
		
		if (MsgID == Msg.ChatToClient.ID)
		{
			var ID:Int = Msg.ChatToClient.data.get("id");
			
			if (ID == 0)
			{
				Reg.chatbox.addMsg(Msg.ChatToClient.data.get("message"),
									Msg.ChatToClient.data.get("color"));
			}
			
			else
			{
				Reg.chatbox.addMsg(Msg.ChatToClient.data.get("message"),
									Msg.ChatToClient.data.get("color"));
			}
		}
		
		if (MsgID == Msg.Announce.ID)
		{
			Reg.announcer.parseMsg(Msg.Announce.data.get("message"), Msg.Announce.data.get("markup"));
		}
		
		//Networked objects handling below
		
		if (MsgID == Msg.NewLabel.ID)
		{
			var t:FlxText = new FlxText(Msg.NewLabel.data.get("x"),
												Msg.NewLabel.data.get("y"),
												FlxG.width,
												"",
												12);
			t.scrollFactor.set();
			t.setBorderStyle(FlxText.BORDER_OUTLINE, 0xff000000);
			NReg.HUDS.set(Msg.NewLabel.data.get("id"), t);
			
			Reg.state.hud.add(t);
			//trace("new label: ", t.text);
		}
		
		if (MsgID == Msg.SetLabel.ID)
		{
			var t:FlxText = NReg.HUDS.get(Msg.SetLabel.data.get("id"));
			
			if (t != null)
			{
				t.text = Msg.SetLabel.data.get("text");
				t.color = Msg.SetLabel.data.get("color");
			}
		}
		
		if (MsgID == Msg.NewCounter.ID)
		{
			var t:FlxText = new FlxText(Msg.NewCounter.data.get("x"),
												Msg.NewCounter.data.get("y"),
												FlxG.width,
												Msg.NewCounter.data.get("base") + ": 0",
												12);
			t.scrollFactor.set();
			t.setBorderStyle(FlxText.BORDER_OUTLINE, 0xff000000);
			NReg.HUDS.set(Msg.NewCounter.data.get("id"), t);
			
			Reg.state.hud.add(t);
			//trace("new counter: ", t.text);
		}
		
		if (MsgID == Msg.SetCounter.ID)
		{
			var t:FlxText = NReg.HUDS.get(Msg.SetCounter.data.get("id"));
			
			if (t != null)
			{
				t.color = Msg.SetCounter.data.get("color");
				t.text = Msg.SetCounter.data.get("base") + ": " + Msg.SetCounter.data.get("count");
			}
		}
		
		if (MsgID == Msg.NewTimer.ID)
		{
			var t:NTimer = new NTimer(Msg.NewTimer.data.get("base"),
											Msg.NewTimer.data.get("x"),
											Msg.NewTimer.data.get("y"));
			t.scrollFactor.set();
			NReg.HUDS.set(Msg.NewTimer.data.get("id"), t);
			
			Reg.state.hud.add(t);
			//trace("new timer: ", t.text);
		}
		
		if (MsgID == Msg.SetTimer.ID)
		{
			var t:NTimer = cast(NReg.HUDS.get(Msg.SetTimer.data.get("id")), NTimer);
			
			if (t != null)
			{
				t.base = Msg.SetTimer.data.get("base");
				t.color = Msg.SetTimer.data.get("color");
				t.status = Msg.SetTimer.data.get("status");
				t.count = Msg.SetTimer.data.get("count");
			}
		}
		
		if (MsgID == Msg.DeleteHUD.ID)
		{
			var t:FlxText = NReg.HUDS.get(Msg.DeleteHUD.data.get("id"));
			
			if (t != null)
			{
				NReg.HUDS.remove(Msg.DeleteHUD.data.get("id"));
				
				Reg.state.hud.remove(t, true);
				
				t.kill();
				t.destroy();
			}
		}
		
		if (MsgID == Msg.AnnounceTemplates.ID)
		{
			NReg.templates = Unserializer.run(Msg.AnnounceTemplates.data.get("serialized"));
		}
		
		if (MsgID == Msg.NewSprite.ID)
		{
			var templ:NTemplate = NReg.templates.get(Msg.NewSprite.data.get("template_id"));
			
			var s:FlxSprite = new FlxSprite(Msg.NewSprite.data.get("x"),
											Msg.NewSprite.data.get("y"),
											Assets.images.get(templ.graphicKey));
			
			s.drag.x = templ.drag_x;
			s.acceleration.y = templ.gravity_force;
			s.maxVelocity.x = templ.maxspeed_x;
			
			NReg.sprites.set(Msg.NewSprite.data.get("id"), s);
			
			Reg.state.ent.add(s);
		}
		
		if (MsgID == Msg.UpdateSprite.ID)
		{
			var s:FlxSprite = NReg.sprites.get(Msg.UpdateSprite.data.get("id"));
			
			if (s != null)
			{
				s.x = Msg.UpdateSprite.data.get("x");
				s.y = Msg.UpdateSprite.data.get("y");
				s.velocity.x = Msg.UpdateSprite.data.get("velocity.x");
				s.velocity.y = Msg.UpdateSprite.data.get("velocity.y");
			}
		}
		
		if (MsgID == Msg.DeleteSprite.ID)
		{
			var s:FlxSprite = NReg.sprites.get(Msg.DeleteSprite.data.get("id"));
			
			if (s != null)
			{
				NReg.sprites.remove(Msg.DeleteSprite.data.get("id"));
				Reg.state.ent.remove(s, true);
				s.kill();
				s.destroy();
			}
			
			//s.kill();
			//s.destroy();
		}
		
		if (MsgID == Msg.SetSpriteImage.ID)
		{
			var s:FlxSprite = NReg.sprites.get(Msg.SetSpriteImage.data.get("id"));
			
			if (s != null)
			{
				s.loadGraphic(Assets.images.get(Msg.SetSpriteImage.data.get("graphic")));
			}
		}
		
		if (MsgID == Msg.SetSpriteFields.ID)
		{
			var s:FlxSprite = NReg.sprites.get(Msg.SetSpriteFields.data.get("id"));
			
			if (s != null)
			{
				var Fields:Array<String> = cast Unserializer.run(Msg.SetSpriteFields.data.get("fields"));
				var Values:Array<Dynamic> = cast Unserializer.run(Msg.SetSpriteFields.data.get("values"));
				
				var i:Int = 0;
				
				while (i < Fields.length)
				{
					Reflect.setProperty(s, Fields[i], Values[i]);
					i++;
				}
			}
		}
		
		if (MsgID == Msg.PlaySound.ID)
		{
			FlxG.sound.play(Assets.sounds.get(Msg.PlaySound.data.get("assetkey")));
		}
		
		if (MsgID == Msg.PlayMusic.ID)
		{
			FlxG.sound.playMusic(Assets.sounds.get(Msg.PlayMusic.data.get("assetkey")));
		}
		
		if (MsgID == Msg.StopMusic.ID)
		{
			FlxG.sound.music.stop();
		}
		
		if (MsgID == Msg.NewBoard.ID)
		{
			var board:NScoreboard = new NScoreboard(
										Msg.NewBoard.data.get("id"),
										Msg.NewBoard.data.get("title"),
										Unserializer.run(Msg.NewBoard.data.get("headers")),
										Msg.NewBoard.data.get("color")
										);
			Reg.state.hud.add(board.group);
		}
		
		if (MsgID == Msg.SetBoard.ID)
		{
			var board:NScoreboard = Reg.state.scores.scores.get(Msg.SetBoard.data.get("id"));
			
			if (board != null)
			{
				board.setData(Msg.SetBoard.data.get("serialized"));
			}
		}
		
		if (MsgID == Msg.DeleteBoard.ID)
		{
			var board:NScoreboard = Reg.state.scores.scores.get(Msg.DeleteBoard.data.get("id"));
			
			if (board != null)
			{
				Reg.state.scores.removeBoard(board);
				
				board.destroy();
			}
		}
		
		if (MsgID == Msg.Teams.ID)
		{
			Reg.state.teams = [];
			
			var arr:Array<String> = cast Unserializer.run(Msg.Teams.data.get("serialized"));
			for (s in arr)
			{
				var team:Team = new Team();
				team.unserialize(s);
				Reg.state.teams.push(team);
			}
		}
		
		if (MsgID == Msg.DeathInfo.ID)
		{
			Reg.state.openSubState(new Spawn(Reg.state.teams, Msg.DeathInfo.data.get("timer")));
			Reg.state.wepHUD.hideAllIcons();
		}
		
		if (MsgID == Msg.SpawnConfirm.ID)
		{
			if (Reg.state.subState != null)
			{
				Reg.state.closeSubState();
			}
			
			Reg.state.player.setColor(Msg.SpawnConfirm.data.get("color"),
										Msg.SpawnConfirm.data.get("graphic"));
		}
		
		if (MsgID == Msg.SetAppearance.ID)
		{
			var p:Player = Reg.state.playermap.get(Msg.SetAppearance.data.get("id"));
			
			if (p != null)
			{
				p.setColor(Msg.SetAppearance.data.get("color"), Msg.SetAppearance.data.get("graphic"));
			}
		}
		
		if (MsgID == Msg.EmitterAnnounce.ID)
		{
			var array:Array<Dynamic> = cast Unserializer.run(Msg.EmitterAnnounce.data.get("serialized"));
			
			for (e in array)
			{
				var arr:Array<Dynamic> = cast e;
				var em:FlxEmitterAuto = new FlxEmitterAuto(Reg.state.emitters);
				NReg.emitters.set(cast arr[0], em);
				var acc:FlxPoint = cast arr[2];
				em.acceleration.x = acc.x;
				em.acceleration.y = acc.y;
				em.blend = cast arr[3];
				em.bounce = cast arr[4];
				//em.collisionType = cast arr[5];
				em.endAlpha = cast arr[6];
				em.endBlue = cast arr[7];
				em.endGreen = cast arr[8];
				em.endRed = cast arr[9];
				em.endScale = cast arr[10];
				em.frequency = cast arr[11];
				em.gravity = cast arr[12];
				em.height = cast arr[13];
				em.life = cast arr[14];
				em.lifespan = cast arr[15];
				em.maxRotation = cast arr[16];
				em.maxSize = cast arr[17];
				em.minRotation = cast arr[18];
				var drag:FlxPoint = cast arr[19];
				em.particleDrag.x = drag.x;
				em.particleDrag.y = drag.y;
				em.rotation = cast arr[20];
				em.startAlpha = cast arr[21];
				em.startBlue = cast arr[22];
				em.startGreen = cast arr[23];
				em.startRed = cast arr[24];
				em.startScale = cast arr[25];
				em.width = cast arr[26];
				em.xVelocity = cast arr[27];
				em.yVelocity = cast arr[28];
				
				em.angle = cast arr[29];
				em.angleRange = cast arr[30];
				em.distance = cast arr[31];
				em.distanceRange = cast arr[32];
			}
		}
		
		if (MsgID == Msg.EmitterNew.ID)
		{
			var e:FlxEmitterAuto = cloneFromEmitter(NReg.emitters.get(Msg.EmitterNew.data.get("id")),
				Msg.EmitterNew.data.get("x"), Msg.EmitterNew.data.get("y"));
			e.makeParticles(Assets.images.get(Msg.EmitterNew.data.get("graphic")),
				cast(Msg.EmitterNew.data.get("quantity"), Int), cast(Msg.EmitterNew.data.get("rotationFrames"), Int),
				cast(Msg.EmitterNew.data.get("collide"), Float));
			e.start(Msg.EmitterNew.data.get("explode"), e.life.min, e.frequency,
				Msg.EmitterNew.data.get("quantity"), e.life.max - e.life.min);
			Reg.state.emitters.add(e);
			
			NReg.live_emitters.set(Msg.EmitterNew.data.get("id2"), e);
		}
		
		if (MsgID == Msg.EmitterDelete.ID)
		{
			var ID:Int = Msg.EmitterDelete.data.get("id");
			
			var e:FlxEmitterAuto = NReg.live_emitters.get(ID);
			
			if (e != null)
			{
				Reg.state.emitters.remove(e, true);
				NReg.live_emitters.remove(ID);
				e.kill();
				e.destroy();
			}
		}
		
		if (MsgID == Msg.AnnounceGuns.ID)
		{
			if (Reg.state.wepHUD != null)
			{
				Reg.state.wepHUD.kill();
				Reg.state.wepHUD.destroy();
				Reg.state.hud.remove(Reg.state.wepHUD, true);
				Reg.state.wepHUD = new WeaponHUD(2);
				Reg.state.hud.add(Reg.state.wepHUD);
			}
			
			var map:Map<Int, Dynamic> = cast Unserializer.run(Msg.AnnounceGuns.data.get("serialized"));
			
			for (slot in map.keys())
			{
				NWeapon.addWeapon(new NWeapon(map.get(slot)), slot + 1);
			}
			for (p in Reg.state.playermap.iterator())
			{
				p.guns_arr = [];
				NWeapon.setUpWeapons(p);
				p.setGun(1);
			}
			
			Reg.state.wepBar = new WeaponBar(0, Std.int(Reg.state.wepHUD.height - WeaponHUD.PADDING));
			Reg.state.hud.add(Reg.state.wepBar);
			Reg.state.wepBar.y = Reg.state.wepHUD.y - 1;
			Reg.state.wepBar.x = Reg.state.wepHUD.x + Reg.state.wepHUD.width;
		}
		
		if (MsgID == Msg.GrantGun.ID)
		{
			var map:Map<Int, Bool> = Unserializer.run(Msg.GrantGun.data.get("slot"));
			Reg.state.player.grantedWeps = map;
			
			for (x in map.keys())
			{
				if (map.get(x) == true)
				{
					Reg.state.wepHUD.unhideIcon(x);
				}
				else
				{
					Reg.state.wepHUD.hideIcon(x);
				}
			}
		}
		
		E = null;
	}
	
	static public function cloneFromEmitter(E:FlxEmitterAuto, X:Int, Y:Int):FlxEmitterAuto
	{
		var e:FlxEmitterAuto = new FlxEmitterAuto(Reg.state.emitters, X, Y);
		
		e.bounce = E.bounce;
		e.frequency = E.frequency;
		e.gravity = E.gravity;
		e.particleDrag.copyFrom(E.particleDrag);
		e.acceleration.copyFrom(E.acceleration);
		e.endBlue = E.endBlue;
		e.endGreen = E.endGreen;
		e.endRed = E.endRed;
		e.lifespan = E.lifespan;
		e.startBlue = E.startBlue;
		e.startGreen = E.startGreen;
		e.startRed = E.startRed;
		
		e.setRotation(E.rotation.min, E.rotation.max);
		e.setScale(E.startScale.min, E.startScale.max, E.endScale.min, E.endScale.max);
		e.setSize(Std.int(E.width), Std.int(E.height));
		e.setXSpeed(E.xVelocity.min, E.xVelocity.max);
		e.setYSpeed(E.yVelocity.min, E.yVelocity.max);
		e.setAlpha(E.startAlpha.min, E.startAlpha.max, E.endAlpha.min, E.endAlpha.max);
		e.setMotion(E.angle / 0.017453293, E.distance, E.life.min,
			E.angleRange/0.017453293, E.distanceRange, E.life.max - E.life.min);
		
		return e;
	}
	
	static public function setProp(Dest:FlxEmitter, Source:FlxEmitter, Prop:String):Void
	{
		var val:Dynamic = Reflect.field(Source, Prop);
		
		if (val != null)
		{
			Reflect.setField(Dest, Prop, val);
		}
	}
	
	/**
	 * Does what it says. Also returns the target client's RTT.
	 * 
	 * @param	MsgID	The ID of the message you intend to send. It's contents at the moment of the call will be sent.
	 * @param	Channel Which channel to send through
	 * @param	Flags	ENet flags, use | to unite flags, if they don't conflict
	 * @return	Returns the target client's RTT, divide by two to obtain the traditional "ping"
	 */
	public function send(MsgID:Int, Channel:Int = 0, Flags:Int = 0):Void 
	{
		super.sendMsg(_s_id, MsgID, Channel, Flags);
	}
}