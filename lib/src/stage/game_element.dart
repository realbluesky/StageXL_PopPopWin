part of pop_pop_win.stage;

class GameElement extends Sprite {
  static const _edgeOffset = 32;
  static const _backgroundSize = const Size(2048, 1536);
  static const _backgroundEdgeOffset = 256;
  static const _backgroundHoleSize = 16 * SquareElement._size + 2 * _edgeOffset;
  static const _boardOffset = const Size(352, 96);
    
  GameRoot _gameRoot;
  
  GameBackgroundElement _gameBackground;
  BoardElement _boardElement;
  SimpleButton _newGameButton, _logoButton;
  TextField _statsTextField;
  num _boardSize, _boardScale;

  //---------------------------------------------------------------------------------------------------

  GameElement(GameRoot gameRoot) {
    _gameRoot = gameRoot;

    TextureAtlas opa = resourceManager.getTextureAtlas('opaque');
    TextureAtlas sta = resourceManager.getTextureAtlas('static');

    _boardSize = game.field.width * SquareElement._size + 2 * _edgeOffset;
    //_backgroundScale = 1376/_boardSize;
    _boardScale = _backgroundHoleSize / _boardSize;

    _gameBackground = new GameBackgroundElement(this, opa);    
        
    Bitmap newButtonNormal = new Bitmap(sta.getBitmapData("button_new_game"));
    Bitmap newButtonPressed = new Bitmap(sta.getBitmapData("button_new_game_clicked"));

    _newGameButton = new SimpleButton(newButtonNormal, newButtonPressed, newButtonPressed, newButtonPressed)
        ..x = 450
        ..y = 20
        ..onMouseClick.listen((e) => manager.newGame())
        ..addTo(this);
    
    _boardElement = new BoardElement(this)
      ..x = 352 + _edgeOffset * _boardScale 
      ..y = 96 + _edgeOffset * _boardScale;
    
    _statsTextField = new TextField()
      ..defaultTextFormat = new TextFormat('Slackey, cursive', 28, Color.Black, leading: 3)
      ..autoSize = TextFieldAutoSize.LEFT
      ..x = 1400
      ..y = 20
      ..addTo(this);
    _gameRoot.bestTimeMilliseconds.then((v) => _statsTextField.text = 'Bombs Left: \nTime: \nRecord: '+(v == null?'':(v~/1000).toString()));
    
    Bitmap logo = new Bitmap(sta.getBitmapData('logo_win'));
    _logoButton = new SimpleButton(logo, logo, logo, logo);
    _logoButton
        ..y = 20
        ..scaleX = 1.5
        ..scaleY = 1.5
        ..x = _backgroundSize.width/2 - _logoButton.width/2
        ..onMouseClick.listen((e) => _titleClickedEventHandle.add(EventArgs.empty))
        ..addTo(this);

  }
  
  GameRoot get manager => _gameRoot;
  Game get game => _gameRoot.game;
  ResourceManager get resourceManager => _gameRoot.resourceManager;
  
}