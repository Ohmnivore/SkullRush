package ext;

/**
 * ...
 * @author Ohmnivore
 */
class FlxMarkup 
{
	public var bold:Bool;
	public var color:Int;
	public var startindex:Int;
	public var endindex:Int;
	
	/**
	 * Object to be passed to MarkupText's constructor/Markitup function
	 * 
	 * @param	Startindex		Zero-based, specifies first included character.
	 * @param	Endindex		First character after the markup, also zero-based.
	 * @param	Size			The size. Default is the flixel default (8).
	 * @param	Color			Markup color. Duh. Default is white like Tide!
	 */
	public function new(Startindex:Int, Endindex:Int, Bold:Bool = false, Color:Int = 0xffffffff)
	{
		startindex = Startindex;
		endindex = Endindex;
		bold = Bold;
		color = Color;
	}
}