part of pop_pop_win.stage;

class GameElement extends Sprite {
  static const _edgeOffset = 32;
  static const _backgroundSize = const Size(2048, 1536);
  static const _backgroundHoleSize = 16 * SquareElement._size + 2 * _edgeOffset;
  static const _boardOffset = const Vector(352, 96);
  static const _popAnimationHitFrame = 12;
  static const _popExplodeAnimationOffset = const Vector(-88, -88);
  static const _dartAnimationOffset =
      const Vector(-512 + 0.5 * SquareElement._size,
          -388 + 0.5 * SquareElement._size);

  final GameRoot _gameRoot;

  GameBackgroundElement _gameBackground;
  BoardElement _boardElement;
  ScoreElement _scoreElement;
  SimpleButton _newGameButton, _logoButton;
  Sprite _popLayer = new Sprite(), _dartLayer = new Sprite();

  num _boardSize, _boardScale;
  int _targetX, _targetY;
  TextureAtlas _animations;

  GameRoot get manager => _gameRoot;
  Game get game => _gameRoot.game;
  ResourceManager get resourceManager => _gameRoot.resourceManager;

  GameElement(this._gameRoot) {
    TextureAtlas opa = resourceManager.getTextureAtlas('opaque');
    TextureAtlas sta = resourceManager.getTextureAtlas('static');
    _animations = resourceManager.getTextureAtlas('animated');

    _boardSize = game.field.width * SquareElement._size + 2 * _edgeOffset;
    _boardScale = _backgroundHoleSize / _boardSize;

    _gameBackground = new GameBackgroundElement(this, opa);

    var newButtonNormal = new Bitmap(sta.getBitmapData("button_new_game"));
    var newButtonPressed = new Bitmap(sta.getBitmapData("button_new_game_clicked"));

    _newGameButton = new SimpleButton(newButtonNormal, newButtonPressed, newButtonPressed, newButtonPressed)
        ..x = 450
        ..y = 20
        ..onMouseClick.listen((e) {
          GameAudio.click();
          manager.newGame();
        })
        ..addTo(this);

    _boardElement = new BoardElement(this)
      ..x = _boardOffset.x + _edgeOffset * _boardScale
      ..y = _boardOffset.y + _edgeOffset * _boardScale;


    _gameRoot.bestTimeMilliseconds.then((v) {
      if(v == null) v = 0;
      _scoreElement = new ScoreElement(v)
        ..addTo(this);

      stage.juggler.add(_scoreElement);

    });

    num logoScale = min(max(_boardScale, 1.1), 1.5);
    Bitmap logo = new Bitmap(sta.getBitmapData('logo_win'));
    _logoButton = new SimpleButton(logo, logo, logo, logo);
    _logoButton
        ..y = 20
        ..scaleX = logoScale
        ..scaleY = logoScale
        ..x = _backgroundSize.width/2 - _logoButton.width/2
        ..onMouseClick.listen((e) => _titleClickedEventHandle.add(null))
        ..addTo(this);

    _popLayer
        ..mouseEnabled = false
        ..x = _boardOffset.x + _edgeOffset * _boardScale
        ..y = _boardOffset.y + _edgeOffset * _boardScale
        ..scaleX = _boardScale
        ..scaleY = _boardScale
        ..addTo(this);

    _dartLayer
        ..mouseEnabled = false
        ..x = _boardOffset.x + _edgeOffset * _boardScale
        ..y = _boardOffset.y + _edgeOffset * _boardScale
        ..scaleX = _boardScale
        ..scaleY = _boardScale
        ..addTo(this);

  }

  bool get canRevealTarget =>
      _targetX != null && game.canReveal(_targetX, _targetY);

  bool get canFlagTarget =>
      _targetX != null && game.canToggleFlag(_targetX, _targetY);

  void revealTarget() {
    if (_targetX != null) {
      game.reveal(_targetX, _targetY);
    }
  }

