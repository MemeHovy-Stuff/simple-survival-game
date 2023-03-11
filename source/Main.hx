package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		addChild(new FlxGame(0, 0, PlayState, 1000, 1000, true));
	}

	/**
	 * Create a thread to run a specific task, allows running the same task even if creating threads is not possible.
	 * @param task Function
	 * @param allowNonThread Allow `task` to run even if threading isn't possible, defaults to `true`.
	 */
	public static function createThread(task:Void->Void, allowNonThread:Bool = true)
	{
		#if (target.threaded)
		sys.thread.Thread.create(() ->
		{
			task();
		});
		#else
		if (allowNonThread)
			task(); // do it anyways LOL
		#end
	}
}
