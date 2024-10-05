package states.substates;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;

class PauseMenu extends FlxSubState
{
	var pausetxt:FlxText = null;

	public function new()
	{
		super(0x52000000);
	}

	override public function create()
	{
		super.create();

		pausetxt = new FlxText(0, 0, 0, "Game Paused!", 16);
		pausetxt.screenCenter(XY);
		pausetxt.scrollFactor.set(0, 0);
		add(pausetxt);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.ENTER)
		{
			close();
		}
	}
}
