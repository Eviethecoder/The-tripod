package stages.objects;

class SuperZoomShit extends BaseStage {
	public var zoom:Bool = false;
	public var superZoom:Bool = false;

	override function onBeatHit() {
		if (curBeat % 2 == 0 && zoom) {
			camGame.zoom += 0.06;
			camHUD.zoom += 0.08;
		}
		if (curBeat % 1 == 0 && superZoom) {
			camGame.zoom += 0.06;
			camHUD.zoom += 0.08;
		}
	}
}