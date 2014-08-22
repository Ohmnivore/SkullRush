package networkobj;

import flixel.FlxSprite;
import flixel.tweens.misc.VarTween;
import flixel.util.FlxAngle;
import flixel.util.FlxMath;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

/**
 * ...
 * @author ...
 */
class NArrow extends FlxSprite
{
	public var parentID:Int;
	public var on:Bool = true;
	
	public function new(ParentID:Int, Color:Int):Void
	{
		super(0, 0, Assets.getImg("assets/images/arrow2.png"));
		
		parentID = ParentID;
		centerOrigin();
		color = Color;
		alpha = 0.5;
		
		Reg.state.hud.add(this);
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (on)
		{
			if (NReg.sprites.exists(parentID) && Reg.state.player != null)
			{
				var sprite:FlxSprite = NReg.sprites.get(parentID);
				
				if (FlxMath.distanceBetween(Reg.state.player, sprite) > 240)
				{
					if (alpha == 0)
						FlxTween.tween(this, { alpha:0.5 }, 1,
							{type:FlxTween.ONESHOT, ease:FlxEase.cubeIn});
					var Angle:Float = FlxAngle.angleBetween(Reg.state.player, sprite, true);
					var newPoint = FlxAngle.rotatePoint(100, 0, 0, 0, Angle);
					
					x = newPoint.x + Reg.state.player.x;
					y = newPoint.y + Reg.state.player.y;
					angle = Angle;
				}
				else
				{
					if (alpha == 0.5)
						FlxTween.tween(this, { alpha:0 }, 1,
							{type:FlxTween.ONESHOT, ease:FlxEase.cubeIn});
				}
			}
		}
		else
		{
			if (alpha == 0.5)
			{
				FlxTween.tween(this, { alpha:0 }, 1,
					{type:FlxTween.ONESHOT, ease:FlxEase.cubeIn});
			}
		}
	}
}