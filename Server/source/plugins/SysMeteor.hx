package plugins;

import entities.MeteoriteStrike.Meteor;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;
import gamemodes.BaseGamemode;
import gevents.DeathEvent;
import networkobj.NLabel;
import gamemodes.DefaultHooks;
import ext.FlxMarkup;

/**
 * ...
 * @author ...
 */
class SysMeteor extends BasePlugin
{
	private var msg:NLabel;
	
	public function new() 
	{
		pluginName = "SysMeteor";
		version = "0.0.1";
		
		super();
		
		Meteor.init();
	}
	
	override public function activate():Void 
	{
		super.activate();
		
		rainHell();
	}
	
	override public function hookEvents(Gm:BaseGamemode):Void 
	{
		super.hookEvents(Gm);
	}
	
	public function rainHell(Timer:FlxTimer = null):Void
	{
		announceRain();
		
		var x:Int = 0;
		
		while (x < Reg.state.collidemap.width)
		{
			var m:Meteor = new Meteor(x, Reg.state.collidemap.y - 800 - FlxRandom.intRanged(0, 200));
			m.setFields(0, ["angularVelocity"], [FlxRandom.intRanged(10, 100)]);
			var scale:Float = FlxRandom.floatRanged(0.5, 2);
			m.setFields(0, ["scale"], [new FlxPoint(scale, scale)]);
			
			x += 100 + FlxRandom.intRanged(0, 50);
		}
	}
	
	private function announceRain():Void
	{
		msg = new NLabel(160, 100, 0xffffffff, 0, true);
		msg.setLabel("Meteorite shower inbound. Find cover!");
		new FlxTimer(6, deleteAnnounce);
	}
	
	private function deleteAnnounce(T:FlxTimer):Void
	{
		msg.delete();
	}
}