package gamemodes; 

import enet.ENetEvent;
import flash.display.Sprite;
import gevents.ConfigEvent;
import gevents.DeathEvent;
import gevents.HurtEvent;
import gevents.JoinEvent;
import gevents.LeaveEvent;
import gevents.ReceiveEvent;
import networkobj.NScoreManager;

class BaseGamemode extends Sprite
{
	
	public static inline var LAVA:Int = -1;
	public static inline var FALL:Int = -2;
	public static inline var LASER:Int = -3;
	
	public static inline var DEFAULT:Int = 0;
	public static inline var ENVIRONMENT:Int = 1;
	public static inline var JUMPKILL:Int = 2;
	public static inline var BULLET:Int = 3;
	
	public static var scores:NScoreManager;
	public var teams:Array<Team>;
	public var spawn_time:Int;
	
	public function new() 
	{
		super();
		
		name = "BASE";
		scores = new NScoreManager();
		teams = [];
		
		addEventListener(ConfigEvent.CONFIG_EVENT, onConfig, false, 0);
		Assets.loadConfig();
		dispatchEvent(new ConfigEvent(ConfigEvent.CONFIG_EVENT));
		
		//for each (var plug:BasePlugin in ServerInfo.pl)
		//{
			//plug.init();
		//}
	}
	
	public function update(elapsed:Float):Void
	{
		
	}
	
	public function shutdown():Void
	{
		BaseGamemode.scores.delete();
	}
	
	public function onHurt(e:HurtEvent):Void
	{
		
	}
	
	public function onDeath(e:DeathEvent):Void
	{
		
	}
	
	public function onJoin(e:JoinEvent):Void
	{
		
	}
	
	public function initPlayer(P:Player):Void
	{
		
	}
	
	public function setTeam(P:Player, T:Team):Void
	{
		
	}
	
	public function onLeave(e:LeaveEvent):Void
	{
		
	}
	
	public function onReceive(e:ReceiveEvent):Void
	{
		
	}
	
	public function onConfig(e:ConfigEvent):Void
	{
		Msg.Manifest.data.set("url", Assets.config.get("manifesturl"));
		Reg.server.players_max = Std.parseInt(Assets.config.get("maxplayers"));
		Masterserver.url = Assets.config.get("masterserver");
		Reg.server.s_name = Assets.config.get("name");
		spawn_time = Std.parseInt(Assets.config.get("spawntime"));
		
		Reg.maps = Reg.parseMaps();
	}
}