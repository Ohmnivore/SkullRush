package;

import cpp.vm.Lock;
import cpp.vm.Mutex;
import cpp.vm.Thread;
import enet.ENet;
import flixel.addons.weapon.FlxBullet;
import flixel.effects.particles.FlxEmitterExt;
import flixel.FlxG;
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
import haxe.Serializer;

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
	public var hud:FlxGroup;
	
	public var spect:Spectator;
	
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
		hud = new FlxGroup();
		add(hud);
		
		Reg.chatbox = new ChatBox();
		hud.add(Reg.chatbox);
		Reg.chatbox.callback = sendChatMsg;
		
		Assets.initAssets();
		loadMap("Test");
		
		m = new Mutex();
		Thread.create(thread);
	}
	
	public function sendChatMsg():Void
	{
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
		current_map = Name;
		current_map_string = Lvls.loadLVL(current_map);
		
		Msg.MapMsg.data.set("mapname", current_map);
		Msg.MapMsg.data.set("mapstring", current_map_string);
		
		OgmoLoader.loadXML(current_map_string, this);
		
		spect = new Spectator();
		add(spect);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}
	
	public function thread():Void
	{
		while (true)
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
		m.acquire();
		super.update();
		
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
		
		FlxG.collide(tocollide, collidemap);
		FlxG.collide(bullets, collidemap, bulletCollide);
		
		var arr:Array<String> = [];
		
		//try
		//{
			//Reg.server.poll();
			for (p in Reg.server.playermap.iterator())
			{
				arr.push(p.s_serialize());
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
			}
		//}
		
		//catch (e:Dynamic)
		//{
			//
		//}
		
		framebuffer += FlxG.elapsed;
		
		m.release();
	}
	
	private function bulletCollide(Bullet:FlxBullet, Tilemap:FlxTilemap):Void
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
			var pl:Player = cast (p, Player);
			
			var v:FlxVector = new FlxVector(1, 0);
			
			v.rotateByRadians(FlxAngle.angleBetween(Bullet, pl));
			
			var dist_coeff:Float = (100 - FlxMath.distanceBetween(pl, Bullet)) / 100;
			if (dist_coeff < 0) dist_coeff = 0;
			
			pl.velocity.x += v.x * 300 * dist_coeff;
			pl.velocity.y += v.y * 300 * dist_coeff;
		}
		
		Bullet.kill();
	}
}