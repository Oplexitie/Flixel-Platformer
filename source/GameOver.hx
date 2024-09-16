import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class GameOver extends FlxSubState
{
	var victtxt:FlxText = null;
	var next_lvl:Int = 0;

	public function new(lvl_id:Int = 0)
	{
		next_lvl = lvl_id + 1;
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
			switch next_lvl
			{
				case 2:
					FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
					{
						// Move to level 2
						FlxG.switchState(new PlayState(2));
					});
				case 3:
					FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
					{
						// Go back to menu
						FlxG.switchState(new MenuState());
					});
			}
		}
	}
}
