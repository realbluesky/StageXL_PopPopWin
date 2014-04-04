part of pop_pop_win.stage;

class GameRoot extends GameManager {
  static const String _xKey = 'x';
  static const String _yKey = 'y';

  final Stage stage;
  final ResourceManager resourceManager;
  GameElement _gameElement;
  
  GameRoot(int width, int height, int bombCount,
      this.stage, this.resourceManager) : super(width, height, bombCount) {
    
    TextureAtlas opa = resourceManager.getTextureAtlas('opaque');
    TextureAtlas sta = resourceManager.getTextureAtlas('static');
    
    _gameElement = new GameElement(this)..alpha = 0;
        
    stage
        ..addChild(_gameElement)
        ..juggler.tween(_gameElement, .5).animate.alpha.to(1);
    
    //_gameElement.onEnterFrame.listen(_onEnterFrame);
    
  }
  
  void _onEnterFrame(EnterFrameEvent e) {
    updateClock();
  }

  void gameUpdated(args) {
    updateElement();
  }
  
  void updateElement() {
    updateClock();
    //_gameStateDiv.innerHtml = game.state.name;
    //_leftCountDiv.innerHtml = game.bombsLeft.toString();


  }

  void newGame() {
    super.newGame();
    //_table.children.clear();
    //updateElement();
  }

  void updateClock() {
    if(game.duration == null) {
      //_clockDiv.innerHtml = '';
    } else {
      //_clockDiv.innerHtml = game.duration.inSeconds.toString();
    }

    super.updateClock();
  }

   void _click(int x, int y, bool flag) {
    final ss = game.getSquareState(x, y);

    if (flag) {
      if (ss == SquareState.hidden) {
        game.setFlag(x, y, true);
      } else if (ss == SquareState.flagged) {
        game.setFlag(x, y, false);
      } else if (ss == SquareState.revealed) {
        game.reveal(x, y);
      }
    } else {
      if (ss == SquareState.hidden) {
        game.reveal(x, y);
      }
    }
  }

}
