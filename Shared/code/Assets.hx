package ;

/**
 * ...
 * @author Ohmnivore
 */
class Assets
{
	static public var images:Map<String, Dynamic>;
	
	static public function initAssets():Void
	{
		images = new Map<String, Dynamic>();
		
		images.set("assets/images/explosionparticle.png", "shared/images/explosionparticle.png");
		images.set("assets/images/gridtiles2.png", "shared/images/gridtiles2.png");
		images.set("assets/images/gun.png", "shared/images/gun.png");
		images.set("assets/images/gun2.png", "shared/images/gun2.png");
		images.set("assets/images/playerblue.png", "shared/images/playerblue.png");
		images.set("assets/images/playergreen.png", "shared/images/playergreen.png");
		images.set("assets/images/playerred.png", "shared/images/playerred.png");
		images.set("assets/images/playeryellow.png", "shared/images/playeryellow.png");
		images.set("assets/images/trail.png", "shared/images/trail.png");
	}
	
	static public function getImg(Key:String):Dynamic
	{
		return images.get(Key);
	}
}