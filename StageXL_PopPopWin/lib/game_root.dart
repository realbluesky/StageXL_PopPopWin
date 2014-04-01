part of pop_pop_win;

class GameRoot extends GameManager {
  Stage _stage;
  ResourceManager _resourceManager;
  GameElement _gameElement;

  GameRoot(int width, int height, int bombCount, stage, resourceManager) :
      this._stage = stage,
      this._resourceManager = resourceManager,
      super(width, height, bombCount) {

    //I'm bad at programming - somehow code exectuion never gets here...
    //I've modified the GameElement constructor just to show that I have some things working
    _gameElement = new GameElement(this, _resourceManager)..addTo(_stage);

    //_gameElement.newGameClick.listen((args) => newGame());

  }

  void newGame() {
    super.newGame();
    _gameElement.game = super.game;
  }

  /*
  bool get canRevealTarget => _gameElement.canRevealTarget;

  bool get canFlagTarget => _gameElement.canFlagTarget;

  void revealTarget() => _gameElement.revealTarget();

  void toggleTargetFlag() => _gameElement.toggleTargetFlag();

  Stream get targetChanged => _gameElement.targetChanged;
  */

  void onGameStateChanged(GameState newState) {
    switch (newState) {
      case GameState.won:
        //GameAudio.win();
        break;
    }
  }

  void gameUpdated(args) {
    //_requestFrame();
    
  }
  
  void updateClock() {
    super.updateClock();
  }

}
