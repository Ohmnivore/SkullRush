package ;
import enet.Client;
import enet.ENet;
import enet.ENetEvent;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import haxe.Unserializer;
import hxudp.UdpSocket;
import networkobj.NReg;
import networkobj.NTemplate;
import networkobj.NTimer;
import haxe.io.Bytes;

/**
 * ...
 * @author Ohmnivore
 */
class SkullClient extends Client
{
	public var rIP:String;
	public var rPort:Int;
	private var _s_id:Int;
	
	public function new(IP:String = "", Port:Int = 6666)
	{
		super(IP, Port, 3, 1);
		
		rIP = IP;
		rPort = Port;
		
		Msg.addToHost(this);
		
		var s:UdpSocket = UdpSocket();
		s.create();
		s.setNonBlocking(true);
		s.bind(1945);
		s.setEnableBroadcast(true);
		
		s.connect("192.168.0.255", 1945);
		s.sendAll(Bytes.ofString("request"));
	}
	
	public function updatePingText():Void
	{
		if (_s_id > 0)
			Reg.state.ping_text.text = Std.string(ENet.getPeerPing(_s_id));
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
			NReg.HUDS.set(Msg.NewLabel.data.get("id"), t);
			
			Reg.state.hud.add(t);
		}
		
		if (MsgID == Msg.SetLabel.ID)
		{
			var t:FlxText = NReg.HUDS.get(Msg.SetLabel.data.get("id"));
			
			t.text = Msg.SetLabel.data.get("text");
			t.color = Msg.SetLabel.data.get("color");
		}
		
		if (MsgID == Msg.NewCounter.ID)
		{
			var t:FlxText = new FlxText(Msg.NewCounter.data.get("x"),
												Msg.NewCounter.data.get("y"),
												FlxG.width,
												Msg.NewCounter.data.get("base") + ": 0",
												12);
			t.scrollFactor.set();
			NReg.HUDS.set(Msg.NewCounter.data.get("id"), t);
			
			Reg.state.hud.add(t);
		}
		
		if (MsgID == Msg.SetCounter.ID)
		{
			var t:FlxText = NReg.HUDS.get(Msg.SetCounter.data.get("id"));
			
			t.text = Msg.SetCounter.data.get("base") + ": " + Msg.SetCounter.data.get("count");
			t.color = Msg.SetCounter.data.get("color");
		}
		
		if (MsgID == Msg.NewTimer.ID)
		{
			var t:NTimer = new NTimer(Msg.NewTimer.data.get("base"),
											Msg.NewTimer.data.get("x"),
											Msg.NewTimer.data.get("y"));
			t.scrollFactor.set();
			NReg.HUDS.set(Msg.NewTimer.data.get("id"), t);
			
			Reg.state.hud.add(t);
		}
		
		if (MsgID == Msg.SetTimer.ID)
		{
			var t:NTimer = cast(NReg.HUDS.get(Msg.SetTimer.data.get("id")), NTimer);
			t.base = Msg.SetTimer.data.get("base");
			t.color = Msg.SetTimer.data.get("color");
			t.status = Msg.SetTimer.data.get("status");
			t.count = Msg.SetTimer.data.get("count");
		}
		
		if (MsgID == Msg.DeleteHUD.ID)
		{
			var t:FlxText = NReg.HUDS.get(Msg.DeleteHUD.data.get("id"));
			
			NReg.HUDS.remove(Msg.DeleteHUD.data.get("id"));
			
			Reg.state.hud.remove(t, true);
			
			t.kill();
			t.destroy();
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
			
			s.x = Msg.UpdateSprite.data.get("x");
			s.y = Msg.UpdateSprite.data.get("y");
			s.velocity.x = Msg.UpdateSprite.data.get("velocity.x");
			s.velocity.y = Msg.UpdateSprite.data.get("velocity.y");
		}
		
		if (MsgID == Msg.DeleteSprite.ID)
		{
			var s:FlxSprite = NReg.sprites.get(Msg.DeleteSprite.data.get("id"));
			
			NReg.sprites.remove(Msg.DeleteSprite.data.get("id"));
			Reg.state.ent.remove(s, true);
			
			//s.kill();
			//s.destroy();
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