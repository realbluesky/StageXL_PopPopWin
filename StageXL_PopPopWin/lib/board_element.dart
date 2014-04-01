part of pop_pop_win;

class BoardElement extends Sprite {
  bot.Array2d<SquareElement> _elements;

  BoardElement() {
    _elements = new bot.Array2d<SquareElement>(
              _game.field.width, _game.field.height);

    for (int i = 0; i < _elements.length; i++) {
      final coords = _elements.getCoordinate(i);
      final se = new SquareElement(coords.item1, coords.item2)
        ..x = coords.item1 * SquareElement._size
        ..y = coords.item2 * SquareElement._size
        ..addTo(this);
      
      _elements[i] = se;
    }
    
  }

  int get visualChildCount {
    if (_elements == null) {
      return 0;
    } else {
      return _elements.length;
    }
  }

  SquareElement getVisualChild(int index) {
    return _elements[index];
  }

  GameElement get _gameElement => parent;

  Game get _game => _gameElement._game;

  TextureAtlas get _opaqueAtlas => _gameElement._opaqueAtlas;

}