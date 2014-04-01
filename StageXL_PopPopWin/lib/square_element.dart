part of pop_pop_win;

class SquareElement extends Sprite implements Animatable {
  static const int _size = 80;
  
  static const List<String> _balloonBits = const['balloon_pieces_a',
                                                 'balloon_pieces_b',
                                                 'balloon_pieces_c',
                                                 'balloon_pieces_d'];

  static const List<String> _numberMap = const["game_board_center",
                                               "number_one", "number_two",
                                               "number_three", "number_four",
                                               "number_five", "number_six",
                                               "number_seven", "number_eight"];

  final int x, y;
  Bitmap bitmap = new Bitmap();

  SquareState _lastDrawingState;

  SquareElement(this.x, this.y);
  
  bool advanceTime(num time) {
    if (_lastDrawingState != _squareState) {
      _lastDrawingState = _squareState;
      updateState();
    }
    
    return true;
  }

  void updateState() {
    var textureName;
    switch (_lastDrawingState) {
      case SquareState.hidden:
        textureName = _getHiddenTexture();
        break;
      case SquareState.flagged:
        textureName = 'balloon_tagged_frozen';
        break;
      case SquareState.revealed:
        textureName = _numberMap[_adjacentCount];
        break;
      case SquareState.bomb:
        textureName = 'crater_b';
        break;
      case SquareState.safe:
        textureName = 'balloon_tagged_bomb';
        break;
    }

    bitmap.bitmapData
      ..clear()
      ..drawPixels(_opaqueAtlas.getBitmapData(textureName), new Rectangle(0,0,_size,_size), new Point(0,0));

  }

  String toString() => 'Square at [$x, $y]';

  String _getHiddenTexture() {
    assert(_lastDrawingState == SquareState.hidden);
    if (_game.state == GameState.lost) {
      final index = (x + y) % _balloonBits.length;
      return _balloonBits[index];
    } else {
      return 'balloon';
    }
  }

  SquareState get _squareState => _game.getSquareState(x, y);

  int get _adjacentCount => _game.field.getAdjacentCount(x, y);

  BoardElement get _board {
    final BoardElement p = this.parent;
    return p;
  }

  TextureAtlas get _opaqueAtlas => _board._opaqueAtlas;

  Game get _game => _board._game;
}