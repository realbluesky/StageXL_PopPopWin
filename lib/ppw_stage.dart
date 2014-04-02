library ppw_stage;

import 'dart:html';
import 'dart:web_audio';
import 'package:bot/bot.dart';
import 'package:stagexl/stagexl.dart';

import 'package:pop_pop_win/src/stage.dart';
import 'package:pop_pop_win/platform_target.dart';
import 'package:pop_pop_win/src/html.dart';

part 'src/ppw_stage/audio.dart';

const String _ASSET_DIR = 'resources/';

const String _TRANSPARENT_TEXTURE = '${_ASSET_DIR}images/transparent.json';
const String _OPAQUE_TEXTURE = '${_ASSET_DIR}images/opaque.json';
const String _TRANSPARENT_STATIC_TEXTURE = '${_ASSET_DIR}images/static.json';

//final _Audio _audio = new _Audio();

Stage stage;
RenderLoop renderLoop;
ResourceManager resourceManager;

Sprite loadingSprite;
Bitmap bar;

void startGame(PlatformTarget platform) {
  initPlatform(platform);

  stage = new Stage(querySelector('#gameCanvas'), webGL: true, color: 0xb4ad7f);
  renderLoop = new RenderLoop();
  renderLoop.addStage(stage);
  
  //TODO create webp versions of image assets
  //BitmapData.defaultLoadOptions.webp = true;
  
  //have to load the loading bar first...
  resourceManager = new ResourceManager()
    ..addTextureAtlas("static", "resources/images/static.json", TextureAtlasFormat.JSON)
    ..load().then((res) {
    
    TextureAtlas ta = res.getTextureAtlas('static');
    
    bar = new Bitmap(ta.getBitmapData('loading_bar'))
      ..x = 51
      ..y = 8
      ..width = 0;
    
    loadingSprite = new Sprite()
      ..addChild(new Bitmap(ta.getBitmapData('loading_background')))
      ..addChild(bar)
      ..addChild(new Bitmap(ta.getBitmapData('loading_text'))..x=141..y=10)
      ..x = 1200~/2-504~/2
      ..y = 200
      ..addTo(stage);
    
    _loadResources();
    
  });
  
}

void _loadResources() {

  resourceManager
    ..addTextureAtlas('opaque', 'resources/images/opaque.json', TextureAtlasFormat.JSON)
    ..addTextureAtlas('animated', 'resources/images/animated.json', TextureAtlasFormat.JSON);
  
  var sounds = ['Pop0', 'Pop1', 'Pop2', 'Pop3', 'Pop4', 'Pop5', 'Pop6', 'Pop7', 'Pop8',
                'Bomb0', 'Bomb1', 'Bomb2', 'Bomb3', 'Bomb4',
                'throw', 'flag', 'unflag', 'click', 'win'];
  
  //TODO use sound sprites if Bernhard merges PR 
  sounds.forEach((s) => resourceManager.addSound(s, 'resources/audio/$s.mp3')); 
        
  resourceManager.onProgress.listen((e) {
    bar.width = 398 * resourceManager.finishedResources.length~/resourceManager.resources.length;
  });
     
  resourceManager.load().then((res) {

    Tween tween = stage.juggler.tween(loadingSprite, .5)..animate.alpha.to(0);
    tween.onComplete = () => stage.removeChild(loadingSprite); 
    
    _updateAbout();

    targetPlatform.aboutChanged.listen((_) => _updateAbout());

    final size = targetPlatform.renderBig ? 16 : 7;
    final int m = (size * size * 0.15625).toInt();

    //final gameRoot = new GameRoot(size, size, m, gameCanvas, textureData);
    final gameView = new GameView(size, size, m, querySelector('#game'), querySelector('#left'), querySelector('#state'), querySelector('#clock'));

    // disable touch events
    window.onTouchMove.listen((args) => args.preventDefault());

    window.onKeyDown.listen(_onKeyDown);

    querySelector('#popup').onClick.listen(_onPopupClick);

    titleClickedEvent.listen((args) => targetPlatform.toggleAbout(true));
      
    /*
    GameElement gameElement = new GameElement(resourceManager)..alpha=0;
    stage.addChild(gameElement);
    stage.juggler.tween(gameElement, .5)..animate.alpha.to(1);
    */

  }).catchError((error) {

    for(var resource in resourceManager.failedResources) {
      print("Loading resouce failed: ${resource.kind}.${resource.name} - ${resource.error}");
    }
  });
}

void _onPopupClick(args) {
  if (args.toElement is! AnchorElement) {
    targetPlatform.toggleAbout(false);
  }
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
