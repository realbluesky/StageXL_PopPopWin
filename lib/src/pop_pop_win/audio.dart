part of pop_pop_win;

class _Audio {
  static const List<String> _AUDIO_NAMES =
      const ['Pop0', 'Pop1', 'Pop2', 'Pop3', 'Pop4', 'Pop5', 'Pop6', 'Pop7', 'Pop8',
             'Bomb0', 'Bomb1', 'Bomb2', 'Bomb3', 'Bomb4',
             GameAudio.THROW_DART, GameAudio.FLAG, GameAudio.UNFLAG, GameAudio.CLICK, GameAudio.WIN];

  final math.Random _rnd = new math.Random();

  final ResourceManager _resourceManager;

  _Audio(this._resourceManager) {
    GameAudio.audioEvent.listen(_playAudio);
  }

  void _playAudio(String name) {
    switch (name) {
      case GameAudio.POP:
        var i = _rnd.nextInt(8);
        name = '${GameAudio.POP}$i';
        break;
      case GameAudio.BOMB:
        var i = _rnd.nextInt(4);
        name = '${GameAudio.BOMB}$i';
        break;
    }
    _resourceManager.getSoundSprite('audio').play(name);
  }
}
