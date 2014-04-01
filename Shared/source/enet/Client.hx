package enet;

/**
 * ...
 * @author Ohmnivore
 */
class Client extends enet.NetBase
{
	/**
	 * Creates a new client, and connects it.
	 * 
	 * @param	IP		The IP to connect to (in dotted quad format)
	 * @param	Port	The port to connect to
	 */
	public function new(IP:String, Port:Int, Channels:Int = 2, Players:Int = 1) 
	{
		super();
		
		_host = ENet.client(IP, Port, Channels, Players);
	}
}