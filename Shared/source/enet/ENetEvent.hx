package enet;

class ENetEvent
{
	
	/**
	 * E_NONE, E_CONNECT, E_DISCONNECT or E_RECEIVE
	 */
	public var type:Int;
	
	/**
	 * The channel on which the event occured
	 */
	public var channel:Int; //-1 if null
	
	/**
	 * The sent content
	 */
	public var message:String = null;
	
	/**
	 * The peer's IP, in int_32 format (decimal/long ip format, not dotted quad)
	 */
	public var address:String = null;
	
	/**
	 * The peer's port
	 */
	public var port:Int;
	
	
	/**
	 * Nothing new here
	 */
	static public inline var E_NONE = 0;
	
	/**
	 * Someone has connected/you've succeeded to connect as a client
	 */
	static public inline var E_CONNECT = 1;
	
	/**
	 * A peer has disconnected/you've been disconnected from the server
	 */
	static public inline var E_DISCONNECT = 2;
	
	/**
	 * You've received a message!
	 */
	static public inline var E_RECEIVE = 3;
	
	/**
	 * Internal, you shouldn't create instances of this out of the blue
	 */
	public function new(EventFromC:Dynamic):Void
	{
		type = ENet.event_type(EventFromC);
		
		channel = ENet.event_channel(EventFromC);
		
		if (type > E_NONE)
		{
			//Setting address and port
			var _addbuff:String = ENet.event_peer(EventFromC);
			var _addbuff2:Array<String> = _addbuff.split(":");
			address = _addbuff2[0];
			port = Std.parseInt(_addbuff2[1]);
			
			if (type == E_RECEIVE)
			{
				message = ENet.event_message(EventFromC);
			}
			
			ENet.event_destroy(EventFromC);
		}
	}
}