package enet;

/**
 * ...
 * @author Ohmnivore
 */
class NetBase
{
	/**
	 * Whether this instance is a client or a server
	 */
	public var isServer:Bool;
	
	/**
	 * A hash table you should use for keeping track of your clients, use ENet.peerKey() 
	 * to generate a key from an IP and a port
	 */
	public var peers:Map<Int, Dynamic>;
	
	/**
	 * Internal host, stores an object returned by an external C++ function
	 * You really shouldn't touch this.
	 */
	private var _host:Dynamic;
	
	/**
	 * Internal hash table that keeps track of registered messages
	 * You really shouldn't touch this either.
	 */
	private var messages:Map<Int, Message>;
	
	/**
	 * Initializes hash tables
	 */
	public function new() 
	{
		peers = new Map<Int, Dynamic>();
		messages = new Map<Int, Message>();
	}
	
	/**
	 * Register a Message instance to this host.
	 */
	public function addMessage(M:Message):Void
	{
		messages.set(M.ID, M);
	}
	
	/**
	 * Internal function, don't touch
	 */
	private function separateMessage(Str:String):Array<Dynamic>
	{
		var _res:Array<Dynamic> = [];
		
		var sep:Int = Str.indexOf(".");
		
		_res.push(Std.parseInt(Str.substr(0, sep)));
		
		_res.push(Str.substr(sep + 1));
		
		return _res;
	}
	
	/**
	 * Call this as regularly and as often as possible
	 */
	public function poll(Timeout:Float = 0):Void
	{
		var e:ENetEvent =  ENet.poll(_host, Timeout);
		
		if (e.type == ENetEvent.E_RECEIVE)
		{
			try
			{
				var res:Array<Dynamic> = separateMessage(e.message);
				
				var m:Message = messages.get(res[0]);
				
				if (isServer && m.isServerSideOnly)
				{
					//don't allow this message's content to be set by an incoming packet
				}
				
				else
				{
					m.unserialize(res[1]);
				}
				
				onReceive(res[0], e);
			}
			
			catch (e:Dynamic)
			{
				trace("Error receiving message, content: ", e.message);
			}
		}
		
		else if (e.type == ENetEvent.E_CONNECT)
		{
			onPeerConnect(e);
		}
		
		else if (e.type == ENetEvent.E_DISCONNECT)
		{
			onPeerDisonnect(e);
		}
	}
	
	/**
	 * Override this to handle receiving. MsgID is the ID of the message
	 * that was received. It's important to fetch the message's contents
	 * immediately when this is called, as the message's contents will change
	 * the next time it's received.
	 */
	public function onReceive(MsgID:Int, E:ENetEvent):Void
	{
		
	}
	
	/**
	 * Override this to handle peer connecting.
	 */
	public function onPeerConnect(e:ENetEvent):Void
	{
		
	}
	
	/**
	 * Override this to handle peer disconnecting.
	 */
	public function onPeerDisonnect(e:ENetEvent):Void
	{
		
	}
	
	/**
	 * Does what it says. Also returns the target client's RTT.
	 * 
	 * @param	ID		The peer's ID
	 * @param	MsgID	The ID of the message you intend to send. It's contents at the moment of the call will be sent.
	 * @param	Channel Which channel to send through
	 * @param	Flags	ENet flags, use | to unite flags, if they don't conflict
	 * @return	Returns the target client's RTT, divide by two to obtain the traditional "ping"
	 */
	public function sendMsg(ID:Int, MsgID:Int, Channel:Int = 0, Flags:Int = 0):Void
	{
		ENet.sendMsg(_host, ID, messages.get(MsgID).serialize(), Channel, Flags);
	}
	
	/**
	 * Still figuring out how to use this beast myself.
	 */
	public function punchNAT(Address:String, Port:Int, Data:String):Bool
	{
		return ENet.punchNAT(_host, Address, Port, Data);
	}
	
	/**
	 * Disconnects a connected peer, smoothly or forcefully.
	 * The advantage of smoothly disconnecting is that the peer
	 * will be notified of the disconnection.
	 * 
	 * @param	ID	    The peer's ID
	 * @param	Force   Wether the peer will be notified of the disconnection or just outright dropped off the host	
	 */
	public function peerDisconnect(ID:Int, Force:Bool):Void
	{
		ENet.peerDisconnect(_host, ID, Force);
	}
}