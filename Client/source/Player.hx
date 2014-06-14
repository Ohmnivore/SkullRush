package ;
import flixel.util.FlxSpriteUtil;
import ext.FlxWeaponExt;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Ohmnivore
 */
class Player extends PlayerBase
{
	public function new(Id:Int, Name:String, X:Int, Y:Int)
	{
		super(Id, Name, X, Y);
		trace("newplayer");
		setGun(1);
	}
	
	override public function fire():Void 
	{
		super.fire();
		
		if (ID == Reg.state.player.ID)
		{
			var reload:FlxTimer = new FlxTimer(last_shot.mock_fireRate / 1000);
			Reg.state.wepBar.setRange(0, 1);
			Reg.state.wepBar.setParent(reload, "progress", false);
		}
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