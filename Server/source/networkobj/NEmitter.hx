package networkobj;

import enet.ENet;
import flixel.effects.particles.FlxEmitter;
import haxe.Serializer;

/**
 * ...
 * @author Ohmnivore
 */
class NEmitter
{
	static private var emitters:Map<Int, FlxEmitter>;
	static private var live_emitters:Map<Int, FlxEmitter>;
	
	static public function init():Void
	{
		emitters = new Map<Int, FlxEmitter>();
		live_emitters = new Map<Int, FlxEmitter>();
	}
	
	static public function announceEmitters(player:Int = 0):Void
	{
		var array:Array<Dynamic> = [];
		
		for (id in emitters.keys())
		{
			var arr:Array<Dynamic> = [];
			var e:FlxEmitter = emitters.get(id);
			
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
			
			array.push(arr);
		}
		
		Msg.EmitterAnnounce.data.set("serialized", Serializer.run(array));
		
		if (player == 0)
		{
			for (p in Reg.server.playermap.keys())
			{
				Reg.server.sendMsg(p, Msg.EmitterAnnounce.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
			}
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
			var e:FlxEmitter = cloneFromEmitter(emitters.get(ID));
			e.makeParticles(Assets.images.get(Graphic), Quantity, rotationFrames, Collide);
			e.start(Explode, e.lifespan, e.frequency, Quantity, e.life.max);
			Reg.state.emitters.add(e);
			e.setPosition(X, Y);
			
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
		
		for (p in Reg.server.playermap.keys())
		{
			Reg.server.sendMsg(p, Msg.EmitterNew.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
		
		return ID_R;
	}
	
	static public function cloneFromEmitter(E:FlxEmitter):FlxEmitter
	{
		var e:FlxEmitter = new FlxEmitter();
		
		e.acceleration.copyFrom(E.acceleration);
		e.blend = E.blend;
		e.bounce = E.bounce;
		//e.collisionType = E.collisionType;
		e.endAlpha = E.endAlpha;
		e.endBlue = E.endBlue;
		e.endGreen = E.endGreen;
		e.endRed = E.endRed;
		e.endScale = E.endScale;
		e.frequency = E.frequency;
		e.gravity = E.gravity;
		e.height = E.height;
		e.life = E.life;
		e.lifespan = E.lifespan;
		e.maxRotation = E.maxRotation;
		e.maxSize = E.maxSize;
		e.minRotation = E.minRotation;
		e.particleDrag.copyFrom(E.particleDrag);
		e.rotation = E.rotation;
		e.startAlpha = E.startAlpha;
		e.startBlue = E.startBlue;
		e.startGreen = E.startGreen;
		e.startRed = E.startRed;
		e.startScale = E.startScale;
		e.width = E.width;
		e.xVelocity = E.xVelocity;
		e.yVelocity = E.yVelocity;
		
		return e;
	}
	
	static public function stopEmitter(Handle:Int):Void
	{
		var e:FlxEmitter = live_emitters.get(Handle);
		//trace(e);
		if (e != null)
		{
			Msg.EmitterDelete.data.set("id", Handle);
			
			for (p in Reg.server.playermap.keys())
			{
				Reg.server.sendMsg(p, Msg.EmitterDelete.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
			}
			
			Reg.state.emitters.remove(e, true);
			e.kill();
			e.destroy();
		}
	}
	
	static public function registerEmitter(E:FlxEmitter):Int
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