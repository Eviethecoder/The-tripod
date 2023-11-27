package stages;

import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.ui.FlxBar;
import flixel.math.FlxRect;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.util.FlxSave;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.input.keyboard.FlxKey;
import flixel.addons.effects.FlxTrail;
import flixel.addons.display.FlxBackdrop;
import flixel.animation.FlxAnimationController;
import flixel.system.FlxAssets.FlxShader;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.system.scaleModes.WideScreenScale;
import flixel.system.scaleModes.StageSizeScaleMode;
import flixel.addons.transition.FlxTransitionableState;

import openfl.Lib;
import openfl.system.Capabilities;
import openfl.events.KeyboardEvent;
import openfl.utils.Assets as OpenFlAssets;

import StageData;
import FunkinLua;
import Song.SwagSong;
import objects.Note.EventNote;
import objects.*;
import DialogueBoxPsych;
import Conductor.Rating;
import Section.SwagSection;
import stages.BaseStage;
import animateatlas.AtlasFrameMaker;
import transition.*;

#if !flash
import openfl.display.Shader; //
import openfl.filters.ShaderFilter;
import flixel.addons.display.FlxRuntimeShader;
import shads.*;
#end

#if sys
import sys.io.File;
import sys.FileSystem;
#end
// DONT REMOVE THESE IMPORTS, U WILL BREAK MACRO

// IM TIRED FROM PLAYSTATE.HX 9000 LINES
@:access(PlayState)
@:allow(PlayState)
@:build(macros.GetVarsMacro.to())
class BaseStage {
	public var active:Bool = true;

	// shortcuts
	var game(get, never):PlayState;
	var curStep(get, never):Int;
	var curBeat(get, never):Int;
	var curSection(get, never):Int;
	/**
	 * Name of current song, for example `winter-horrorland`
	 */
	var songName(get, never):String;
	function add(obj:FlxBasic) game.add(obj);
	function remove(obj:FlxBasic) game.remove(obj);

	function startTween(obj:Dynamic, values:Dynamic, duration:Float = 1, ?options:TweenOptions):FlxTween {
		var tween:FlxTween = FlxTween.tween(obj, values, duration, options);
		var name:String = Math.random() + '';
		if (game.modchartTweens.exists(name)) {
			trace('WTF HOW U GOT THE SAME VALUE OF Math.random() ???????????????????');
			name = Math.random() + '';
		}

		game.modchartTweens.set(name, tween);
		return tween;
	}

	inline function get_songName():String return Paths.formatToSongPath(PlayState.SONG.song);
	inline function get_game():PlayState return PlayState.instance;
	inline function get_curStep():Int return PlayState.instance.curStep;
	inline function get_curBeat():Int return PlayState.instance.curBeat;
	inline function get_curSection():Int return PlayState.instance.curSection;

	public function new() {
		PlayState.instance.stages.push(this);
		trace('stage loaded successfully: ' + CoolUtil.getPackagePath(this));
		onCreate();
	}

	// init stuff
	function onCreate() {}
	function eventEarlyTrigger(event:String) {}
	function onStartCountdown() {} // set game.stopCountdown to true to stop it
	function onCountdownTick(counter:Int) {}
	function onCountdownStarted() {}
	function onSongStart() {}
	function onCreatePost() {}

	// updatin stuff
	function onUpdate(elapsed:Float) {}
	function onUpdatePost(elapsed:Float) {}
	function onUpdateScore(miss:Bool) {}
	function onStepHit() {}
	function onBeatHit() {}
	function onSectionHit() {}
	function onRecalculateRating() {} // set game.stopRecalculateRating to true to stop it
	function onResume() {}
	function onPause() {} // set game.stopPause to true to stop it
	function onMoveCamera(char:String) {}
	function onEvent(eventName:String, value1:String, value2:String) {}

	// dialogue stuff
	function onNextDialogue(dialogueCount:Float) {}
	function onSkipDialogue(dialogueCount:Bool) {}

	// end stuff
	function onEndSong() {} // set game.stopEndSong to true to stop it
	function onGameOver() {} // set game.stopGameOver to true to stop it
	function onGameOverStart() {}
	function onGameOverConfirm(end:Bool) {}
	function onDestroy() {}

	// note pressing/missing stuff
	function onSpawnNote(index:Int, noteData:Int, noteType:String, isSustainNote:Bool) {}
	function onKeyPress(key:Int) {}
	function onKeyRelease(key:Int) {}
	function opponentNoteHit(index:Int, noteData:Int, noteType:String, isSustainNote:Bool) {}
	function goodNoteHit(index:Int, noteData:Int, noteType:String, isSustainNote:Bool) {}
	function onGhostTap(key:Int) {}
	function noteMissPress(noteData:Int) {}
	function noteMiss(index:Int, noteData:Int, noteType:String, isSustainNote:Bool) {}

	// useless functions but it need to be here cuz i using Reflect stuff in callOnLuas
	function onTimerCompleted(tag:String, loops:Int, loopsLeft:Int) {}
	function onTweenCompleted(tag:String) {}
	function onSoundFinished(tag:String) {}
	function onCustomSubstateCreate(name:String) {}
	function onCustomSubstateCreatePost(name:String) {}
	function onCustomSubstateUpdate(name:String, elapsed:Float) {}
	function onCustomSubstateUpdatePost(name:String, elapsed:Float) {}
	function onCustomSubstateDestroy(name:String) {}
}