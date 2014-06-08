package ;
import flixel.util.FlxSpriteUtil;
import ext.FlxWeaponExt;

/**
 * ...
 * @author Ohmnivore
 */
class Player extends PlayerBase
{
	//public var requestShoot:Bool = false;
	
	public function new(Id:Int, Name:String, X:Int, Y:Int)
	{
		super(Id, Name, X, Y);
		setGun(1);
	}
	
	override public function setGun(GunID:Int, Force:Bool = false):Void
	{
		if (Std.is(GunID, Int))
		{
			var g:FlxWeaponExt = guns_arr[GunID - 1];
			if (g != null)
			{
				if (gun != null)
					gun.visible = false;
				g.gun.visible = true;
				gun = g.gun;
				cannon = g;
				
				current_weap = GunID;
				
				Reg.state.wepHUD.selectIcon(current_weap);
			}
		}
	}
	
	override public function draw():Void
	{
		super.draw();
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (health <= 0)
		{
			alive = false;
			
			if (visible)
				hide();
		}
		
		else
		{
			if (!visible)
				show();
		}
	}
}