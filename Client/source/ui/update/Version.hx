package ui.update;

/**
 * ...
 * @author Ohmnivore
 */
class Version
{
	public var major:Int;
	public var minor:Int;
	public var bug:Int;
	
	public function new(S:String) 
	{
		makeFromString(S);
	}
	
	private function makeFromString(S:String)
	{
		var maj_ind:Int = S.indexOf(".");
		var min_ind:Int = S.indexOf(".", maj_ind + 1);
		
		major = Std.parseInt(S.substr(0, maj_ind));
		minor = Std.parseInt(S.substring(maj_ind + 1, min_ind));
		bug = Std.parseInt(S.substring(min_ind + 1, S.length));
		//trace(major, ".", minor, ".", bug);
	}
	
	public function isMoreRecent(Compare:Version):Bool
	{
		var ret:Bool = false;
		
		if (major > Compare.major)
		{
			ret = true;
			return ret;
		}
		if (major < Compare.major)
		{
			ret = false;
			return ret;
		}
		if (minor > Compare.minor)
		{
			ret = true;
			return ret;
		}
		if (minor < Compare.minor)
		{
			ret = false;
			return ret;
		}
		if (bug > Compare.bug)
		{
			ret = true;
			return ret;
		}
		if (bug < Compare.bug)
		{
			ret = false;
			return ret;
		}
		
		return ret;
	}
	
}