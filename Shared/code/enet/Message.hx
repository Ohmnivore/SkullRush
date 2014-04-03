package enet;
import haxe.Serializer;
import haxe.Unserializer;

/**
 * ...
 * @author Ohmnivore
 */
class Message
{
	/**
	 * Unique identifier of this message. MUST be unique.
	 */
	public var ID:Int;
	
	/**
	 * Use this to obtain received data and set data to be sent.
	 * As keys, use the strings you pass in the Fields array 
	 * when you create the message.
	 */
	public var data:Map<String, Dynamic>;
	
	/**
	 * Whether incoming packets can set this message's data's contents.
	 * Set this to true if your server only sends out this message, and 
	 * doesn't receive it.
	 */
	public var isServerSideOnly:Bool;
	
	/**
	 * Internal, don't touch.
	 */
	private var fields:Array<String>;
	
	/**
	 * Internal, don't touch.
	 */
	private var _arr:Array<Dynamic>;
	
	/**
	 * @param	id		The message's ID. Every message should have an unique ID.
	 * @param	Fields	An array of all the message's data object's fields
	 * @param	IsServerSideOnly	If only a client may receive this message (necessary for security reasons)
	 */
	public function new(id:Int, Fields:Array<String>, IsServerSideOnly:Bool = false)
	{
		ID = id;
		isServerSideOnly = IsServerSideOnly;
		fields = Fields;
		_arr = new Array();
		data = new Map<String, Dynamic>();
		
		for (f in fields)
		{
			data.set(f, null);
		}
	}
	
	/**
	 * Internal, don't touch.
	 */
	public function serialize():String
	{
		_arr.splice(0, _arr.length);
		
		var res:String = "";
		
		res += Std.string(ID) + ".";
		
		for (f in fields)
		{
			_arr.push(data.get(f));
		}
		
		res += Serializer.run(_arr);
		//trace(res);
		return res;
	}
	
	/**
	 * Internal, don't touch.
	 */
	public function unserialize(S:String):Void
	{
		_arr.splice(0, _arr.length);
		
		_arr = Unserializer.run(S);
		
		var x:Int = 0;
		
		for (f in fields)
		{
			data.set(f, _arr[x]);
			//trace(_arr[x]);
			x++;
		}
	}
}