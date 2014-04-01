part of pop_pop_win;

class PlatformWeb extends PlatformTarget {
  static const String _BIG_HASH = '#big';
  static const String _ABOUT_HASH = '#about';

  final StreamController _aboutController = new StreamController(sync: true);

  PlatformWeb(): super.base() {
    html.window.onPopState.listen((args) => _processUrlHash());
  }

  @override
  Future clearValues() {
    html.window.localStorage.clear();
    return new Future.value();
  }

  @override
  Future setValue(String key, String value) {
    html.window.localStorage[key] = value;
    return new Future.value();
  }

  @override
  Future<String> getValue(String key) =>
      new Future.value(html.window.localStorage[key]);

  bool get renderBig => _urlHash == _BIG_HASH;

  bool get showAbout => _urlHash == _ABOUT_HASH;

  Stream get aboutChanged => _aboutController.stream;

  void toggleAbout([bool value]) {
    var loc = html.window.location;
    // ensure we treat empty hash like '#', which makes comparison easy later
    var hash = loc.hash.length == 0 ? '#' : loc.hash;

    var isOpen = hash == _ABOUT_HASH;
    if (value == null) {
      // then toggle the current value
      value = !isOpen;
    }

    var targetHash = value ? _ABOUT_HASH : '#';
    if (targetHash != hash) {
      loc.assign(targetHash);
    }
    _aboutController.add(null);
  }

  String get _urlHash => html.window.location.hash;

  void _processUrlHash() {
    var loc = html.window.location;
    var hash = loc.hash;
    var href = loc.href;

    final html.History history = html.window.history;
    switch (hash) {
      case "#reset":
        assert(href.endsWith(hash));
        var newLoc = href.substring(0, href.length - hash.length);

        html.window.localStorage.clear();

        loc.replace(newLoc);
        break;
      case _BIG_HASH:
        if (!renderBig) loc.reload();
        break;
      case _ABOUT_HASH:
        _aboutController.add(null);
        break;
    }
  }
}
