package hxudp;

import haxe.io.Bytes;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end

/**
 * UDP Socket Client (sending):
 * ------------------
 * 1) create()
 * 2) connect()
 * 3) send()
 * ...
 * x) close()
 * 
 * optional:
 * setTimeoutSend()
 * 
 * 
 * UDP Multicast (sending):
 * --------------
 * 1) create()
 * 2) connectMcast()
 * 3) send()
 * ...
 * x) close()
 * 
 * extra optional:
 * setTTL() - default is 1 (current subnet)
 * 
 * 
 * UDP Socket Server (receiving):
 * ------------------
 * 1) create()
 * 2) bind()
 * 3) receive()
 * ...
 * x) close()
 * 
 * optional:
 * setTimeoutReceive()
 * 
 * 
 * UDP Multicast (receiving):
 * --------------
 * 1) create()
 * 2) bindMcast()
 * 3) receive()
 * ...
 * x) Close()
 */
class UdpSocket {
	var handle:Dynamic;
	
	public function new():Void {
		handle = _UdpSocket_new();
	}
	static var _UdpSocket_new = Lib.load("hxudp", "_UdpSocket_new", 0);
	
	
	public function close():Bool {
		return _UdpSocket_Close(handle);
	}
	static var _UdpSocket_Close = Lib.load("hxudp", "_UdpSocket_Close", 1);
	
	
	public function create():Bool {
		return _UdpSocket_Create(handle);
	}
	static var _UdpSocket_Create = Lib.load("hxudp", "_UdpSocket_Create", 1);
	
	
	public function connect(pHost:String, usPort:Int):Bool {
		return _UdpSocket_Connect(handle, pHost, usPort);
	}
	static var _UdpSocket_Connect = Lib.load("hxudp", "_UdpSocket_Connect", 3);
	
	
	public function connectMcast(pMcast:String, usPort:Int):Bool {
		return _UdpSocket_ConnectMcast(handle, pMcast, usPort);
	}
	static var _UdpSocket_ConnectMcast = Lib.load("hxudp", "_UdpSocket_ConnectMcast", 3);
	
	
	public function bind(usPort:Int):Bool {
		return _UdpSocket_Bind(handle, usPort);
	}
	static var _UdpSocket_Bind = Lib.load("hxudp", "_UdpSocket_Bind", 2);
	
	/**
	 * Return the number of Bytes it sent.
	 */
	public function bindMcast(pMcast:String, usPort:Int):Bool {
		return _UdpSocket_BindMcast(handle, pMcast, usPort);
	}
	static var _UdpSocket_BindMcast = Lib.load("hxudp", "_UdpSocket_BindMcast", 3);
	
	/**
	 * Return the number of Bytes it sent.
	 */
	public function send(pBuff:Bytes):Int {
		return _UdpSocket_Send(handle, pBuff.getData(), pBuff.length);
	}
	static var _UdpSocket_Send = Lib.load("hxudp", "_UdpSocket_Send", 3);
	
