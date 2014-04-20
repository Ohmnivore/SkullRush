package networkobj;

/**
 * ...
 * @author Ohmnivore
 */
class NTemplate
{
	public var ID:Int;
	public var graphicKey:String;
	public var gravity_force:Float;
	public var drag_x:Float;
	public var maxspeed_x:Float;
	
	public function new(GraphicKey:String, GravityForce:Float = 440, DragX:Float = 120, MaxSpeedX:Float = 150) 
	{
		ID = NReg.getID();
		
		graphicKey = GraphicKey;
		gravity_force = GravityForce;
		drag_x = DragX;
		maxspeed_x = MaxSpeedX;
	}
	
}