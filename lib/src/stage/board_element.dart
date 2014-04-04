part of pop_pop_win.stage;

class BoardElement extends Sprite {
  Array2d<SquareElement> _elements;

  BoardElement(GameElement gameElement) {
    addTo(gameElement);
    
    _elements = new Array2d<SquareElement>(
              _game.field.width, _game.field.height);

    num scaledSize = SquareElement._size*_boardScale;
    for (int i = 0; i < _elements.length; i++) {
      final coords = _elements.getCoordinate(i);
      final se = new SquareElement(coords.item1, coords.item2);      
      
      
      
      se  
        ..x = coords.item1 * scaledSize
        ..y = coords.item2 * scaledSize
        ..scaleX = _boardScale
        ..scaleY = _boardScale
        ..addTo(this);
      
      _stage.juggler.add(se);
      
      _elements[i] = se;
    }
    
  }

  GameElement get _gameElement => parent;
  num get _boardScale => _gameElement._boardScale;
  num get _boardSize => _gameElement._boardSize;
  Game get _game => _gameElement.game;
  Stage get _stage => _gameElement._gameRoot.stage;

  TextureAtlas get _opaqueAtlas => _gameElement.resourceManager.getTextureAtlas('opaque');

}