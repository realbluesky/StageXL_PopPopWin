library pop_pop_win;

import 'dart:async';
import 'dart:math' as math;
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'package:bot/bot.dart' as bot;


part '../lib/background_element.dart';
part '../lib/board_element.dart';
part '../lib/field.dart';
part '../lib/game.dart';
part '../lib/game_element.dart';
part '../lib/game_manager.dart';
part '../lib/game_root.dart';
part '../lib/game_state.dart';
part '../lib/game_storage.dart';
//part '../lib/game_view.dart';
//part '../lib/high_score_view.dart';
part '../lib/platform_target.dart';
part '../lib/platform_web.dart';
part '../lib/square_element.dart';
part '../lib/square_state.dart';

Stage stage;
RenderLoop renderLoop;
ResourceManager resourceManager;

Sprite loadingSprite;
Bitmap bar;

void main() {

  stage = new Stage(html.querySelector('#gameCanvas'), webGL: true, color: 0xb4ad7f);
  renderLoop = new RenderLoop();
  renderLoop.addStage(stage);
  
  html.querySelector('#popup').onClick.listen((e) {
    if(e.toElement is! html.AnchorElement) html.querySelector('#popup').style.display = 'none';
  });

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
      ..x = 1000~/2-504~/2
      ..y = 200
      ..addTo(stage);
    
    loadResources();
    
  });
  
}

void loadResources() {

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
    
    var size = 7;
    int bombs = size * size ~/6.4;
    
    //I have this messed up - HALP!
    //GameRoot gameRoot = new GameRoot(size, size, bombs, stage, resourceManager);
    GameElement gameElement = new GameElement(resourceManager)..alpha=0;
    stage.addChild(gameElement);
    stage.juggler.tween(gameElement, .5)..animate.alpha.to(1);
    

  }).catchError((error) {

    for(var resource in resourceManager.failedResources) {
      print("Loading resouce failed: ${resource.kind}.${resource.name} - ${resource.error}");
    }
  });
}

PlatformTarget _platformImpl;

void initPlatform(PlatformTarget value) {
  assert(value != null);
  assert(!value.initialized);
  assert(_platformImpl == null);
  _platformImpl = value;
  _platformImpl.initialize();
}

PlatformTarget get targetPlatform {
  if (_platformImpl == null) {
    initPlatform(new PlatformTarget());
  }
  return _platformImpl;
}


