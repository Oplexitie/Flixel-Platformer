package;

import flixel.FlxSprite;

class Gem extends FlxSprite
{
	public function new(xPos:Float = 0, yPos:Float = 0)
	{
		super(xPos, yPos);

		loadGraphic(AssetPaths.gem__png, true);
		animation.add("shine", [0, 1, 2, 3, 4], 10, true);
		animation.play("shine");
	}
}
