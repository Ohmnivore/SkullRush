package entities;

import entities.MeteoriteStrike.Meteor;
import flixel.FlxObject;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import networkobj.NEmitter;
import networkobj.NFlxEmitterAuto;
import networkobj.NSprite;
import networkobj.NTemplate;
import networkobj.NFlxSprite;
import networkobj.NReg;
import ext.FlxEmitterAuto;
import flixel.tile.FlxTilemap;
import gevents.HurtInfo;
import gevents.HurtEvent;
import gamemodes.BaseGamemode;

/**
 * ...
 * @author ...
 */

class Meteor extends NSprite
{
	static public var TEMPL:NTemplate;
	static public var EXPLODE:Int;
	static public var ENV_METEORITE:String = "meteorite";
	
	private var updateLimiter:Int = 0;
	
	public function new(X:Float, Y:Float) 
	{
		super(X, Y, TEMPL, MeteorSprite);
	}
	
	override public function sendUpdate():Void
	{
		updateLimiter++;
		
		if (updateLimiter > 60)
		{
			Msg.UpdateSprite.data.set("id", ID);
			Msg.UpdateSprite.data.set("x", s.x);
			Msg.UpdateSprite.data.set("y", s.y);
			Msg.UpdateSprite.data.set("velocity.x", s.velocity.x);
			Msg.UpdateSprite.data.set("velocity.y", s.velocity.y);
			
			for (id in Reg.server.playermap.keys())
			{
				Reg.server.sendMsg(id, Msg.UpdateSprite.ID, 2);
			}
			
			updateLimiter = 0;
		}
	}
	
	static public function init():Void
	{
		TEMPL = new NTemplate("assets/images/meteorite.png", 25, 0, 400);
		NReg.registerTemplate(TEMPL);
		
		var emit:NFlxEmitterAuto = new NFlxEmitterAuto(Reg.state.emitters);
		emit.setRotation(0, 100);
		emit.setMotion(0, 50, 1.5, 360, 50, 1);
		emit.setAlpha(1, 0.8, 0, 0.2);
		emit.setScale(1, 2, 1, 2);
		//emit.setColor(0x00ffffff, 0xffFF5D17);
		emit.setXSpeed(250, 300);
		emit.setYSpeed(250, 255);
		emit.bounce = 1;
		
		EXPLODE = NEmitter.registerEmitter(emit);
	}
}

class MeteorSprite extends NFlxSprite
{
	public var meteor:Meteor;
	
	public function new(X:Float, Y:Float, GraphicString:String, Parent:Meteor)
	{
		super(X, Y, GraphicString, Parent);
		
		meteor = Parent;
	}
	
	override public function update():Void 
	{
		if (isTouching(FlxObject.ANY))
		{
			checkKill();
			
			meteor.delete();
		}
		
		super.update();
	}
	
	override public function kill():Void 
	{
		NEmitter.playEmitter(Meteor.EXPLODE, true, Std.int(x + width / 2),
			Std.int(y + height / 2), "assets/images/meteorite_fragment.png", 1, 0, true, 10);
		
		super.kill();
	}
	
	private function checkKill():Void
	{
		for (p in Reg.state.players.members)
		{
			var pl:Player = cast (p, Player);
			var dist:Int = FlxMath.distanceBetween(pl, this);
			
			if (dist <= 150)
			{
				var noCollision:Bool = true;
				for (m in Reg.state.maps.members.iterator())
				{
					var map:FlxTilemap = cast m;
					
					try
					{
						var mypoint:FlxPoint = getMidpoint();
						mypoint.y -= 50;
						if (!map.ray(mypoint, pl.getMidpoint()))
						{
							noCollision = false;
						}
					}
					catch (e:Dynamic)
					{
						
					}
				}
				
				if (noCollision)
				{
					var info:HurtInfo = new HurtInfo();
					info.attacker = 0;
					info.victim = pl.ID;
					info.dmg = Std.int(10 + 150 * (1.0 - (dist / 150)));
					info.dmgsource = getMidpoint();
					info.weapon = null;
					info.type = Meteor.ENV_METEORITE;
					info.message = " was in the way of a meteorite.";
					
					Reg.gm.dispatchEvent(new HurtEvent(HurtEvent.HURT_EVENT, info));
				}
			}
		}
	}
}