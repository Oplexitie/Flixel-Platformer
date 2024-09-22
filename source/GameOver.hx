import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class GameOver extends FlxSubState
{
	var vict_txt:FlxText = null;
	var completed_lvl:Int = 0;

	public function new(lvl_id:Int = 0)
	{
		completed_lvl = lvl_id;
		super(0x52000000);
	}

	override public function create()
	{
		super.create();
		vict_txt = new FlxText(0, 0, 0, "Game Over", 16);
		vict_txt.screenCenter(XY);
		vict_txt.scrollFactor.set(0, 0);
		add(vict_txt);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.ENTER)
		{
			switch completed_lvl
			{
				case 1:
					FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
					{
						// Move to level 2
						FlxG.switchState(new PlayState(2));
					});
				case 2:
					FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
					{
						// Go back to menu
						FlxG.switchState(new MenuState());
					});
			}
		}
	}
}