  void _click(int x, int y, bool alt) {
      assert(!game.gameEnded);
      final ss = game.getSquareState(x, y);

      List<Coordinate> reveals = null;

      if (alt) {
        if (ss == SquareState.hidden || ss == SquareState.flagged) {
          _toggleFlag(x, y);
        } else if (ss == SquareState.revealed) {
          if (game.canReveal(x, y)) {
            // get adjacent ballons
            final adjHidden = game.field.getAdjacentIndices(x, y)
                .map((i) {
                  final t = game.field.getCoordinate(i);
                  return new Coordinate(t.item1, t.item2);
                })
                .where((t) => game.getSquareState(t.x, t.y) == SquareState.hidden)
                .toList();

            assert(adjHidden.length > 0);

            _startDartAnimation(adjHidden);
            reveals = game.reveal(x, y);
          }
        }
      } else {
        if (ss == SquareState.hidden) {
          _startDartAnimation([new Coordinate(x, y)]);
          reveals = game.reveal(x, y);
        }
      }

      if (reveals != null && reveals.length > 0) {
        assert(game.state != GameState.lost);
        if (!alt) {
          // if it was a normal click, the first item should be the clicked item
          var first = reveals[0];
          assert(first.x == x);
          assert(first.y == y);
        }
        _startPopAnimation(new Coordinate(x, y), reveals);
      } else if (game.state == GameState.lost) {
        _startPopAnimation(new Coordinate(x, y));
      }
    }

  bool _toggleFlag(int x, int y) {
    assert(!game.gameEnded);
    final se = _boardElement.squares.get(x, y);
    final ss = se._squareState;
    if (ss == SquareState.hidden) {
      game.setFlag(x, y, true);
      se.updateState();
      GameAudio.flag();
      return true;
    } else if (ss == SquareState.flagged) {
      game.setFlag(x, y, false);
      se.updateState();
      GameAudio.unflag();
      return true;
    }
    return false;
  }

  void _startPopAnimation(Coordinate start, [Iterable<Coordinate> reveals = null]) {
      if(reveals == null) {
        assert(game.state == GameState.lost);
        reveals = new NumberEnumerable.fromRange(0, game.field.length)
            .map((i) {
              final t = game.field.getCoordinate(i);
              final c = new Coordinate(t.item1, t.item2);
              return new Tuple(c, game.getSquareState(c.x, c.y));
            })
            .where((t2) => t2.item2 == SquareState.bomb || t2.item2 == SquareState.hidden)
            .map((t2) => t2.item1)
            .toList();
      }

      final values = reveals.map((c) {
        final initialOffset = new Vector(SquareElement._size * c.x,
            SquareElement._size * c.y);
        final squareOffset = _popExplodeAnimationOffset + initialOffset;

        var delay = _popAnimationHitFrame + ((c - start).magnitude * 4).toInt();
        delay += rnd.nextInt(10);

        return [c, initialOffset, squareOffset, delay];
      }).toList();

      values.sort((a, b) {
        final int da = a[3];
        final int db = b[3];
        return da.compareTo(db);
      });

      for (final v in values) {
        final Coordinate c = v[0];
        final Vector initialOffset = v[1];
        final Vector squareOffset = v[2];
        final int delay = v[3];

        final se = _boardElement.squares.get(c.x, c.y);
        final ss = se._squareState;

        String texturePrefix = ss==SquareState.bomb?'balloon_explode':'balloon_pop';

        FlipBook anim = new FlipBook(_animations.getBitmapDatas(texturePrefix), stage.frameRate, false);
        anim
          ..x = squareOffset.x
          ..y = squareOffset.y
          ..alpha = 0
          ..mouseEnabled = false
          ..onComplete.listen((e) => anim.removeFromParent())
          ..addTo(_popLayer);

        stage.juggler
            ..add(anim)
            ..delayCall(() {
                anim
                  ..alpha = 1
                  ..play();
                se.updateState();
                switch (ss) {
                  case SquareState.revealed:
                  case SquareState.hidden:
                    GameAudio.pop();
                    break;
                  case SquareState.bomb:
                    GameAudio.bomb();
                    break;
                    }
                }, delay/stage.frameRate);

      }
    }

    void _startDartAnimation(List<Coordinate> points) {
      assert(points.length >= 1);
      GameAudio.throwDart();
      for(final point in points) {
        final squareOffset = _dartAnimationOffset +
            new Vector(SquareElement._size * point.x, SquareElement._size * point.y);

        FlipBook dart = new FlipBook(_animations.getBitmapDatas('dart'), stage.frameRate, false);
        dart
          ..x = squareOffset.x
          ..y = squareOffset.y
          ..mouseEnabled = false
          ..play()
          ..onComplete.listen((e) => dart.removeFromParent())
          ..addTo(_dartLayer);

        FlipBook shadow = new FlipBook(_animations.getBitmapDatas('shadow'), stage.frameRate, false);
        shadow
          ..x = squareOffset.x
          ..y = squareOffset.y
          ..mouseEnabled = false
          ..play()
          ..onComplete.listen((e) => shadow.removeFromParent())
          ..addTo(_dartLayer);

        stage.juggler
            ..add(dart)
            ..add(shadow);

      }
    }


}