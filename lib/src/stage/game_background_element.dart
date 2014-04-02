part of pop_pop_win.stage;

class BackgroundElement extends Sprite {
  
  BackgroundElement(TextureAtlas op, int edgeTiles) {
      //the lengths we go to reduce bytes down the wire...
      Bitmap ttl = new Bitmap(op.getBitmapData('background_top_left'));
      Bitmap stl = new Bitmap(op.getBitmapData('background_side_left'))
        ..y=96;
      
      Bitmap bbl = new Bitmap(op.getBitmapData('background_top_left'))
        ..scaleY = -1
        ..y=1534;
      Bitmap sbl = new Bitmap(op.getBitmapData('background_side_left'))
        ..scaleY = -1    
        ..y=1438;
      
      Bitmap ttr = new Bitmap(op.getBitmapData('background_top_left'))
        ..scaleX = -1
        ..x = 2048;
      Bitmap str = new Bitmap(op.getBitmapData('background_side_left'))
        ..scaleX = -1
        ..x = 2048
        ..y=96;    
      
      Bitmap bbr = new Bitmap(op.getBitmapData('background_top_left'))
        ..scaleX = -1
        ..x = 2048
        ..scaleY = -1
        ..y=1534;
      Bitmap sbr = new Bitmap(op.getBitmapData('background_side_left'))
        ..scaleX = -1
        ..x = 2048
        ..scaleY = -1    
        ..y=1438;
      
      addChild(ttl);
      addChild(stl);
      addChild(bbl);
      addChild(sbl);
      addChild(ttr);
      addChild(str);
      addChild(bbr);
      addChild(sbr);
      scaleX = 2/3;
      scaleY = 2/3;
      x = -88;
      y = 30;
      
      //draw the board
      num boardSize = edgeTiles*80+64;
      BitmapData boardData = new BitmapData(boardSize, boardSize, true, 0x000000);
      var cr = new Rectangle(0, 0, 112, 122);
      boardData.drawPixels(op.getBitmapData('game_board_corner_top_left'), cr, new Point(0, 0));
      boardData.drawPixels(op.getBitmapData('game_board_corner_top_right'), cr, new Point(boardSize-112, 0));
      boardData.drawPixels(op.getBitmapData('game_board_corner_bottom_left'), cr, new Point(0, boardSize-112));
      boardData.drawPixels(op.getBitmapData('game_board_corner_bottom_right'), cr, new Point(boardSize-112, boardSize-112));
      var tbr = new Rectangle(0, 0, 80, 112);
      var lrr = new Rectangle(0, 0, 112, 80);
      for(var i=0; i<edgeTiles-2; i++) {
        boardData
          ..drawPixels(op.getBitmapData('game_board_side_top'), tbr, new Point(112+i*80, 0))
          ..drawPixels(op.getBitmapData('game_board_side_bottom'), tbr, new Point(112+i*80, boardSize-112))
          ..drawPixels(op.getBitmapData('game_board_side_left'), lrr, new Point(0, 112+i*80))
          ..drawPixels(op.getBitmapData('game_board_side_right'), lrr, new Point(boardSize-112, 112+i*80));
      }
      
      num boardScale = 1344/boardSize;
      Bitmap board = new Bitmap(boardData)
        ..x = 352
        ..y = 96
        ..scaleX = boardScale
        ..scaleY = boardScale;
      
      addChild(board);
    
  }
  
}