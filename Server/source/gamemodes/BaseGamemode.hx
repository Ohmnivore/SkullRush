package gamemodes; 

import enet.ENetEvent;
import flash.display.Sprite;
import gevents.ConfigEvent;
import gevents.DeathEvent;
import gevents.GenEvent;
import gevents.HurtEvent;
import gevents.InitEvent;
import gevents.JoinEvent;
import gevents.LeaveEvent;
import gevents.ReceiveEvent;
import gevents.SetTeamEvent;
import insomnia.Insomnia;
import networkobj.NScoreManager;
import plugins.BasePlugin;
import plugins.SysGravity;
import plugins.SysMeteor;

class BaseGamemode extends Sprite
{
	
	public static inline var ENV_LAVA:Int = -1;
	public static inline var ENV_FALL:Int = -2;
	public static inline var ENV_LASER:Int = -3;
	
	public static inline var TYPE_DEFAULT:String = "default";
	public static inline var TYPE_ENVIRONMENT:String = "environment";
	public static inline var TYPE_JUMPKILL:String = "jumpkill";
	public static inline var TYPE_BULLET:String = "bullet";
	
	public static var scores:NScoreManager;
	public var teams:Array<Team>;
	public var spawn_time:Int;
	
	private var init:Bool;
	
	public function new() 
	{
		super();
		
		Reg.gm = this;
		init = true;
		name = "BASE";
		scores = new NScoreManager();
		teams = [];
		
		Assets.loadConfig();
		addEventListener(ConfigEvent.CONFIG_EVENT, onConfig);
		dispatchEvent(new ConfigEvent(ConfigEvent.CONFIG_EVENT));
		
		hookEvents();
		
		dispatchEvent(new GenEvent(GenEvent.MAKE_WEAPONS));
	}
	
	private function launchPlugins():Void
	{
		Reg.plugins = new Map<String, BasePlugin>();
		
		//System plugins
		var sysm:SysMeteor = new SysMeteor();
		Reg.plugins.set(sysm.pluginName, sysm);
		var sysg:SysGravity = new SysGravity();
		Reg.plugins.set(sysg.pluginName, sysg);
		
		//Third-party plugins
		var raw:String = Assets.config.get("plugins");
		var names:Array<String> = raw.split(",");
		for (n in names)
		{
			n = StringTools.trim(n);
			
			var c:Class<Dynamic> = Type.resolveClass("plugins." + n);
			var plugin:BasePlugin = Type.createInstance(c, []);
			Reg.plugins.set(plugin.pluginName, plugin);
			plugin.onConfig(new ConfigEvent(ConfigEvent.CONFIG_EVENT));
		}
	}
	
	public function hookEvents():Void
	{
		
	}
	
	public function update(elapsed:Float):Void
	{
		dispatchEvent(new GenEvent(GenEvent.UPDATE_EVENT, elapsed));
	}
	
	public function shutdown(E:GenEvent = null):Void
	{
		BaseGamemode.scores.delete();
	}
	
	public function onSpawn(E:GenEvent):Void
	{
		
	}
	
	public function onHurt(E:HurtEvent):Void
	{
		
	}
	
	public function onDeath(E:DeathEvent):Void
	{
		
	}
	
	public function onJoin(E:JoinEvent):Void
	{
		
	}
	
	public function initPlayer(E:InitEvent):Void
	{
		
	}
	
	public function setTeam(E:SetTeamEvent):Void
	{
		
	}
	
	public function onLeave(E:LeaveEvent):Void
	{
		
	}
	
	public function onReceive(E:ReceiveEvent):Void
	{
		
	}
	
	public function makeWeapons(E:GenEvent):Void
	{
		
	}
	
	public function onConfig(e:ConfigEvent):Void
	{
		Msg.Manifest.data.set("url", Assets.config.get("manifesturl"));
		Reg.server.players_max = Std.parseInt(Assets.config.get("maxplayers"));
		Masterserver.url = Assets.config.get("masterserver");
		Reg.server.s_name = Assets.config.get("name");
		spawn_time = Std.parseInt(Assets.config.get("spawntime"));
		
		if (Assets.config.get("render") == "true")
		{
			Reg.should_render = true;
		}
		else
		{
			Reg.should_render = false;
		}
		
		if (Assets.config.get("highpriority") == "true")
		{
			Insomnia.setProcessPriority(Insomnia.P_REALTIME_PRIORITY_CLASS);
		}
		else
		{
			Insomnia.setProcessPriority(Insomnia.P_NORMAL_PRIORITY_CLASS);
		}
		
		Reg.maps = Reg.parseMaps();
		
		if (init)
		{
			launchPlugins();
		}
		
		for (p in Reg.plugins.iterator())
		{
			p.onConfig(e);
		}
		
		init = false;
	}
}