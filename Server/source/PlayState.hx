package;

import cpp.vm.Lock;
import cpp.vm.Mutex;
import cpp.vm.Thread;
import enet.ENet;
import entities.Spawn;
import flixel.addons.tile.FlxRayCastTilemap;
import flixel.addons.weapon.FlxBullet;
import flixel.effects.particles.FlxEmitterExt;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.text.FlxTextField;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxAngle;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxVector;
import gamemodes.BaseGamemode;
import gamemodes.DefaultHooks;
import gamemodes.FFA;
import gamemodes.CTF;
import gevents.ConfigEvent;
import haxe.Serializer;
import haxe.xml.Fast;
import networkobj.NReg;
import networkobj.NTimer;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	public var framebuffer:Float = 0;
	
	public var current_map:String;
	public var current_map_string:String;
	
	public var collidemap:FlxTilemap;
	public var maps:FlxGroup;
	public var under_players:FlxGroup;
	public var bullets:FlxGroup;
	public var tocollide:FlxGroup;
	public var over_players:FlxGroup;
	public var players:FlxGroup;
	public var emitters:FlxGroup;
	public var ent:FlxGroup;
	public var hud:FlxGroup;
	
	public var spect:Spectator;
	
	public var m:Mutex;
	
	public var spawns:Array<Spawn>;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		// Set a background color
		FlxG.cameras.bgColor = 0xffB8B8B8;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		#end
		
		super.create();
		Reg.state = this;
		spawns = [];
		NReg.resetReg();
		
		maps = new FlxGroup();
		add(maps);
		under_players = new FlxGroup();
		add(under_players);
		bullets = new FlxGroup();
		add(bullets);
		tocollide = new FlxGroup();
		add(tocollide);
		players = new FlxGroup();
		tocollide.add(players);
		over_players = new FlxGroup();
		add(over_players);
		emitters = new FlxGroup();
		add(emitters);
		ent = new FlxGroup();
		add(ent);
		tocollide.add(ent);
		hud = new FlxGroup();
		add(hud);
		
		Reg.chatbox = new ChatBox();
		hud.add(Reg.chatbox);
		Reg.chatbox.callback = sendChatMsg;
		
		Reg.announcer = new Announcer();
		hud.add(Reg.announcer);
		
		Assets.initAssets();
		loadMap(Reg.mapname);
		
		Reg.shutdown = false;
		m = new Mutex();
		Thread.create(thread);
		
		Admin.hookCommands();
	}
	
	public function sendChatMsg():Void
	{
		//var res:FlxPoint = new FlxPoint();
		//trace(collidemap.ray(new FlxPoint(10, 10), new FlxPoint(50, 50)));
		var t:String = Reg.chatbox.text.text;
		Reg.chatbox.text.text = "";
		
		t = StringTools.trim(t);
		
		if (t.length > 0)
		{
			t = "Server: " + t;
			
			//Send to all
			Msg.ChatToClient.data.set("id", 0);
			Msg.ChatToClient.data.set("message", t);
			Msg.ChatToClient.data.set("color", 0xffff0000);
			
			for (ID in Reg.server.peermap.iterator())
			{
				Reg.server.sendMsg(ID, Msg.ChatToClient.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
			}
			
			//Add to local chatbox
			Reg.chatbox.addMsg(t, Msg.ChatToClient.data.get("color"));
		}
	}
	
	public function loadMap(Name:String):Void
	{
		if (Reg.gm != null)
		{
			Reg.gm.shutdown();
			//spect.destroy();
			//remove(spect, true);
			//spect.kill();
			//spect.destroy();
		}
		
		current_map = Name;
		current_map_string = Lvls.loadLVL(current_map);
		
		var xml = Xml.parse(current_map_string);
		var fast = new Fast(xml.firstElement());
		
		Reg.gm = Type.createInstance(Type.resolveClass("gamemodes." + fast.att.Gamemode), []);
		Reg.gm.dispatchEvent(new ConfigEvent(ConfigEvent.CONFIG_EVENT));
		var gm:String = Type.getClassName(Type.getClass(Reg.gm));
		
		Masterserver.setMapGM(current_map, fast.att.Gamemode);
		
		Msg.MapMsg.data.set("mapname", current_map);
		Msg.MapMsg.data.set("mapstring", current_map_string);
		
		OgmoLoader.loadXML(current_map_string, this);
		
		spect = new Spectator();
		add(spect);
		//trace("pl");
		for (i in Reg.server.playermap.keys())
		{
			var p:Player = Reg.server.playermap.get(i);
			
			//var s:Spawn = Spawn.findSpawn(p.team);
			var p_new:Player;
			//if (s != null)
				//p_new = new Player(p.ID, p.name, s.x, s.y);
			//else
				p_new = new Player(p.ID, p.name, 50, 50);
			//p_new.team = 0;
			Reg.gm.setTeam(p_new, Reg.gm.teams[0]);
			//p_new.setColor(p.header.color, p.graphicKey);
			
			Reg.server.playermap.set(i, p_new);
			
			Reg.server.sendMsg(p_new.ID, Msg.MapMsg.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
			
			Msg.SpawnConfirm.data.set("color", p_new.header.color);
			Msg.SpawnConfirm.data.set("graphic", p_new.graphicKey);
			Reg.server.sendMsg(p_new.ID, Msg.SpawnConfirm.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
			
			Reg.gm.initPlayer(p_new);
		}
		
		trace('Loaded map $current_map and gamemode $gm.');
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
		
		m.acquire;
		Reg.shutdown = true;
		m.release;
		
		current_map = null;
		current_map_string = null;
		m = null;
		spawns = null;
	}
	
	public function thread():Void
	{
		while (!Reg.shutdown)
		{
			try
			{
				m.acquire();
				Reg.server.poll();
				m.release();
				Sys.sleep(0.001);
			}
			catch (e:Dynamic)
			{
				
			}
		}
	}
	
	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		if (!Reg.shutdown)
		{
		Masterserver.updateHeartBeat(FlxG.elapsed);
		
		m.acquire();
		
		super.update();
		
		if (Reg.gm != null)
		{
			if (FlxG.keys.justPressed.C)
			{
				Assets.loadConfig();
				
				Reg.gm.dispatchEvent(new ConfigEvent(ConfigEvent.CONFIG_EVENT));
			}
			
			if (FlxG.keys.justPressed.R)
			{
				Admin.reloadMap();
			}
			
			//Reg.gm.scores.checkToggle();
			BaseGamemode.scores.update();
			Reg.gm.update(FlxG.elapsed);
		}
		
		if (FlxG.keys.justPressed.ENTER)
		{
			Reg.chatbox.toggle();
			
			if (Reg.chatbox.opened)
			{
				spect.active = false;
			}
			
			else
			{
				spect.active = true;
			}
		}
		
		var arr:Array<String> = [];
		
		try
		{
			//Reg.server.poll();
			for (p in Reg.server.playermap.iterator())
			{
				if (p != null)
				{
					if (p.velocity != null)
					{
						arr.push(p.s_serialize());
					}
				}
			}
			
			Msg.PlayerOutput.data.set("serialized", Serializer.run(arr));
			
			if (framebuffer > 0.03)
			{
				for (p in Reg.server.playermap.iterator())
				{
					//Reg.server.sendMsg(p.ID,
										//Msg.PlayerOutput.ID, 0);
					
					Reg.server.sendMsg(p.ID,
										Msg.PlayerOutput.ID, 0, ENet.ENET_PACKET_FLAG_UNSEQUENCED);
				}
				
				for (s in NReg.sprites)
				{
					s.sendUpdate();
				}
			}
		}
		
		catch (e:Dynamic)
		{
			
		}
		
		framebuffer += FlxG.elapsed;
		
		m.release();
		
		Reg.server.updateS();
		}
	}
}