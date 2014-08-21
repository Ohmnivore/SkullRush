package networkobj;

import ext.FlxEmitterAuto;
import flixel.group.FlxGroup;

/**
 * ...
 * @author ...
 */
class NFlxEmitterAuto extends FlxEmitterAuto
{
	public var nLocal:Bool;
	public var nTemplateID:Int;
	public var nInstanceID:Int;
	public var nQuantity:Int;
	public var nGraphic:String;
	public var nCollide:Float;
	public var nRotationFrames:Int;
	public var nExplode:Bool;
	
	public function new(Parent:FlxGroup, X:Float = 0, Y:Float = 0, Size:Int = 0) 
	{
		super(Parent, X, Y, Size);
	}
}