	/**
	 * All data will be sent guaranteed.
	 */
	public function sendAll(pBuff:Bytes):Int {
		return _UdpSocket_SendAll(handle, pBuff.getData(), pBuff.length);
	}
	static var _UdpSocket_SendAll = Lib.load("hxudp", "_UdpSocket_SendAll", 3);
	
	
	public function receive(pBuff:Bytes):Int {
		return _UdpSocket_Receive(handle, pBuff.getData(), pBuff.length);
	}
	static var _UdpSocket_Receive = Lib.load("hxudp", "_UdpSocket_Receive", 3);
	
	
	public function setTimeoutSend(timeoutInSeconds:Int):Void {
		_UdpSocket_SetTimeoutSend(handle, timeoutInSeconds);
	}
	static var _UdpSocket_SetTimeoutSend = Lib.load("hxudp", "_UdpSocket_SetTimeoutSend", 2);
	
	
	public function setTimeoutReceive(timeoutInSeconds:Int):Void {
		_UdpSocket_SetTimeoutReceive(handle, timeoutInSeconds);
	}
	static var _UdpSocket_SetTimeoutReceive = Lib.load("hxudp", "_UdpSocket_SetTimeoutReceive", 2);
	
	
	public function getTimeoutSend():Int {
		return _UdpSocket_GetTimeoutSend(handle);
	}
	static var _UdpSocket_GetTimeoutSend = Lib.load("hxudp", "_UdpSocket_GetTimeoutSend", 1);
	
	
	public function getTimeoutReceive():Int {
		return _UdpSocket_GetTimeoutReceive(handle);
	}
	static var _UdpSocket_GetTimeoutReceive = Lib.load("hxudp", "_UdpSocket_GetTimeoutReceive", 1);
	
	
	public function getRemoteAddr():String {
		return _UdpSocket_GetRemoteAddr(handle);
	}
	static var _UdpSocket_GetRemoteAddr = Lib.load("hxudp", "_UdpSocket_GetRemoteAddr", 1);
	
	
	public function setReceiveBufferSize(sizeInByte:Int):Bool {
		return _UdpSocket_SetReceiveBufferSize(handle, sizeInByte);
	}
	static var _UdpSocket_SetReceiveBufferSize = Lib.load("hxudp", "_UdpSocket_SetReceiveBufferSize", 2);
	
	
	public function setSendBufferSize(sizeInByte:Int):Bool {
		return _UdpSocket_SetSendBufferSize(handle, sizeInByte);
	}
	static var _UdpSocket_SetSendBufferSize = Lib.load("hxudp", "_UdpSocket_SetSendBufferSize", 2);
	
	
	public function getReceiveBufferSize():Int {
		return _UdpSocket_GetReceiveBufferSize(handle);
	}
	static var _UdpSocket_GetReceiveBufferSize = Lib.load("hxudp", "_UdpSocket_GetReceiveBufferSize", 1);
	
	
	public function getSendBufferSize():Int {
		return _UdpSocket_GetSendBufferSize(handle);
	}
	static var _UdpSocket_GetSendBufferSize = Lib.load("hxudp", "_UdpSocket_GetSendBufferSize", 1);
	
	
	public function setReuseAddress(allowReuse:Bool):Bool {
		return _UdpSocket_SetReuseAddress(handle, allowReuse);
	}
	static var _UdpSocket_SetReuseAddress = Lib.load("hxudp", "_UdpSocket_SetReuseAddress", 2);
	
	
	public function setEnableBroadcast(enableBroadcast:Bool):Bool {
		return _UdpSocket_SetEnableBroadcast(handle, enableBroadcast);
	}
	static var _UdpSocket_SetEnableBroadcast = Lib.load("hxudp", "_UdpSocket_SetEnableBroadcast", 2);
	
	
	public function setNonBlocking(useNonBlocking:Bool):Bool {
		return _UdpSocket_SetNonBlocking(handle, useNonBlocking);
	}
	static var _UdpSocket_SetNonBlocking = Lib.load("hxudp", "_UdpSocket_SetNonBlocking", 2);
	
	
	public function getMaxMsgSize():Int {
		return _UdpSocket_GetMaxMsgSize(handle);
	}
	static var _UdpSocket_GetMaxMsgSize = Lib.load("hxudp", "_UdpSocket_GetMaxMsgSize", 1);
	
	
	public function getTTL():Int {
		return _UdpSocket_GetTTL(handle);
	}
	static var _UdpSocket_GetTTL = Lib.load("hxudp", "_UdpSocket_GetTTL", 1);
	
	
	public function setTTL(nTTL:Int):Bool {
		return _UdpSocket_SetTTL(handle, nTTL);
	}
	static var _UdpSocket_SetTTL = Lib.load("hxudp", "_UdpSocket_SetTTL", 2);
	
}