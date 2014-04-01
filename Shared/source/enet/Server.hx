package enet;

/**
 * ...
 * @author Ohmnivore
 */
class Server extends enet.NetBase
{
	/**
	 * The server's bind IP in dotted quad format
	 */
	public var ip:String;
	
	/**
	 * The server's bind port
	 */
	public var port:Int;
	
	/**
	 * Creates a new server.
	 * 
	 * @param	IP		The IP to bind to (in dotted quad format). Pass in null to bind to all available interfaces.
	 * @param	Port	The port to bind to
	 */
	public function new(IP:String = null, Port:Int = 0, Channels:Int = 2, Players:Int = 32) 
	{
		super();
		
		_host = ENet.server(IP, Port, Channels, Players);
		
		ip = IP;
		port = Port;
	}
}