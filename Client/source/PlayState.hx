package;

import cpp.vm.Mutex;
import cpp.vm.Thread;
import enet.ENet;
import flash.utils.ByteArray;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.weapon.FlxBullet;
import flixel.effects.particles.FlxEmitterExt;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxAngle;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRect;
import flixel.util.FlxVector;
import haxe.io.Bytes;
import haxe.macro.Expr.Function;
import mloader.Loader.LoaderErrorType;
import networkobj.NReg;
import networkobj.NScoreManager;
import openfl.Vector.Vector;
import ui.Spawn;
import ext.FlxWeaponExt;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	public var framebuffer:Float = 0;
	public var current_map:String;
	
	public var collidemap:FlxTilemap;
	public var background:FlxGroup;
	public var maps:FlxGroup;
	public var under_players:FlxGroup;
	public var bullets:FlxGroup;
	public var tocollide:FlxGroup;
	public var over_players:FlxGroup;
	public var players:FlxGroup;
	public var emitters:FlxGroup;
	public var ent:FlxGroup;
	public var hud:FlxGroup;
	public var scores:NScoreManager;
	
	public var player:Player;
	public var playermap:Map<Int, Player>;
	
	public var ping_text:FlxText;
	public var teams:Array<Team>;
	
	public var player_just_died:Bool = true;
	
	public var m:Mutex;
	
	public var wepHUD:WeaponHUD;
	public var wepBar:WeaponBar;
	public var mouseSprite:FlxCrosshairs;
	
	public var cross:FlxCrosshairs;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		SkullClient.initClient();
		
		persistentDraw = true;
		persistentUpdate = true;
		
		// Set a background color
		FlxG.cameras.bgColor = 0xffB8B8B8;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		FlxG.mouse.load("shared/images/blank.png");
		//FlxG.mouse.load("shared/images/crosshairs.png", 0.5, 0, 0);
		#end
		
		super.create();
		Reg.state = this;
		playermap = new Map<Int, Player>();
		
		background = new FlxGroup();
		add(background);
		maps = new FlxGroup();
		add(maps);
		under_players = new FlxGroup();
		add(under_players);
		//bullets = new FlxGroup();
		//add(bullets);
		tocollide = new FlxGroup();
		add(tocollide);
		players = new FlxGroup();
		tocollide.add(players);
		over_players = new FlxGroup();
		add(over_players);
		emitters = new FlxGroup();
		add(emitters);
		bullets = new FlxGroup();
		add(bullets);
		ent = new FlxGroup();
		add(ent);
		tocollide.add(ent);
		hud = new FlxGroup();
		add(hud);
		scores = new NScoreManager();
		
		//trailArea = new FlxTrailArea(0, 0, FlxG.width, FlxG.height);
		//under_players.add(trailArea);
		//
		//hud.add(new FlxCrosshairs());
		
		Reg.chatbox = new ChatBox();
		hud.add(Reg.chatbox);
		Reg.chatbox.callback = sendChatMsg;
		
		Reg.announcer = new Announcer();
		hud.add(Reg.announcer);
		
		ping_text = new FlxText(0, 0, 70, "0");
		ping_text.scrollFactor.set();
		hud.add(ping_text);
		switch (Assets.config.get("showping"))
		{
			case "true":
				ping_text.visible = true;
			case "false":
				ping_text.visible = false;
		}
		
		wepHUD = new WeaponHUD(2);
		hud.add(wepHUD);
		//wepBar = new WeaponBar(2);
		//hud.add(wepBar);
		
		Assets.initAssets();
		Thread.create(thread);
		
		m = new Mutex();
	}
	
	public function sendChatMsg():Void
	{
		var t:String = Reg.chatbox.text.text;
		Reg.chatbox.text.text = "";
		
		t = StringTools.trim(t);
		
		if (t.length > 0)
		{
			Msg.ChatToServer.data.set("message", t);
			
			Reg.client.send(Msg.ChatToServer.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
	}
	
	public function thread():Void
	{
		while (SkullClient.execute)
		{
			try
			{
				m.acquire();
				Reg.client.poll();
				m.release();
				Sys.sleep(0.001);
			}
			catch (e:Dynamic)
			{
				
			}
		}
	}
	
	public function onLoaded():Void
	{
		trace("Loaded external assets.");
		
		Msg.PlayerInfo.data.set("name", Assets.config.get("name"));
		Msg.PlayerInfo.data.set("team", Assets.config.get("team"));
		
		Reg.client.send(Msg.PlayerInfo.ID, 1, ENet.ENET_PACKET_FLAG_RELIABLE);
	}
	
	public function loadMap(MapName:String, MapString:String):Void
	{
		for (m in maps.members.iterator())
		{
			m.kill();
			maps.remove(m, true);
			m.destroy();
		}
		
		if (collidemap != null)
		{
			collidemap.kill();
			collidemap.destroy();
		}
		
		if (NReg.HUDS != null)
		{
			for (i in NReg.HUDS.keys())
			{
				//trace("Delete ", i);
				var h:FlxText = NReg.HUDS.get(i);
				hud.remove(h, true);
				//h.kill();
				if (NReg.HUDS.exists(i))
					NReg.HUDS.remove(i);
				//h.destroy();
			}
			for (k in NReg.sprites.keys())
			{
				var s:FlxSprite = NReg.HUDS.get(k);
				//ent.remove(s, true);
				//s.kill();
				//NReg.sprites.remove(s);
				//s.destroy();
				//if (s != null)
					//s.kill();
					//s.destroy();
			}
		}
		
		current_map = MapName;
		
		OgmoLoader.initTilemaps();
		OgmoLoader.loadXML(MapString, this);
		//SkullClient.initClient();
		
		//if (trailArea != null)
		//{
			//under_players.clear();
			//trailArea.kill();
		//}
		//trailArea = new FlxTrailArea(0, 0, FlxG.width, FlxG.height, 0.5, 2, false, true);
		//under_players.add(trailArea);
		hud.clear();
		//hud.add(new FlxCrosshairs());
		cross = new FlxCrosshairs();
		cross.addToGroup(hud);
		
		ping_text = new FlxText(0, 0, 70, "0");
		ping_text.scrollFactor.set();
		hud.add(ping_text);
		switch (Assets.config.get("showping"))
		{
			case "true":
				ping_text.visible = true;
			case "false":
				ping_text.visible = false;
		}
		
		//trailArea.x = collidemap.x - FlxG.width / 2;
		//trailArea.y = collidemap.y - FlxG.height / 2;
		//trailArea.setSize(collidemap.width + FlxG.width, collidemap.height + FlxG.height);
		
		for (p in playermap.iterator())
		{
			var pl:Player = p;
			
			for (c in pl.guns_arr)
			{
				var w:FlxWeaponExt = c;
				var bounds:FlxRect = Reg.state.collidemap.getBounds();
				bounds.x -= FlxG.width / 2;
				bounds.width += FlxG.width;
				bounds.y -= FlxG.height / 2;
				bounds.height += FlxG.height;
				w.setBulletBounds(bounds);
				
				//if (pl.ID != player.ID)
				//{
				//w.setFireRate(0);w
				//}
			}
		}
	}
	
	public function downloadError(e:LoaderErrorType):Void
	{
		switch (e)
		{
			case LoaderErrorType.Data:
				
			
			case LoaderErrorType.Format:
				
			
			case LoaderErrorType.IO:
				
			
			case LoaderErrorType.Security:
				
		}
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		//Reg.client.updateS();
		
		if (FlxG.keys.justPressed.ESCAPE && !Menu.OPENED)
		{
			if (subState == null)
			{
				openSubState(new Menu());
			}
			
			else
			{
				subState.openSubState(new Menu());
			}
		}
		
		if (FlxG.keys.justPressed.I)
		{
			Reg.client.s.sendAll(Bytes.ofString("get_info"));
		}
		
		scores.update();
		
		m.acquire();
		
		super.update();
		
		Reg.client.updatePingText();
		
		FlxG.collide(tocollide, maps); //collidemap
		FlxG.collide(bullets, maps, bulletCollide); //collidemap
		FlxG.overlap(bullets, players, bulletCollidePl);
		FlxG.collide(emitters, maps); //collidemap
		
		if (player != null)
			updatePlayer();
		
		if (FlxG.keys.justPressed.ENTER)
		{
			Reg.chatbox.toggle();
		}
		
		m.release();
	}
	
	private function updatePlayer():Void
	{
		if (FlxG.keys.justPressed.ONE)
		{
			player.current_weap = 1;
		}
		
		if (FlxG.keys.justPressed.TWO)
		{
			player.current_weap = 2;
		}
		
		if (FlxG.keys.justPressed.THREE)
		{
			player.current_weap = 3;
		}
		
		if (FlxG.keys.justPressed.FOUR)
		{
			player.current_weap = 4;
		}
		
		if (FlxG.keys.justPressed.FIVE)
		{
			player.current_weap = 5;
		}
		
		if (player.health <= 0 && player_just_died)
		{
			//FlxG.camera.focusOn(new FlxPoint(player.x, player.y));
			FlxG.camera.target = new FlxObject(player.x, player.y);
			
			player_just_died = false;
		}
		
		if (player.health > 0)
		{
			FlxG.camera.target = player;
			
			player_just_died = true;
		}
		
		if (!Reg.chatbox.opened && subState == null)
		{
			//Move right
			if (FlxG.keys.pressed.D)
			{
				player.move_right = true;
				player.velocity.x += 20;
			}
			else
			{
				player.move_right = false;
			}
			
			//Move left
			if (FlxG.keys.pressed.A)
			{
				player.move_left = true;
				player.velocity.x += -20;
			}
			else
			{
				player.move_left = false;
			}
			
			//Jump
			if (FlxG.keys.pressed.W)
			{
				player.move_jump = true;
				
				if (player.isTouching(FlxObject.ANY))
				{
					player.velocity.y = -280;
				}
			}
			else
			{
				player.move_jump = false;
			}
			
			if (FlxG.keys.justPressed.S)
			{
				player.dash_down = true;
			}
			else
			{
				player.dash_down = false;
			}
			
			if (FlxG.keys.justPressed.Q)
			{
				player.dash_left = true;
			}
			else
			{
				player.dash_left = false;
			}
			
			if (FlxG.keys.justPressed.E)
			{
				player.dash_right = true;
			}
			else
			{
				player.dash_right = false;
			}
			
			//Shoot
			if (FlxG.mouse.pressed && player.health > 0)
			{
				player.shoot = true;
				//player.fire();
			}
			else
			{
				player.shoot = false;
			}
			
			if (FlxG.mouse.screenX > FlxG.width / 2)
			{
				player.isRight = true;
			}
			else
			{
				player.isRight = false;
			}
			
			//player.a = FlxAngle.angleBetweenMouse(player, true);
			var pos:FlxPoint = new FlxPoint(FlxG.mouse.x - cross.width/2, FlxG.mouse.y - cross.height/2);
			player.a = FlxAngle.angleBetweenPoint(player, pos, true);
			//player.a = FlxAngle.angleBetween(player, cross, true);
			
			//if (framebuffer > 0.03)
			//{
				Msg.PlayerInput.data.set("serialized", player.c_serialize());
				Reg.client.send(Msg.PlayerInput.ID, 0, ENet.ENET_PACKET_FLAG_UNSEQUENCED);
				//Reg.client.send(Msg.PlayerInput.ID, 0);
			//}
			
			framebuffer += FlxG.elapsed;
		}
	}
	
	private function bulletCollide(Bullet:FlxBullet, Tilemap:Dynamic):Void
	{
		var wep_ext:FlxWeaponExt = cast Bullet._weapon;
		
		if (!wep_ext.template.ignoreCollisions)
			Bullet.kill();
	}
	
	private function bulletCollidePl(Bullet:FlxBullet, Pl:Player):Void
	{
		var wep_ext:FlxWeaponExt = cast Bullet._weapon;
		
		if (!wep_ext.template.ignoreCollisions)
		{
			if (Pl.ID != Bullet._weapon.parent.ID)
			{
				Bullet.kill();
			}
		}
	}
}