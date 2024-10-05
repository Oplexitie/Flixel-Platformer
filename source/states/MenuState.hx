package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;

class MenuState extends FlxState
{
	var bg:FlxSprite = null;
	var title:FlxSprite = null;
	var pressenter:FlxSprite = null;
	var counter:Int = 0;

	override public function create()
	{
		super.create();
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		bgColor = 0xFF47F3FF;

		// Setup Menu Backgroun and Titlecard sprite
		bg = new FlxSprite(0, 0, AssetPaths.bg_sunny__png);
		title = new FlxSprite(0, 0, AssetPaths.title_screen__png);
		title.setPosition(FlxG.width / 2 - title.width / 2, FlxG.height / 2 - title.height);
		add(bg);
		add(title);

		// Setup 'Press Enter' sprite
		pressenter = new FlxSprite(0, 0, AssetPaths.press_enter_text__png);
		pressenter.setPosition(FlxG.width / 2 - pressenter.width / 2, FlxG.height / 2 - pressenter.height + 64);
		add(pressenter);

		FlxG.mouse.visible = false;
		FlxG.autoPause = false;
	}

	function blink()
	{
		counter += 1;
		if (counter >= 25)
		{
			if (pressenter.alpha == 0.1)
			{
				pressenter.alpha = 1;
			}
			else
			{
				pressenter.alpha = 0.1;
			}
			counter = 0;
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		blink(); // Makes the Press Enter sprite Blink on and off

		if (FlxG.keys.justPressed.ENTER)
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
			{
				// Start PlayState in Level 1
				FlxG.switchState(new PlayState(1));
			});
		}
	}
}
