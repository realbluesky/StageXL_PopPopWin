part of pop_pop_win.stage;

class GameAudio {
  static const String WIN = 'win',
      CLICK = 'click',
      POP = 'Pop',
      FLAG = 'flag',
      UNFLAG = 'unflag',
      BOMB = 'Bomb',
      THROW_DART = 'throw';

  static final StreamController<String> _audioEventHandle =
      new StreamController<String>();

  static Stream<String> get audioEvent => _audioEventHandle.stream;

  static void win() => _audioEventHandle.add(WIN);

  static void click() => _audioEventHandle.add(CLICK);

  static void pop() => _audioEventHandle.add(POP);

  static void flag() => _audioEventHandle.add(FLAG);

  static void unflag() => _audioEventHandle.add(UNFLAG);

  static void bomb() => _audioEventHandle.add(BOMB);

  static void throwDart() => _audioEventHandle.add(THROW_DART);
}
