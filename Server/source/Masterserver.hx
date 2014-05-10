package ;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;

/**
 * ...
 * @author Ohmnivore
 */
class Masterserver
{
	static public var url:String;
	static public var loader:URLLoader;
	static public var request:URLRequest;
	static public var key:String;
	static public var elapsed:Float;
	
	static public function init():Void
	{
		url = Assets.config.get("masterserver");
		
		loader = new URLLoader();
		request = new URLRequest();
		request.method = URLRequestMethod.POST;
	}
	
	static public function register(Name:String):Void
	{
		key = randString(100);
		
		request = new URLRequest();
		request.method = URLRequestMethod.POST;
		request.url = url + '/s/new/$Name/$key';
		
		_fireRequest();
	}
	
	static public function setMapGM(MapName:String, GameMode:String):Void
	{
		request = new URLRequest();
		request.method = URLRequestMethod.POST;
		request.url = url + '/s/setmapgm/$MapName/$GameMode/$key';
		
		_fireRequest();
	}
	
	static public function setPlayers(Players:Int, MaxPlayers:Int):Void
	{
		request = new URLRequest();
		request.method = URLRequestMethod.POST;
		request.url = url + '/s/setplayers/$Players/$MaxPlayers/$key';
		
		_fireRequest();
	}
	
	static public function heartbeat():Void
	{
		var oldkey:String = key;
		key = randString(100);
		
		request = new URLRequest();
		request.method = URLRequestMethod.POST;
		request.url = url + '/s/pulse/$oldkey/$key';
		
		_fireRequest();
	}
	
	static public function updateHeartBeat(Elapsed:Float):Void
	{
		elapsed += Elapsed;
		
		if (elapsed > 35)
		{
			heartbeat();
			elapsed = 0;
		}
	}
	
	/** Return a random string of a certain length.  You can optionally specify 
	    which characters to use, otherwise the default is (a-zA-Z0-9) */
	static private function randString(length:Int, ?charactersToUse = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"):String
	{
		var str = "";
		for (i in 0...length)
		{
			str += charactersToUse.charAt(Masterserver.randInt(0, charactersToUse.length - 1));
		}
		return str;
	}
	
	/** Return a random integer between 'from' and 'to', inclusive. */
	static private inline function randInt(from:Int, to:Int):Int
	{
		return from + Math.floor(((to - from + 1) * Math.random()));
	}
	
	static private function _fireRequest():Void
	{
		loader = new URLLoader(request);
	}
}