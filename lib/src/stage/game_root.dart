part of pop_pop_win.stage;

class GameRoot extends GameManager {
  final Stage stage;
  final ResourceManager resourceManager;
  GameElement _gameElement;

  GameRoot(int width, int height, int bombCount,
      this.stage, this.resourceManager) : super(width, height, bombCount) {

    TextureAtlas opa = resourceManager.getTextureAtlas('opaque');
    TextureAtlas sta = resourceManager.getTextureAtlas('static');

    _gameElement = new GameElement(this)
        ..alpha = 0;

    stage
        ..addChild(_gameElement)
        ..juggler.tween(_gameElement, .5).animate.alpha.to(1);

  }

  void onGameStateChanged(GameState newState) {
    switch (newState) {
      case GameState.won:
        _gameElement._boardElement.squares.forEach((se) => se.updateState());
        GameAudio.win();
        break;
    }
  }

  void gameUpdated(args) {}

  void newGame() {
    super.newGame();
    if (_gameElement != null) _gameElement._boardElement.squares.forEach((se) =>
        se.updateState());
  }

}
