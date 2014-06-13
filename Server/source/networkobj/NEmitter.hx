package networkobj;

import enet.ENet;
import flixel.effects.particles.FlxEmitterExt;
import haxe.Serializer;
import ext.FlxEmitterAuto;

/**
 * ...
 * @author Ohmnivore
 */
class NEmitter
{
	static public var emitters:Map<Int, FlxEmitterAuto>;
	static public var live_emitters:Map<Int, FlxEmitterAuto>;
	
	static public function init():Void
	{
		emitters = new Map<Int, FlxEmitterAuto>();
		live_emitters = new Map<Int, FlxEmitterAuto>();
	}
	
	static public function announceEmitters(player:Int = 0):Void
	{
		var array:Array<Dynamic> = [];
		
		for (id in emitters.keys())
		{
			var arr:Array<Dynamic> = [];
			var e:FlxEmitterAuto = emitters.get(id);
			
			arr.push(id);
			arr.push("placeholder");
			arr.push(e.acceleration);
			arr.push(e.blend);
			arr.push(e.bounce);
			arr.push(e.collisionType);
			arr.push(e.endAlpha);
			arr.push(e.endBlue);
			arr.push(e.endGreen);
			arr.push(e.endRed);
			arr.push(e.endScale);
			arr.push(e.frequency);
			arr.push(e.gravity);
			arr.push(e.height);
			arr.push(e.life);
			arr.push(e.lifespan);
			arr.push(e.maxRotation);
			arr.push(e.maxSize);
			arr.push(e.minRotation);
			arr.push(e.particleDrag);
			arr.push(e.rotation);
			arr.push(e.startAlpha);
			arr.push(e.startBlue);
			arr.push(e.startGreen);
			arr.push(e.startRed);
			arr.push(e.startScale);
			arr.push(e.width);
			arr.push(e.xVelocity);
			arr.push(e.yVelocity);
			
			arr.push(e.angle);
			arr.push(e.angleRange);
			arr.push(e.distance);
			arr.push(e.distanceRange);
			
			array.push(arr);
		}
		
		Msg.EmitterAnnounce.data.set("serialized", Serializer.run(array));
		
		if (player == 0)
		{
			Reg.server.sendMsgToAll(Msg.EmitterAnnounce.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
		
		else
		{
			Reg.server.sendMsg(player, Msg.EmitterAnnounce.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
	}
	
	static public function playEmitter(ID:Int,Local:Bool=true,X:Int,Y:Int,Graphic:String,Collide:Float=0,
		rotationFrames:Int = 0, Explode:Bool, Quantity:Int):Int
	{
		var ID_R:Int = NReg.getID();
		
		if (Local)
		{
			var e:FlxEmitterAuto = cloneFromEmitter(emitters.get(ID), X, Y);
			e.makeParticles(Assets.images.get(Graphic), Quantity, rotationFrames, Collide);
			e.start(Explode, e.life.min, e.frequency, Quantity, e.life.max - e.life.min);
			Reg.state.emitters.add(e);
			
			live_emitters.set(ID_R, e);
		}
		
		Msg.EmitterNew.data.set("id", ID);
		Msg.EmitterNew.data.set("id2", ID_R);
		Msg.EmitterNew.data.set("x", X);
		Msg.EmitterNew.data.set("y", Y);
		Msg.EmitterNew.data.set("graphic", Graphic);
		Msg.EmitterNew.data.set("collide", Collide);
		Msg.EmitterNew.data.set("rotationFrames", rotationFrames);
		Msg.EmitterNew.data.set("explode", Explode);
		Msg.EmitterNew.data.set("quantity", Quantity);
		
		Reg.server.sendMsgToAll(Msg.EmitterNew.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
		
		return ID_R;
	}
	
	static public function cloneFromEmitter(E:FlxEmitterAuto, X:Int, Y:Int):FlxEmitterAuto
	{
		var e:FlxEmitterAuto = new FlxEmitterAuto(Reg.state.emitters, X, Y);
		
		e.bounce = E.bounce;
		e.frequency = E.frequency;
		e.gravity = E.gravity;
		e.particleDrag.copyFrom(E.particleDrag);
		e.acceleration.copyFrom(E.acceleration);
		e.endBlue = E.endBlue;
		e.endGreen = E.endGreen;
		e.endRed = E.endRed;
		e.lifespan = E.lifespan;
		e.startBlue = E.startBlue;
		e.startGreen = E.startGreen;
		e.startRed = E.startRed;
		
		e.setRotation(E.rotation.min, E.rotation.max);
		e.setScale(E.startScale.min, E.startScale.max, E.endScale.min, E.endScale.max);
		e.setSize(Std.int(E.width), Std.int(E.height));
		e.setXSpeed(E.xVelocity.min, E.xVelocity.max);
		e.setYSpeed(E.yVelocity.min, E.yVelocity.max);
		e.setAlpha(E.startAlpha.min, E.startAlpha.max, E.endAlpha.min, E.endAlpha.max);
		e.setMotion(E.angle / 0.017453293, E.distance, E.life.min,
			E.angleRange/0.017453293, E.distanceRange, E.life.max - E.life.min);
		
		return e;
	}
	
	static public function stopEmitter(Handle:Int):Void
	{
		var e:FlxEmitterAuto = live_emitters.get(Handle);
		
		if (e != null)
		{
			Msg.EmitterDelete.data.set("id", Handle);
			
			Reg.server.sendMsgToAll(Msg.EmitterDelete.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
			
			Reg.state.emitters.remove(e, true);
			e.kill();
			e.destroy();
		}
	}
	
	static public function registerEmitter(E:FlxEmitterAuto):Int
	{
		var ID:Int = NReg.getID();
		
		emitters.set(ID, E);
		
		return ID;
	}
	
	static public function removeEmitter(ID:Int):Void
	{
		emitters.remove(ID);
	}
	
	//static public function getEmitter(ID:Int):FlxTypedEmitter
	//{
		//return emitters.get(ID);
	//}
}