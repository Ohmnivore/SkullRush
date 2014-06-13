package insomnia;

import cpp.Lib;

/**
 * ...
 * @author Ohmnivore
 */

class Insomnia
{
	//Flags
	static public var ES_AWAYMODE_REQUIRED = 0x00000040;
	static public var ES_CONTINUOUS = 0x80000000;
	static public var ES_DISPLAY_REQUIRED = 0x00000002;
	static public var ES_SYSTEM_REQUIRED = 0x00000001;
	
	static public var P_ABOVE_NORMAL_PRIORITY_CLASS = 0x00008000;
	static public var P_BELOW_NORMAL_PRIORITY_CLASS = 0x00004000;
	static public var P_HIGH_PRIORITY_CLASS = 0x00000080;
	static public var P_IDLE_PRIORITY_CLASS = 0x00000040;
	static public var P_NORMAL_PRIORITY_CLASS = 0x00000020;
	static public var P_PROCESS_MODE_BACKGROUND_BEGIN = 0x00100000;
	static public var P_PROCESS_MODE_BACKGROUND_END = 0x00200000;
	static public var P_REALTIME_PRIORITY_CLASS = 0x00000100;
	
	/**
	 * Surefire way of preventing the computer from sleeping (yet allows the screen to shutdown)
	 * 
	 * @return	Returns wether the operation was successful or not
	 */
	static public function preventSleep():Bool
	{
		var result:Bool = false;
		
		result = setThreadExecutionState(ES_CONTINUOUS | ES_SYSTEM_REQUIRED | ES_AWAYMODE_REQUIRED);
		if (!result)
		{
			result = setThreadExecutionState(ES_CONTINUOUS | ES_SYSTEM_REQUIRED);
		}
		
		return result;
	}
	
	/**
	 * Used most commonly to stop the display/computer from sleeping
	 * 
	 * @param	Flag	You can merge several flags using | (ex: ES_AWAYMODE_REQUIRED |  ES_CONTINUOUS)
	 * @return	Returns wether the operation was successful or not
	 */
	static public function setThreadExecutionState(Flag:Int):Bool
	{
		return _set_thread_execution_state(Flag);
	}
	
	/**
	 * Used most commonly to stop the display/computer from sleeping
	 * 
	 * @param	Flag	Don't merge flags. Single flags only should be passed.
	 * @return	Returns wether the operation was successful or not
	 */
	static public function setProcessPriority(Flag:Int):Bool
	{
		return _set_process_priority(Flag);
	}
	
	//C/C++ external function loading
	static var _set_thread_execution_state = Lib.load("Insomnia", "set_state", 1);
	static var _set_process_priority = Lib.load("Insomnia", "set_priority", 1);
}