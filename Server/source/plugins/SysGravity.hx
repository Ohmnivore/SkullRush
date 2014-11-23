package plugins;

import entities.MeteoriteStrike.Meteor;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;
import gamemodes.BaseGamemode;
import gevents.GenEvent;
import networkobj.NLabel;
import gamemodes.DefaultHooks;
import ext.FlxMarkup;
import gevents.RespawnEvent;

/**
 * ...
 * @author ...
 */
class SysGravity extends BasePlugin
{
	public var gravityWorking:Bool = true;
	
	private var msg:NLabel;
	
	public function new() 
	{
		pluginName = "SysGravity";
		version = "0.0.1";
		
		super();
	}
	
	override public function activate():Void 
	{
		super.activate();
		
		ruinPhysics();
	}
	
	override public function hookEvents(Gm:BaseGamemode):Void 
	{
		super.hookEvents(Gm);
		
		Gm.addEventListener(RespawnEvent.RESPAWN_EVENT, onSpawn, false, 10);
	}
	
	override public function onSpawn(E:GenEvent):Void 
	{
		super.onSpawn(E);
		
		var p:Player = cast E.info;
		
		if (gravityWorking)
		{
			p.acceleration.y = PlayerBase.gravity;
		}
		else
		{
			p.acceleration.y = 50;
		}
	}
	
	public function ruinPhysics(Timer:FlxTimer = null):Void
	{
		announceRuin();
		new FlxTimer(6, ruinGravity);
		new FlxTimer(16, undo);
	}
	
	private function ruinGravity(Timer:FlxTimer = null):Void
	{
		gravityWorking = false;
		
		for (p in Reg.server.playermap.iterator())
		{
			p.acceleration.y = 50;
		}
	}
	
	private function fixGravity(Timer:FlxTimer = null):Void
	{
		gravityWorking = true;
		
		for (p in Reg.server.playermap.iterator())
		{
			p.acceleration.y = PlayerBase.gravity;
		}
	}
	
	private function announceRuin():Void
	{
		msg = new NLabel(200, 100, 0xffffffff, 0, true);
		msg.setLabel("Losing artificial gravity!");
		new FlxTimer(6, deleteAnnounce);
	}
	
	private function undo(Timer:FlxTimer = null):Void
	{
		msg = new NLabel(120, 100, 0xffffffff, 0, true);
		msg.setLabel("Reestablishing artificial gravity. Get to solid ground!");
		new FlxTimer(6, fixGravity);
		new FlxTimer(6, deleteAnnounce);
	}
	
	private function deleteAnnounce(T:FlxTimer):Void
	{
		msg.delete();
	}
}