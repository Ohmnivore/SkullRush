package ;
import enet.ENet;
import flixel.FlxG;
import flixel.util.FlxTimer;
import gevents.ConfigEvent;
import networkobj.NReg;
import networkobj.NTimer;
import plugins.BasePlugin;
import plugins.SysMeteor;
import plugins.SysGravity;

/**
 * ...
 * @author Ohmnivore
 */
class Admin
{
	static public var oldTimerStatus:Map<Int, Int>;
	
	static public function hookCommands():Void
	{
		oldTimerStatus = new Map<Int, Int>();
		
		FlxG.console.registerFunction("nextmap", nextMap);
		FlxG.console.registerFunction("reloadmap", reloadMap);
		FlxG.console.registerFunction("reloadconfig", reloadConfig);
		FlxG.console.registerFunction("getversion", getVersion);
		FlxG.console.registerFunction("localip", getIP);
		FlxG.console.registerFunction("portforward", portForward);
		FlxG.console.registerFunction("portremove", portRemove);
		FlxG.console.registerFunction("curmap", curMap);
		FlxG.console.registerFunction("stopTimers", stopTimers);
		FlxG.console.registerFunction("startTimers", startTimers);
		FlxG.console.registerFunction("rain", rainHell);
		FlxG.console.registerFunction("stopgrav", stopGrav);
		
		FlxG.console.addCommand(["setmap"], setMap, "Set map, ex: setmap Test", "Map name", 1, -1);
		FlxG.console.addCommand(["stopplugin"], stopPlugin,
			"Stop a running non-system plugin, ex: stopplugin Welcomer", "Plugin name", 1, -1);
		FlxG.console.addCommand(["startplugin"], startPlugin,
			"Start a plugin, ex: startplugin Welcomer", "Plugin name", 1, -1);
	}
	
	static public function startPlugin(Name:String):Void
	{
		if (Reg.plugins.exists(Name))
		{
			trace("Plugin " + Name + " already active.");
		}
		else
		{
			var c:Class<Dynamic>;
			try
			{
				c = Type.resolveClass("plugins." + Name);
			}
			catch (e:Dynamic)
			{
				trace("No such plugin: " + Name);
				return;
			}
			var plugin:BasePlugin = Type.createInstance(c, []);
			Reg.plugins.set(plugin.pluginName, plugin);
			plugin.onConfig(new ConfigEvent(ConfigEvent.CONFIG_EVENT));
		}
	}
	
	static public function stopPlugin(Name:String):Void
	{
		if (Reg.plugins.exists(Name))
		{
			if (Name.substr(0, 3) == "Sys")
			{
				trace("Can't stop system plugin: " + Name);
			}
			else
			{
				var plugin:BasePlugin = Reg.plugins.get(Name);
				
				plugin.shutdown();
				
				Reg.plugins.remove(Name);
			}
		}
		else
		{
			trace("No such active plugin: " + Name);
		}
	}
	
	static public function reloadPlugins():Void
	{
		//Third-party plugins
		var raw:String = Assets.config.get("plugins");
		var names:Array<String> = raw.split(",");
		for (n in names)
		{
			n = StringTools.trim(n);
			
			if (!Reg.plugins.exists(n))
			{
				var c:Class<Dynamic>;
				try
				{
					c = Type.resolveClass("plugins." + n);
				}
				catch (e:Dynamic)
				{
					trace("No such plugin: " + n);
					return;
				}
				var plugin:BasePlugin = Type.createInstance(c, []);
				Reg.plugins.set(plugin.pluginName, plugin);
				plugin.onConfig(new ConfigEvent(ConfigEvent.CONFIG_EVENT));
			}
		}
	}
	
	static public function rainHell():Void
	{
		var sysm:SysMeteor = cast Reg.plugins.get("SysMeteor");
		sysm.rainHell();
	}
	
	static public function stopGrav():Void
	{
		var sysg:SysGravity = cast Reg.plugins.get("SysGravity");
		sysg.ruinPhysics();
	}
	
	static public function stopTimers():Void
	{
		for (t in NReg.timers.iterator())
		{
			oldTimerStatus.set(t.ID, t.status);
			t.setTimer(Std.int(t.count), NTimer.STOPPED);
			
			trace("Stopped timer with base: " + t.base);
		}
	}
	
	static public function startTimers():Void
	{
		for (t in NReg.timers.iterator())
		{
			if (oldTimerStatus.exists(t.ID))
			{
				t.setTimer(Std.int(t.count), oldTimerStatus.get(t.ID));
				oldTimerStatus.remove(t.ID);
				
				trace("Started timer with base: " + t.base);
			}
		}
	}
	
	static public function curMap():Void
	{
		trace("Current map is: " + Reg.state.current_map);
	}
	
	static public function portRemove():Void
	{
		PortForward.portRemove(Reg.server.port, true);
	}
	
	static public function portForward():Void
	{
		PortForward.portForward(Reg.server.port, true);
	}
	
	static public function getIP():Void
	{
		trace("Local IP: " + ENet.getLocalIP());
	}
	
	static public function getVersion():Void
	{
		trace("Version: " + Assets.config.get("version"));
	}
	
	static public function nextMap():Void
	{
		Reg.map_index++;
		
		if (Reg.map_index >= Reg.maps.length)
			Reg.map_index = 0;
		
		Reg.mapname = Reg.maps[Reg.map_index];
		
		oldTimerStatus = new Map<Int, Int>();
		FlxTimer.manager.clear();
		Reg.reLaunch();
	}
	
	static public function setMap(Name:String):Void
	{
		var found:Bool = false;
		var i:Int = 0;
		for (m in Reg.maps)
		{
			if (m == Name)
			{
				found = true;
				break;
			}
			
			i++;
		}
		
		if (found)
		{
			trace('Map $Name was found in the map rotation. It will continue from there.');
			Reg.map_index = i;
			
			Reg.mapname = Reg.maps[Reg.map_index];
		}
		else
		{
			trace('Map $Name was not found in the map rotation. It will continue from where the rotation was interrupted.');
			Reg.mapname = Name;
		}
		
		oldTimerStatus = new Map<Int, Int>();
		FlxTimer.manager.clear();
		Reg.reLaunch();
	}
	
	public static function reloadMap():Void
	{
		oldTimerStatus = new Map<Int, Int>();
		FlxTimer.manager.clear();
		Reg.reLaunch();
	}
	
	public static function reloadConfig():Void
	{
		Assets.loadConfig();
		
		Reg.gm.dispatchEvent(new ConfigEvent(ConfigEvent.CONFIG_EVENT));
		
		trace("Loaded configs.");
	}
	
}