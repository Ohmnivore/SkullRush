package;

import cpp.vm.Mutex;
import cpp.vm.Thread;
import enet.ENet;
import flash.utils.ByteArray;
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
import flixel.util.FlxVector;
import haxe.io.Bytes;
import haxe.macro.Expr.Function;
import mloader.Loader.LoaderErrorType;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	public var framebuffer:Float = 0;
	public var current_map:String;
	
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
	
	public var player:Player;
	public var playermap:Map<Int, Player>;
	
	public var ping_text:FlxText;
	
	public var m:Mutex;
	
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
		playermap = new Map<Int, Player>();
		
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
		
		ping_text = new FlxText(0, 0, 70, "0");
		ping_text.scrollFactor.set();
		over_players.add(ping_text);
		
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
		current_map = MapName;
		OgmoLoader.loadXML(MapString, this);
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
		Reg.client.updateS();
		
		if (FlxG.keys.justPressed.ESCAPE)
		{
			openSubState(new Menu());
		}
		
		if (FlxG.keys.justPressed.I)
		{
			Reg.client.s.sendAll(Bytes.ofString("get_info"));
		}
		
		m.acquire();
		
		super.update();
		
		Reg.client.updatePingText();
		
		FlxG.collide(tocollide, collidemap);
		FlxG.collide(bullets, collidemap, bulletCollide);
		FlxG.collide(bullets, players, bulletCollide);
		
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
		if (!Reg.chatbox.opened)
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
			
			//Shoot
			if (FlxG.mouse.pressed && player.health > 0)
			{
				player.shoot = true;
				player.fire();
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
			
			player.a = FlxAngle.angleBetweenMouse(player, true);
			
			if (framebuffer > 0.03)
			{
				Msg.PlayerInput.data.set("serialized", player.c_serialize());
				Reg.client.send(Msg.PlayerInput.ID, 0, ENet.ENET_PACKET_FLAG_UNSEQUENCED);
				//Reg.client.send(Msg.PlayerInput.ID, 0);
			}
			
			framebuffer += FlxG.elapsed;
		}
	}
	
	private function bulletCollide(Bullet:FlxBullet, Tilemap:Dynamic):Void
	{
		var emitter:FlxEmitterExt = new FlxEmitterExt(Bullet.x + Bullet.width / 2,
													Bullet.y + Bullet.height / 2);
		
		emitters.add(emitter);
		
		emitter.setRotation(0, 0);
		emitter.setMotion(0, 17, 1, 360, 25, 1);
		emitter.setAlpha(1, 1, 0, 0);
		emitter.setColor(0xffE69137, 0xffFFFB17);
		emitter.setXSpeed(150, 150);
		emitter.setYSpeed(150, 150);
		emitter.makeParticles(Assets.getImg("assets/images/explosionparticle.png"), 35);
		
		emitter.start(true, 0.9, 0, 35);
		
		for (p in players.members)
		{
			//var pl:Player = cast (p, Player);
			//
			//var v:FlxVector = new FlxVector(1, 0);
			//
			//v.rotateByRadians(FlxAngle.angleBetween(Bullet, pl));
			//
			//var dist_coeff:Float = (100 - FlxMath.distanceBetween(pl, Bullet)) / 100;
			//if (dist_coeff < 0) dist_coeff = 0;
			//
			//pl.velocity.x += v.x * 300 * dist_coeff;
			//pl.velocity.y += v.y * 300 * dist_coeff;
		}
		
		Bullet.kill();
	}
}