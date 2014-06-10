package ;
import ext.FlxTrailExt;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

/**
 * ...
 * @author Ohmnivore
 */
class FlxCrosshairs extends FlxSprite
{
	public var interior:FlxSprite;
	public var trail:FlxTrailExt;
	
	public function new() 
	{
		super(0, 0);
		loadRotatedGraphic("shared/images/crosshairs.png", 360, -1, true, true);
		
		trail = new FlxTrailExt(this, "shared/images/crosshairs2.png");
		trail.rotationsEnabled = false;
		trail.setTrailOffset(6, 6);
		
		interior = new FlxSprite(0, 0);
		interior.loadRotatedGraphic("shared/images/crosshairs2.png", 360, -1, true, true);
		
		//Reg.state.trailArea.add(interior);
		interior.visible = false;
		
		//Reg.state.trailArea.add(this);
		//visible = false;
	}
	
	public function addToGroup(G:FlxGroup):Void
	{
		G.add(interior);
		G.add(trail);
		G.add(this);
	}
	
	override public function update():Void 
	{
		super.update();
		
		x = FlxG.mouse.x - width / 2;
		y = FlxG.mouse.y - height / 2;
		
		interior.x = FlxG.mouse.x - interior.width / 2;
		interior.y = FlxG.mouse.y - interior.height / 2;
		
		angle += 0.3;
		interior.angle -= 0.15;
	}
	
}