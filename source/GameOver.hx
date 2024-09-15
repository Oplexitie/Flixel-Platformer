import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;

class GameOver extends FlxSubState
{
	var victtxt:FlxText = null;

	public function new()
	{
		super(0x52000000);
	}

	override public function create()
	{
		super.create();
		victtxt = new FlxText(0, 0, 0, "Game Over", 16);
		victtxt.screenCenter(XY);
		victtxt.scrollFactor.set(0, 0);
		add(victtxt);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.ENTER)
		{
			close();
			FlxG.resetState();
		}
	}
}
