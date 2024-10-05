package ui;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class PlayUI extends FlxText
{
	public var score:Int = 0;

	public function new()
	{
		super(0, 0, FlxG.width);

		text = 'Score: $score';
		size = 4;
		setFormat(null, 16, FlxColor.RED, CENTER, OUTLINE, 0x131c1b);
		scrollFactor.set(0, 0);
	}

	public function collect(player:FlxObject, gem:FlxObject)
	{
		gem.kill();
		score += 1;
		text = 'Score: $score'; // Update Sccore Text
	}
}
