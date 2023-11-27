package stages.objects;

import openfl.geom.Rectangle;

class CinematicBars extends BaseStage {
	var cinematicBars:FlxSprite;
	var defaultNoteY:Float;
	var cinematicLowered:Bool = false;
	public var barsHeight(default, set):Float = 170;

	inline function set_barsHeight(barsHeight:Float) {
		// clear all bitmap
		cinematicBars.pixels.fillRect(new Rectangle(0, 0, cinematicBars.width, cinematicBars.height), 0);

		// upper bar
		cinematicBars.pixels.fillRect(new Rectangle(0, 0, FlxG.width, barsHeight), 0xff000000);
		// bottom bar
		cinematicBars.pixels.fillRect(new Rectangle(0, FlxG.height - barsHeight, FlxG.width, barsHeight), 0xff000000);

		return this.barsHeight = barsHeight;
	}

	override function onCreate() {
		cinematicBars = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0);
		barsHeight += 0; // update some bitches
		cinematicBars.scale.set(1.9, 1.9);
		cinematicBars.screenCenter();
		cinematicBars.camera = game.camOverlay;
	}

	override function onCreatePost() {
		defaultNoteY = game.strumLineNotes.members[0].y;

		game.notes.camera = game.camOverlay;
		game.remove(game.notes, true);
		game.insert(game.length - 1, game.notes);
		game.insert(game.length - 2, cinematicBars);
	}

	public function cinematicSwitch(?duration:Float = 1, ?withNotes:Bool = false) {
		var scaleVal:Float = cinematicLowered ? 1.9 : 1;
		var yVal:Float = cinematicLowered ? defaultNoteY : (ClientPrefs.downScroll ? FlxG.height - barsHeight * 2 + 20 : barsHeight + 10);

		if (withNotes) for (note in game.strumLineNotes)
			startTween(note, {y: yVal}, duration, {ease: FlxEase.quartOut});

		startTween(cinematicBars.scale, {x: scaleVal, y: scaleVal}, duration, {
			ease: FlxEase.quartOut,
			onUpdate: twn -> {
				cinematicBars.screenCenter();
			}
		});
		cinematicLowered = !cinematicLowered;
	}
}