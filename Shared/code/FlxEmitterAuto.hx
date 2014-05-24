package ;
import flixel.effects.particles.FlxEmitterExt;

/**
 * ...
 * @author Ohmnivore
 */
class FlxEmitterAuto extends FlxEmitterExt
{
	public var autoDestroy:Bool = true;
	public var buffer:Bool = false;
	
	override public function update():Void
	{
		super.update();
		
		if (autoDestroy == true)
		{
			if (countLiving() <= 0)
			{
				if (buffer == true)
				{
					//if (Reg.state.emitters.
					Reg.state.emitters.remove(this, true);
					on = false;
					kill();
					destroy();
				}
			}
			
			else
			{
				buffer = true;
			}
		}
	}
}