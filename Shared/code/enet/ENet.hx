package enet;

import cpp.Lib;

/**
 * ...
 * @author Ohmnivore
 */
class ENet
{
	/**
	 * packet must be received by the target peer 
	 * and resend attempts should be made until 
	 * the packet is delivered
	 */
	static public inline var ENET_PACKET_FLAG_RELIABLE = (1 << 0);
	
	/**
	 * packet will not be sequenced with other 
	 * packets not supported for reliable packets
	 */
	static public inline var ENET_PACKET_FLAG_UNSEQUENCED = (1 << 1);
	
	/**
	 * packet will be fragmented using 
	 * unreliable (instead of reliable) 
	 * sends if it exceeds the MTU
	 */
	static public inline var ENET_PACKET_FLAG_UNRELIABLE_FRAGMENT = (1 << 3);
	
	static public inline var BROADCAST_ADDRESS = "255.255.255.255";
	
	/**
	 * Should be called once before using the library. 
	 * Returns 0 if initialization is successfull.
	 */
	static public function init():Int
	{
		return _enet_init();
	}
	
	/**
	 * Bind the server. 
	 * Returns an ENetHost* (C object, to pass to other functions like sendMsg)
	 * @param	IP	The IP address to bind to in xxx.xxx.xxx.xxx format (pass in null to bind to all available interfaces)
	 */
	static public function server(IP:String = null, Port:Int = 0, Channels:Int = 2, Players:Int = 32):Dynamic
	{
		return _enet_create_server(IP, Port, Channels, Players);
	}
	
	/**
	 * Connect a client to the provided address. 
	 * The client binds to all interfaces, on a random available port. 
	 * Returns an ENetHost* (C object, to pass to other functions like sendMsg)
	 * @param	IP	The remote host's IP address in xxx.xxx.xxx.xxx format
	 */
	static public function client(IP:String = null, Port:Int = 0, Channels:Int = 2, Players:Int = 1):Dynamic
	{
		return _enet_create_client(IP, Port, Channels, Players);
	}
	
	/**
	 * This function returns an event, but also handles ENet's internal protocol. 
	 * Buffered messages are sent out when this function is called. Because it 
	 * keeps the ball rolling, call this regularly, like in your Flixel update function
	 * 
	 * @param	Host	An ENetHost*
	 * @param	Timeout	Just leave this at 0, unless you want your application to block up while waiting for the timeout.
	 * @return	The core, the man, the event of the century, the ENetEvent!
	 */
	static public function poll(Host:Dynamic, Timeout:Float = 0):ENetEvent
	{
		var e:Dynamic = _enet_poll(Host, Timeout);
		
		return new ENetEvent(e);
	}
	
	/**
	 * Internal, don't touch.
	 */
	static public function event_type(Event:Dynamic):Int
	{
		return _enet_event_type(Event);
	}
	
	/**
	 * Internal, don't touch.
	 */
	static public function event_channel(Event:Dynamic):Int
	{
		return _enet_event_channel(Event);
	}
	
	/**
	 * Internal, don't touch.
	 */
	static public function event_message(Event:Dynamic):String
	{
		return _enet_event_message(Event);
	}
	
	/**
	 * Internal, don't touch.
	 */
	static public function event_peer(Event:Dynamic):Int
	{
		return _enet_event_peer(Event);
	}
	
	/**
	 * Internal, don't touch.
	 */
	static public function event_destroy(Event:Dynamic):Void
	{
		_enet_event_destroy(Event);
	}
	
	/**
	 * Does what it says.
	 * 
	 * @param	Host	An ENetHost*
	 * @param	ID		Peer's ID
	 * @param	Content The string to send
	 * @param	Channel Which channel to send through
	 * @param	Flags	ENet flags, use | to unite flags, if they don't conflict
	 */
	static public function sendMsg(Host:Dynamic, ID:Int,
		Content:String, Channel:Int = 0, Flags:Int = 0):Void
	{
		_enet_peer_send(Host, ID, Channel, Content, Flags);
	}
	
	/**
	 * Still figuring out how to use this beast myself.
	 */
	static public function punchNAT(Host:Dynamic, Address:String, Port:Int, Data:String):Bool
	{
		return _enet_send_oob(Host, Address, Port, Data);
	}
	
	/**
	 * Disconnects a connected peer, smoothly or forcefully.
	 * The advantage of smoothly disconnecting is that the peer
	 * will be notified of the disconnection.
	 * 
	 * @param	Host	An ENetHost*
	 * @param	ID	    The peer's ID
	 * @param	Force   Wether the peer will be notified of the disconnection or just outright dropped off the host	
	 */
	static public function peerDisconnect(Host:Dynamic, ID:Int, Force:Bool):Void
	{
		_enet_peer_disconnect(Host, ID, Force);
	}
	
	static public function getPeerPing(ID:Int):Int
	{
		return _enet_get_peer_ping(ID);
	}
	
	static public function getLocalIP():String
	{
		var ip:Dynamic = _enet_get_local_ip();
		
		if (ip == false)
		{
			return "";
		}
		
		else
		{
			return ip;
		}
	}
	
	//All the C/C++ external loading
	static var _enet_init = Lib.load("EnetTesting", "enet_init", 0);
	static var _enet_create_server = Lib.load("EnetTesting", "enet_create_server", 4);
	static var _enet_create_client = Lib.load("EnetTesting", "enet_create_client", 4);
	static var _enet_poll = Lib.load("EnetTesting", "enet_poll", 2);
	static var _enet_send_oob = Lib.load("EnetTesting", "enet_send_oob", 4);
	
	static var _enet_event_type = Lib.load("EnetTesting", "enet_event_type", 1);
	static var _enet_event_channel = Lib.load("EnetTesting", "enet_event_channel", 1);
	static var _enet_event_message = Lib.load("EnetTesting", "enet_event_message", 1);
	static var _enet_event_peer = Lib.load("EnetTesting", "enet_event_peer", 1);
	static var _enet_event_destroy = Lib.load("EnetTesting", "enet_destroy_event", 1);
	static var _enet_get_peer_ping = Lib.load("EnetTesting", "enet_get_peer_ping", 1);
	static var _enet_get_local_ip = Lib.load("EnetTesting", "enet_get_printable_ip", 0);
	
	static var _enet_peer_send = Lib.load("EnetTesting", "enet_send_packet", 5);
	static var _enet_peer_disconnect = Lib.load("EnetTesting", "enet_disconnect_peer", 3);
}