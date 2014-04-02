library pop_pop_win.stage;

import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:bot/bot.dart';
import 'package:stagexl/stagexl.dart';

import 'html.dart';
import 'game.dart';

part 'stage/board_element.dart';
part 'stage/game_background_element.dart';
part 'stage/game_element.dart';
//part 'stage/game_root.dart';
//part 'stage/new_game_element.dart';
//part 'stage/score_element.dart';
part 'stage/square_element.dart';
//part 'stage/title_element.dart';
part 'stage/game_audio.dart';

final EventHandle _titleClickedEventHandle = new EventHandle<EventArgs>();

Stream get titleClickedEvent => _titleClickedEventHandle.stream;
