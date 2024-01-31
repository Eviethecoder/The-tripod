import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxFrame;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import flixel.animation.FlxAnimationController;

class FnfAnimationController extends FlxAnimationController {

    public static var globalSpeed:Float = 1;
	public var followGlobalSpeed:Bool = true;
	override function update(elapsed:Float):Void
	{
		if (_curAnim != null)
		{
			var e:Float = elapsed;
			if(followGlobalSpeed) e *= globalSpeed;

			_curAnim.update(e);
		}
		else if (_prerotated != null)
		{
			_prerotated.angle = _sprite.angle;
		}
	}
}