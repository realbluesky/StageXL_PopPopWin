part of pop_pop_win.stage;

class ScoreElement extends TextField implements Animatable {

  num _bestTime;
  
  ScoreElement(this._bestTime) {
      defaultTextFormat = new TextFormat('Slackey, cursive', 28, Color.Black, leading: 3);
      autoSize = TextFieldAutoSize.LEFT;
      x = 1400;
      y = 20;
      
  }
  
  bool advanceTime(num time) {
      var time = (game.duration == null)?'0':(game.duration.inMilliseconds/1000).toStringAsFixed(1);
      text = 'Bombs Left: ${game.bombsLeft}\nTime: $time';
          if(_bestTime>0) text = text+'\nRecord: ${(_bestTime/1000).toStringAsFixed(1)}';
          
          return true;  
    
  }
  
  Game get game => (parent as GameElement)._gameRoot.game; 
  
}