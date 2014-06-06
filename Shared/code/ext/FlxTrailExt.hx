package ext;
import flixel.addons.effects.FlxTrail;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxPoint;

/**
 * ...
 * @author Ohmnivore
 */
class FlxTrailExt extends FlxTrail
{
	private var _offsetX:Int;
	private var _offsetY:Int;
	
	public function new(Sprite:FlxSprite, ?Image:Dynamic, Length:Int = 10, Delay:Int = 3, Alpha:Float = 0.4, Diff:Float = 0.05) 
	{
		super(Sprite, Image, Length, Delay, Alpha, Diff);
	}
	
	public function setTrailOffset(X:Int, Y:Int):Void
	{
		_offsetX = X;
		_offsetY = Y;
	}
	
	override public function update():Void 
	{
		// Count the frames
		_counter++;

		// Update the trail in case the intervall and there actually is one.
		if (_counter >= delay && _trailLength >= 1)
		{
			_counter = 0;
			
			// Push the current position into the positons array and drop one.
			var spritePosition:FlxPoint = null;
			if (_recentPositions.length == _trailLength)
			{
				spritePosition = _recentPositions.pop();
			}
			else
			{
				spritePosition = new FlxPoint();
			}
			
			spritePosition.set(sprite.x - sprite.offset.x + _offsetX, sprite.y - sprite.offset.y + _offsetY);
			_recentPositions.unshift(spritePosition);
			
			// Also do the same thing for the Sprites angle if rotationsEnabled 
			if (rotationsEnabled) 
			{
				var spriteAngle:Float = sprite.angle;
				_recentAngles.unshift(spriteAngle);
				
				if (_recentAngles.length > _trailLength) 
				{
					_recentAngles.pop();
				}
			}
			
			// Again the same thing for Sprites scales if scalesEnabled
			if (scalesEnabled)
			{
				var spriteScale:FlxPoint = null; // sprite.scale;
				if (_recentScales.length == _trailLength)
				{
					spriteScale = _recentScales.pop();
				}
				else
				{
					spriteScale = new FlxPoint();
				}
				
				spriteScale.set(sprite.scale.x, sprite.scale.y);
				_recentScales.unshift(spriteScale);
			}
			
			// Again the same thing for Sprites frames if framesEnabled
			if (framesEnabled && _image == null) 
			{
				var spriteFrame:Int = sprite.animation.frameIndex;
				_recentFrames.unshift(spriteFrame);
				
				if (_recentFrames.length > _trailLength) 
				{
					_recentFrames.pop();
				}
				
				var spriteFacing:Int = sprite.facing;
				_recentFacings.unshift(spriteFacing);
				
				if (_recentFacings.length > _trailLength) 
				{
					_recentFacings.pop();
				}
			}

			// Now we need to update the all the Trailsprites' values
			var trailSprite:FlxSprite;
			
			for (i in 0..._recentPositions.length) 
			{
				trailSprite = members[i];
				trailSprite.x = _recentPositions[i].x;
				trailSprite.y = _recentPositions[i].y;
				
				// And the angle...
				if (rotationsEnabled) 
				{
					trailSprite.angle = _recentAngles[i];
					trailSprite.origin.x = _spriteOrigin.x;
					trailSprite.origin.y = _spriteOrigin.y;
				}
				
				// the scale...
				if (scalesEnabled) 
				{
					trailSprite.scale.x = _recentScales[i].x;
					trailSprite.scale.y = _recentScales[i].y;
				}
				
				// and frame...
				if (framesEnabled && _image == null) 
				{
					trailSprite.animation.frameIndex = _recentFrames[i];
					trailSprite.facing = _recentFacings[i];
				}

				// Is the trailsprite even visible?
				trailSprite.exists = true; 
			}
		}

		//super.update();
	}
	
}