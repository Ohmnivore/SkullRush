package plugins; 

import enet.ENetEvent;
import flash.display.Sprite;
import gamemodes.BaseGamemode;
import gevents.ConfigEvent;
import gevents.DeathEvent;
import gevents.GenEvent;
import gevents.HurtEvent;
import gevents.InitEvent;
import gevents.JoinEvent;
import gevents.LeaveEvent;
import gevents.ReceiveEvent;
import gevents.SetTeamEvent;

class BasePlugin
{
	public var version:String;
	public var pluginName:String;
	
	public function new() 
	{
		if (pluginName == null)
			pluginName = "BASE";
		if (version == null)
			version = "0.0.1";
		
		hookEvents(Reg.gm);
		announcePlugin();
	}
	
	private function announcePlugin():Void
	{
		trace(pluginName + " (v" + version + ") is active.");
	}
	
	public function hookEvents(Gm:BaseGamemode):Void
	{
		
	}
	
	public function update(E:GenEvent):Void
	{
		
	}
	
	public function shutdown(E:GenEvent = null):Void
	{
		
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
		
	}
}