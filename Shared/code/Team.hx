package ;
import haxe.Serializer;
import haxe.Unserializer;

/**
 * ...
 * @author Ohmnivore
 */
class Team
{
	public var name:String;
	public var color:Int;
	public var graphicKey:String;
	
	public function new(Name:String = "", Color:Int = 0xffffffff, GraphicKey:String = "assets/images/playergreen.png") 
	{
		name = Name;
		color = Color;
		graphicKey = GraphicKey;
	}
	
	public function serialize():String
	{
		return Serializer.run([name, color, graphicKey]);
	}
	
	public function unserialize(S:String):Void
	{
		var arr:Array<Dynamic> = cast Unserializer.run(S);
		
		name = arr[0];
		color = arr[1];
		graphicKey = arr[2];
	}
}