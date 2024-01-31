package;

import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	private var isOldIcon:Bool = false;
	public var isPlayer:Bool = false;
	private var char:String = '';
	public var icontype:String = '';
	var animatedIconStage = "normal";
	public var oldx:Float = 0;
	public var oldy:Float = 0;
	public var scalevar:Float = 1.2;
	/// Icon Bops
	var iconBopTween:FlxTween;
	public var characters:String;

	

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		isOldIcon = (char == 'bf-old');
		this.isPlayer = isPlayer;
		changeIcon(char);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 12, sprTracker.y - 30);
	}

	public function swapOldIcon() {
		if(isOldIcon = !isOldIcon) changeIcon('bf-old');
		else changeIcon('bf');
	}

	private var iconOffsets:Array<Float> = [0, 0];
	public function changeIcon(char:String) {
		 characters = char;
		 trace(characters);
		if(this.char != char) {
			var name:String = 'icons/' + char;
			
			
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + char; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon
			var file:Dynamic = Paths.image(name);
			

			loadGraphic(file); //Load stupidly first for getting the file size

			if (FileSystem.exists(Paths.getPath('images/' + name + '.xml', TEXT)))
				{
					frames = Paths.getSparrowAtlas(name);
					animation.addByPrefix('win', 'win', 24, true, isPlayer);
					animation.addByPrefix('normal', 'normal', 24, true, isPlayer);
					animation.addByPrefix('loose', 'loose', 24, true, isPlayer);
					icontype = 'animated';
				}
			else
				{

				
				switch(width){

					default:
						loadGraphic(file, true, Math.floor(width / 2), Math.floor(height)); //Then load it fr
						icontype = 'default';
	
					case(450):
						loadGraphic(file, true, Math.floor(width / 3), Math.floor(height)); //starting the winning icon stuffs
						icontype = 'win';
	
					case (750):
						loadGraphic(file, true, Math.floor(width / 5), Math.floor(height)); //starting the winning icon stuffs
						icontype = 'dr.h';
	
					
	
				}
			}

			
			
			

			switch (icontype){ //initiate the icon animation shit 

				case ('default'):
					iconOffsets[0] = (width - 150) / 2; 
					iconOffsets[1] = (width - 150) / 2;
					animation.add(char, [0, 1], 0, false, isPlayer);
				case ('win'):
					iconOffsets[0] = (width - 150) / 3;
					iconOffsets[1] = (width - 150) / 3;
					iconOffsets[2] = (width - 150) / 3;
					animation.add(char, [0, 1, 2], 0, false, isPlayer);
			}
			updateHitbox();

			
			animation.play(char);
			this.char = char;

			antialiasing = ClientPrefs.globalAntialiasing;
			if(char.endsWith('-pixel')) {
				antialiasing = false;
			}
		}
	}

	override function updateHitbox()
	{
		super.updateHitbox();
		offset.x = iconOffsets[0];
		offset.y = iconOffsets[1];
	}

	public function getCharacter():String {
		return char;
	}

	public dynamic function updateAnim(health:Float){
		

		var num:Int = Math.floor(Math.max(Math.min(Math.floor(health / 20), 4), 0));
		switch (icontype){
			case('default'):
			
				animation.curAnim.curFrame = (health < 20) ? 1 : 0;
	
			case('win'):
				if (health < 20)
					animation.curAnim.curFrame = 1;
				else if (health > 80 )
					animation.curAnim.curFrame = 2;
				else
					animation.curAnim.curFrame = 0;

			case 'animated':
                if ((health < 20) && (animation.getByName("loose") != null)) {
                    animatedIconStage = "loose";
					animation.play("loose");
                } else if ((health > 80) && (animation.getByName("win") != null)) {
                    animatedIconStage = "win";
					animation.play("win");
                } else if (animation.getByName("normal") != null) {
                    animatedIconStage = "normal";
					animation.play("normal");

	}
}
	}
	

	public dynamic function updateIconsScale(elapsed:Float,play:Float)
		{
			var mult:Float = FlxMath.lerp(1, this.scale.x, FlxMath.bound(1 - (elapsed * 9 * play), 0, 1));
			scale.set(mult, mult);
			updateHitbox();
	
			
		}

	public dynamic function iconbop(health:Float){
		
		scale.set(scalevar, scalevar);
		

		switch(characters){
			default:
				if (isPlayer == true){
					if (health <20){
						angle = 20;
						scalevar = 0.8;
					}
					else{
						angle = -20;
						scalevar = 1.2;
					}
				}
				else{
					if (health <20){
						angle = -20;
						scalevar = 0.8;
					}
					else{
						angle = 20;
						scalevar = 1.2;
					}
				}
				scale.set(scalevar, scalevar);
				iconBopTween = FlxTween.tween(this, {angle: 0}, 0.2, {
					onComplete: function(twn:FlxTween) {
						iconBopTween = null;
					}
				});
				

				
		}
			
		updateHitbox();

	}

}
