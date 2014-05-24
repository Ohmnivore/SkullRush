package ;
import sys.io.File;

/**
 * ...
 * @author Ohmnivore
 */
class Assets
{
	static public var images:Map<String, Dynamic>;
	static public var sounds:Map<String, Dynamic>;
	
	static public var config:Map<String, String>;
	
	static public function initAssets():Void
	{
		images = new Map<String, Dynamic>();
		sounds = new Map<String, Dynamic>();
		
		images.set("assets/images/explosionparticle.png", "shared/images/explosionparticle.png");
		images.set("assets/images/gridtiles2.png", "shared/images/gridtiles2.png");
		images.set("assets/images/gridtiles3.png", "shared/images/gridtiles3.png");
		images.set("assets/images/gridtiles4.png", "shared/images/gridtiles4.png");
		images.set("assets/images/gun.png", "shared/images/gun.png");
		images.set("assets/images/gun_launcher_bullet.png", "shared/images/gun_launcher_bullet.png");
		images.set("assets/images/gun_splasher.png", "shared/images/gun_splasher.png");
		images.set("assets/images/gun_splasher_bullet.png", "shared/images/gun_splasher_bullet.png");
		images.set("assets/images/gun_eviscerator.png", "shared/images/gun_eviscerator.png");
		images.set("assets/images/gun_eviscerator_bullet.png", "shared/images/gun_eviscerator_bullet.png");
		images.set("assets/images/playerblue.png", "shared/images/playerblue.png");
		images.set("assets/images/playergreen.png", "shared/images/playergreen.png");
		images.set("assets/images/playerred.png", "shared/images/playerred.png");
		images.set("assets/images/playeryellow.png", "shared/images/playeryellow.png");
		images.set("assets/images/trail.png", "shared/images/trail.png");
		images.set("assets/images/scifitiles.png", "shared/images/scifitiles.png");
		images.set("assets/images/flag_g.png", "shared/images/flag_g.png");
		images.set("assets/images/flag_b.png", "shared/images/flag_b.png");
		images.set("assets/images/flag_y.png", "shared/images/flag_y.png");
		images.set("assets/images/flag_r.png", "shared/images/flag_r.png");
		images.set("assets/images/flag_gh.png", "shared/images/flag_gh.png");
		images.set("assets/images/flag_bh.png", "shared/images/flag_bh.png");
		images.set("assets/images/flag_yh.png", "shared/images/flag_yh.png");
		images.set("assets/images/flag_rh.png", "shared/images/flag_rh.png");
		images.set("assets/images/powerup_health.png", "shared/images/powerup_health.png");
	}
	
	static public function getImg(Key:String):Dynamic
	{
		return images.get(Key);
	}
	
	static public function loadConfig():Void
	{
		config = readConfig();
	}
	
	static public function readConfig():Map<String, String>
	{
		var map:Map<String, String> = new Map<String, String>();
		
		var str:String = File.getContent("config.txt");
		
		var key_value:Array<String> = str.split("\n");
		
		for (s in key_value)
		{
			if (s.charAt(0) != "#")
			{
				StringTools.trim(s);
				
				var delimiter:Int = s.indexOf("=");
				
				var key:String = s.substring(0, delimiter);
				
				var value:String = s.substring(delimiter + 1, s.length);
				value = StringTools.trim(value);
				
				map.set(key, value);
			}
		}
		
		return map;
	}
	
	static public function saveConfig():Void
	{
		var str:String = File.getContent("config.txt");
		var ret:String = "";
		
		var key_value:Array<String> = str.split("\n");
		
		for (s in key_value)
		{
			if (s.charAt(0) != "#")
			{
				StringTools.trim(s);
				
				var delimiter:Int = s.indexOf("=");
				
				var key:String = s.substring(0, delimiter);
				
				if (key != null && Assets.config.get(key) != null)
				{
					if (key.length > 0)
						ret += key + "=" + Std.string(Assets.config.get(key)) + "\n";
				}
			}
			
			else
			{
				ret += s + "\n";
			}
		}
		
		File.saveContent("config.txt", ret);
	}
}