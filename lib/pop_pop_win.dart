library pop_pop_win;

import 'dart:html';
import 'dart:math' as math;

import 'package:stagexl/stagexl.dart';

import 'package:pop_pop_win/platform_target.dart';
import 'package:pop_pop_win/src/html.dart';
import 'package:pop_pop_win/src/stage.dart';

part 'src/pop_pop_win/audio.dart';

const String _ASSET_DIR = 'resources/';

const String _TRANSPARENT_TEXTURE = '${_ASSET_DIR}images/transparent.json';
const String _OPAQUE_TEXTURE = '${_ASSET_DIR}images/opaque.json';
const String _TRANSPARENT_STATIC_TEXTURE = '${_ASSET_DIR}images/static.json';

void startGame(PlatformTarget platform) {
  initPlatform(platform);

  Stage stage = new Stage(querySelector('#gameCanvas'), webGL: true, color: 0xb4ad7f, frameRate: 60);
  RenderLoop renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  BitmapData.defaultLoadOptions.webp = true;

  //have to load the loading bar first...
  ResourceManager resourceManager = new ResourceManager();
  resourceManager
    ..addTextureAtlas("static", "resources/images/static.json", TextureAtlasFormat.JSON)
    ..load().then((r) {

    TextureAtlas ta = resourceManager.getTextureAtlas('static');

    var bar = new Gauge(ta.getBitmapData('loading_bar'), Gauge.DIRECTION_RIGHT)
      ..x = 51
      ..y = 8
      ..ratio = 0;

    var loadingSprite = new Sprite()
      ..addChild(new Bitmap(ta.getBitmapData('loading_background')))
      ..addChild(bar)
      ..addChild(new Bitmap(ta.getBitmapData('loading_text'))..x=141..y=10)
      ..x = stage.sourceWidth~/2-1008~/2
      ..y = 400
      ..scaleX = 2
      ..scaleY = 2
      ..addTo(stage);

    resourceManager
        ..addTextureAtlas('opaque', 'resources/images/opaque.json', TextureAtlasFormat.JSON)
        ..addTextureAtlas('animated', 'resources/images/animated.json', TextureAtlasFormat.JSON);
      
      resourceManager.addSoundSprite('audio', 'resources/audio/audio.json');

      resourceManager.onProgress.listen((e) {
        bar.ratio = resourceManager.finishedResources.length/resourceManager.resources.length;
      });

      resourceManager.load().then((r) {

        Tween tween = stage.juggler.tween(loadingSprite, .5)..animate.alpha.to(0);
        tween.onComplete = () => stage.removeChild(loadingSprite);

        _updateAbout();

        targetPlatform.aboutChanged.listen((_) => _updateAbout());

        var size = targetPlatform.size;
        var m = (size * size * 0.15625).toInt();

        var _audio = new _Audio(resourceManager);
        var gameRoot = new GameRoot(size, size, m, stage, resourceManager);

        // disable touch events
        window.onTouchMove.listen((args) => args.preventDefault());

        window.onKeyDown.listen(_onKeyDown);

        querySelector('#popup').onClick.listen(_onPopupClick);
        querySelectorAll('.difficulty a').onClick.listen(_onDifficultyClick);

        titleClickedEvent.listen((args) => targetPlatform.toggleAbout(true));

      }).catchError((error) {
        for(var resource in resourceManager.failedResources) {
          print("Loading resouce failed: "
              "${resource.kind}.${resource.name} - ${resource.error}");
        }
      });
  });
}

void _onPopupClick(args) {
  if (args.toElement is! AnchorElement) {
    targetPlatform.toggleAbout(false);
  }
}

void _onDifficultyClick(args) {
  window.location
      ..href = args.toElement.href
      ..reload();
}

void _onKeyDown(args) {
  var keyEvent = new KeyEvent.wrap(args);
  switch (keyEvent.keyCode) {
    case KeyCode.ESC: // esc
      targetPlatform.toggleAbout(false);
      break;
    case KeyCode.H: // h
      targetPlatform.toggleAbout();
      break;
  }
}

void _updateAbout() {
  var popDisplay = targetPlatform.showAbout ? 'inline-block' : 'none';
  querySelector('#popup').style.display = popDisplay;
}
