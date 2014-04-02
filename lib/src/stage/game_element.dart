part of pop_pop_win.stage;

class GameElement extends Sprite {
  
  ResourceManager _resourceManager;
  GameRoot _gameRoot;
  TextureAtlas _opaqueAtlas;
  
  SimpleButton _newGameButton;
  SimpleButton _logoButton;
  TextField _scoreTextField;

  int _edgeTiles;
  Game _game;

  //---------------------------------------------------------------------------------------------------

  GameElement(/*GameRoot gameRoot, */ResourceManager resourceManager) {

    //_gameRoot = gameRoot;
    _resourceManager = resourceManager;
    //_edgeTiles = gameRoot._width;
    _edgeTiles = 7;
    
    _opaqueAtlas = _resourceManager.getTextureAtlas('opaque');
    TextureAtlas sta = _resourceManager.getTextureAtlas('static');
    
    addChild(new BackgroundElement(_opaqueAtlas, _edgeTiles));
    
    //this also blows up...
    //addChild(new BoardElement());
    
    Bitmap newButtonNormal = new Bitmap(sta.getBitmapData("button_new_game"));
    Bitmap newButtonPressed = new Bitmap(sta.getBitmapData("button_new_game_clicked"));

    _newGameButton = new SimpleButton(newButtonNormal, newButtonPressed, newButtonPressed, newButtonPressed)
      ..scaleX = .8
      ..scaleY = .8
      ..x = 200
      ..y = 20
      ..addEventListener(MouseEvent.CLICK, _onNewGameButtonClick)
      ..addTo(this);
    
    Bitmap logo = new Bitmap(sta.getBitmapData('logo_win'));
    _logoButton = new SimpleButton(logo, logo, logo, logo)
      ..x = 600-logo.width/2
      ..y = 20
      ..addEventListener(MouseEvent.CLICK, _onLogoClick)
      ..addTo(this);
    
  }
  
  Game get game => _game;

  void set game(Game value) {
    _game = value;
  }

  /*
  bool get canRevealTarget =>
      _targetX != null && _game.canReveal(_targetX, _targetY);

  bool get canFlagTarget =>
      _targetX != null && _game.canToggleFlag(_targetX, _targetY);

  void setGameManager(GameManager manager) {
    _scoreElement.setGameManager(manager);
  }

  void revealTarget() {
    if (_targetX != null) {
      game.reveal(_targetX, _targetY);
      _target(null, null);
    }
  }

  void toggleTargetFlag() {
    if (_targetX != null) {
      final success = _toggleFlag(_targetX, _targetY);
      if (success) {
        _target(null, null);
      }
    }
  }

  Stream get targetChanged => _targetChanged.stream;
  
  */

  //---------------------------------------------------------------------------------------------------

  void start() {

    
  }

  //---------------------------------------------------------------------------------------------------

  void _onNewGameButtonClick(MouseEvent me) {
   //  _logger.info("onNewGameButtonClick");

  }
  
  void _onLogoClick(MouseEvent me) {
   //  _logger.info("onLogoClick");
   html.querySelector('#popup').style.display = 'block';
  }

}