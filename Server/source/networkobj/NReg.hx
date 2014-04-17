package networkobj;

/**
 * ...
 * @author Ohmnivore
 */
class NReg
{
	
	static private var _ID:Int = 0;
	
	static public function getID():Int 
	{
		return _ID;
		_ID++;
	}
	
}