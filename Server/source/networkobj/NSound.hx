package networkobj;
import enet.ENet;
import flixel.FlxG;

/**
 * ...
 * @author Ohmnivore
 */
class NSound
{
	static public function instaPlay(Key:String, Peer:Int = 0, Local:Bool = false):Void 
	{
		Msg.PlaySound.data.set("assetkey", Key);
		
		if (Peer == 0)
		{
			for (id in Reg.server.playermap.keys())
			{
				Reg.server.sendMsg(id, Msg.PlaySound.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
			}
		}
		
		else
		{
			Reg.server.sendMsg(Peer, Msg.PlaySound.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
		
		if (Local)
		{
			FlxG.sound.play(Assets.sounds.get(Key));
		}
	}
	
	static public function setMusic(Key:String, Peer:Int = 0, Local:Bool = false):Void
	{
		Msg.PlayMusic.data.set("assetkey", Key);
		
		if (Peer == 0)
		{
			for (id in Reg.server.playermap.keys())
			{
				Reg.server.sendMsg(id, Msg.PlayMusic.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
			}
		}
		
		else
		{
			Reg.server.sendMsg(Peer, Msg.PlayMusic.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
		
		if (Local)
		{
			FlxG.sound.playMusic(Assets.sounds.get(Key));
		}
	}
	
	static public function stopMusic(Peer:Int = 0, Local:Bool = false):Void
	{
		if (Peer == 0)
		{
			for (id in Reg.server.playermap.keys())
			{
				Reg.server.sendMsg(id, Msg.StopMusic.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
			}
		}
		
		else
		{
			Reg.server.sendMsg(Peer, Msg.StopMusic.ID, 2, ENet.ENET_PACKET_FLAG_RELIABLE);
		}
		
		if (Local)
		{
			FlxG.sound.music.stop();
		}
	}
}