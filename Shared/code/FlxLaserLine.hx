package ;

import flixel.FlxSprite;
import flixel.util.FlxAngle;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxPoint;

/**
 * ...
 * @author ...
 */

 class FlxLaserLine extends FlxSprite
{
	public function new(X:Float, Y:Float, Length:Int, Angle:Float):Void
	{
		super(X, Y);
		
		makeGraphic(Length + 8, 3, 0x00000000);
		FlxSpriteUtil.drawLine(this, 0, 1, Length + 8, 1,
			{ thickness:3, color:0x99ff0000 },
			{ smoothing:true } );
		origin.set(1, 1);
		
		if (Angle > 180)
		{
			var endPoint:FlxPoint = FlxAngle.rotatePoint(Length, 0, 0, 0, Angle);
			Angle -= 180;
			x += endPoint.x;
			y += endPoint.y;
		}
		
		angle = Angle;
	}
}