package utils;

import flixel.FlxG;

class InputKeys
{
	public static function is_up_pressed(?usejustpressed:Bool = false):Bool
	{
		var upKeyPressed = usejustpressed ? FlxG.keys.anyJustPressed([UP]) : FlxG.keys.anyPressed([UP]);
		return upKeyPressed;
	}

	public static function is_down_pressed(?usejustpressed:Bool = false):Bool
	{
		var downKeyPressed = usejustpressed ? FlxG.keys.anyJustPressed([DOWN]) : FlxG.keys.anyPressed([DOWN]);
		return downKeyPressed;
	}

	public static function is_left_pressed(?usejustpressed:Bool = false):Bool
	{
		var leftKeyPressed = usejustpressed ? FlxG.keys.anyJustPressed([LEFT]) : FlxG.keys.anyPressed([LEFT]);
		return leftKeyPressed;
	}

	public static function is_right_pressed(?usejustpressed:Bool = false):Bool
	{
		var rightKeyPressed = usejustpressed ? FlxG.keys.anyJustPressed([RIGHT]) : FlxG.keys.anyPressed([RIGHT]);
		return rightKeyPressed;
	}
}
