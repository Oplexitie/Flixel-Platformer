package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;

class Player extends FlxSprite
{
	// Player Stats
	var SPEED(default, never):Float = 100;
	var JUMP_STRENGTH(default, never):Float = 220;
	var GRAVITY(default, never):Float = 800;

	// Grounded State
	var is_grounded:Bool = false;
	var was_grounded:Bool = false; // Grounded state from previous update cycle

	// Variable Jump Height related
	var jump_timer:FlxTimer;
	var is_jumping:Bool = false; // Not the same as !is_grounded
	var JUMP_LENGTH(default, never):Float = 0.2; // Length until holding jump doesn't work anymore

	// Coyote Time Related
	var coyote_time:Float; // The amount of time left before you can't coyote jump anymore
	var COYOTE_LENGTH(default, never):Float = 0.15; // The amount of time where you'll still be able to jump after falling off a ledge

	// Jump Buffer Related (takes early jump press into account)
	var jump_buffer_time:Float;
	var JUMP_BUFFER_LENGTH(default, never):Float = 0.1; // Time before landing where a jump press is still taken into account

	public function new(xPos:Float = 0, yPos:Float = 0)
	{
		super(xPos, yPos);

		// Load player graphic and setup collision box
		loadGraphic(AssetPaths.playerspr__png, true, 33, 32);
		width = 15;
		height = 20;
		offset.set(9, 12);
		origin.set(16, 32);

		// Setup for player animations
		setFacingFlip(LEFT, true, false);
		setFacingFlip(RIGHT, false, false);
		animation.add("idle", [6, 7, 8, 9], 6, false);
		animation.add("jump", [10], 6, false);
		animation.add("down", [11], 6, false);
		animation.add("run", [0, 1, 2, 3, 4, 5], 7, false);

		// Player physics setup
		drag.x = SPEED * 8;
		acceleration.y = GRAVITY;
		maxVelocity.set(100, GRAVITY);

		jump_timer = new FlxTimer();
	}

	function handle_movement()
	{
		// Handles Inputs
		var left:Bool = FlxG.keys.anyPressed([LEFT]);
		var right:Bool = FlxG.keys.anyPressed([RIGHT]);

		// Takes care of movement, facing direction and animations
		if (right && left || !right && !left)
		{
			if (is_grounded)
			{
				animation.play("idle");
			}
		}
		else if (right || left)
		{
			facing = FlxG.keys.pressed.LEFT ? LEFT : RIGHT;
			if (is_grounded)
			{
				if (velocity.x != 0)
				{
					animation.play("run");
				}
				else
				{
					animation.play("idle");
				}
			}
			velocity.x = FlxG.keys.pressed.LEFT ? -SPEED : SPEED;
		}
	}

	function handle_jump(elapsed:Float)
	{
		// Resets sprite scale from squash and stretch
		if (!is_jumping)
		{
			scale.x = FlxMath.lerp(scale.x, 1, 0.2);
			scale.y = FlxMath.lerp(scale.y, 1, 0.2);
		}

		// Checks if you're touching the floor
		is_grounded = isTouching(FLOOR);

		if (is_grounded)
		{
			// Applies the ground squash only if you just landed on the ground
			if (!was_grounded)
			{
				scale.set(1.25, 0.75);
			}

			coyote_time = COYOTE_LENGTH; // Reset coyote time when landing
		}
		else
		{
			// Handles jumping and falling animations
			if (velocity.y <= 0)
			{
				animation.play("jump");
			}
			else
			{
				animation.play("down");
			}

			coyote_time -= elapsed;
		}

		was_grounded = is_grounded;

		if (is_up_pressed(true))
		{
			jump_buffer_time = JUMP_BUFFER_LENGTH;
		}

		// Checks if you can jump, then allows it if you can
		if (jump_buffer_time >= 0)
		{
			jump_buffer_time -= elapsed;

			if (coyote_time > 0)
			{
				scale.set(0.75, 1.5);
				is_jumping = true;
				coyote_time = 0;
			}
		}

		// Applies the jump physics but cancels them if you let go of the jump button
		if (is_jumping == true)
		{
			if (!jump_timer.active)
			{
				jump_timer.start(JUMP_LENGTH, end_jump, 1);
			}

			velocity.y = -JUMP_STRENGTH;

			if (!is_up_pressed())
			{
				is_jumping = false;
			}
		}
	}

	function end_jump(timer:FlxTimer)
	{
		is_jumping = false;
	}

	function is_up_pressed(?usejustpressed:Bool = false):Bool
	{
		var upKeyPressed = usejustpressed ? FlxG.keys.anyJustPressed([UP]) : FlxG.keys.anyPressed([UP]);
		return upKeyPressed;
	}

	override function update(elapsed:Float)
	{
		handle_jump(elapsed);
		handle_movement();

		super.update(elapsed);
	}
}
