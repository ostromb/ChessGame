class ChessBoard {
  
  ChessBoard() {
    pieces = new PImage[8][8];
    whitesTurn = true;
    check = false;
    mate = false;
  }
  
 void startPos() { 
  pieces[0][0] = bRook;
  pieces[0][1] = bKnight;
  pieces[0][2] = bBishop;
  pieces[0][3] = bQueen;
  pieces[0][4] = bKing;
  pieces[0][5] = bBishop;
  pieces[0][6] = bKnight;
  pieces[0][7] = bRook;
  pieces[1][0] = bPawn;
  pieces[1][1] = bPawn;
  pieces[1][2] = bPawn;
  pieces[1][3] = bPawn;
  pieces[1][4] = bPawn;
  pieces[1][5] = bPawn;
  pieces[1][6] = bPawn;
  pieces[1][7] = bPawn;
  
  pieces[7][0] = wRook;
  pieces[7][1] = wKnight;
  pieces[7][2] = wBishop;
  pieces[7][3] = wQueen;
  pieces[7][4] = wKing;
  pieces[7][5] = wBishop;
  pieces[7][6] = wKnight;
  pieces[7][7] = wRook;
  pieces[6][0] = wPawn;
  pieces[6][1] = wPawn;
  pieces[6][2] = wPawn;
  pieces[6][3] = wPawn;
  pieces[6][4] = wPawn;
  pieces[6][5] = wPawn;
  pieces[6][6] = wPawn;
  pieces[6][7] = wPawn;
 }
 
 boolean valid(PImage piece, int x, int y, int startX, int startY) {
   try {
     if (piece == wPawn) {
       if ((startY == 6 && x == startX && y == startY-2 && pieces[startY-1][startX] == null && pieces[startY-2][startX] == null) || (x == startX && y == startY-1 && pieces[startY-1][startX] == null)) {
        return true;      
       }
       if (y != 7) {
        if (isBlack(pieces[startY-1][startX+1])) {
         if (x == startX+1 && y == startY-1) return true; 
        }
        if (isBlack(pieces[startY-1][startX-1])) {
         if (x == startX-1 && y == startY-1) return true; 
        }
       }
       if (passant) {
        if (isBlack(pieces[startY][startX+1])) {
          if (y == startY-1 && x == startX+1) {
            pawnX = startX+1;
            pawnY = startY;
            return true;
          }
        }
        else if (isBlack(pieces[startY][startX-1])) {
         if (y == startY-1 && x == startX-1) {
           pawnX = startX-1;
           pawnY = startY;
           return true;
         }
        }
       }
     }
     if (piece == wRook) { 
      if (validSquare(x,y,startX,startY,0,1,true)) return true;
      if (validSquare(x,y,startX,startY,0,-1,true)) return true;
      if (validSquare(x,y,startX,startY,1,0,true)) return true;
      if (validSquare(x,y,startX,startY,-1,0,true)) return true;
     }
     if (piece == wBishop) {
      if (validSquare(x,y,startX,startY,1,1,true)) return true;
      if (validSquare(x,y,startX,startY,-1,1,true)) return true;
      if (validSquare(x,y,startX,startY,1,-1,true)) return true;
      if (validSquare(x,y,startX,startY,-1,-1,true)) return true;
     }
     if (piece == wQueen) {
      if (validSquare(x,y,startX,startY,0,1,true)) return true;
      if (validSquare(x,y,startX,startY,0,-1,true)) return true;
      if (validSquare(x,y,startX,startY,1,0,true)) return true;
      if (validSquare(x,y,startX,startY,-1,0,true)) return true;
      if (validSquare(x,y,startX,startY,1,1,true)) return true;
      if (validSquare(x,y,startX,startY,-1,1,true)) return true;
      if (validSquare(x,y,startX,startY,1,-1,true)) return true;
      if (validSquare(x,y,startX,startY,-1,-1,true)) return true;
     }
     if (piece == wKing) {
       if (!wKingMove && !wRookMoveL) {
        if (pieces[7][3] == null && pieces[7][2] == null && pieces[7][1] == null) {
         if (y == startY && x == startX-2) {
          return true; 
         }
        }
       }
       if (!wKingMove && !wRookMoveR) {
        if (pieces[7][5] == null && pieces[7][6] == null) {
         if (y == startY && x == startX+2) {
          return true; 
         }
        }
       }
       if ((y == startY-1 && x == startX+1 && (pieces[startY-1][startX+1] == null || isBlack(pieces[startY-1][startX+1]))) || (y == startY+1 && x == startX-1 && (pieces[startY+1][startX-1] == null || isBlack(pieces[startY+1][startX-1]))) || 
       (y == startY-1 && x == startX-1 && (pieces[startY-1][startX-1] == null || isBlack(pieces[startY-1][startX-1]))) || (y == startY+1 && x == startX+1 && (pieces[startY+1][startX+1] == null || isBlack(pieces[startY+1][startX+1]))) || 
       (x == startX && y == startY-1 && (pieces[startY-1][startX] == null || isBlack(pieces[startY-1][startX]))) || (x == startX-1 && y == startY && (pieces[startY][startX-1] == null || isBlack(pieces[startY][startX-1]))) 
       || (x == startX+1 && y == startY && (pieces[startY][startX+1] == null || isBlack(pieces[startY][startX+1]))) || (x == startX && y == startY+1 && (pieces[startY+1][startX] == null || isBlack(pieces[startY+1][startX])))) {
         return true;      
       }
     }
     if (piece == wKnight) {
       if ((((startY-y==1 || startY-y==-1) && (startX-x==2 || startX-x==-2)) || ((startX-x==1 || startX-x==-1)&& (startY-y==2 || startY-y==-2))) && (pieces[y][x] == null || isBlack(pieces[y][x]))) {
           return true; 
       }   
     }
     
     if (piece == bKnight) {
       if ((((startY-y==1 || startY-y==-1) && (startX-x==2 || startX-x==-2)) || ((startX-x==1 || startX-x==-1)&& (startY-y==2 || startY-y==-2))) && (pieces[y][x] == null || isWhite(pieces[y][x]))) {
           return true; 
       }  
     }
     if (piece == bKing) {
       if (!bKingMove && !bRookMoveL) {
        if (pieces[0][3] == null && pieces[0][2] == null && pieces[0][1] == null) {
         if (y == startY && x == startX-2) {
          return true; 
         }
        }
       }
       if (!bKingMove && !bRookMoveR) {
        if (pieces[0][5] == null && pieces[0][6] == null) {
         if (y == startY && x == startX+2) {
          return true; 
         }
        }
       }
       if ((y == startY-1 && x == startX+1 && (pieces[startY-1][startX+1] == null || isWhite(pieces[startY-1][startX+1]))) || (y == startY+1 && x == startX-1 && (pieces[startY+1][startX-1] == null || isWhite(pieces[startY+1][startX-1]))) || 
       (y == startY-1 && x == startX-1 && (pieces[startY-1][startX-1] == null || isWhite(pieces[startY-1][startX-1]))) || (y == startY+1 && x == startX+1 && (pieces[startY+1][startX+1] == null || isWhite(pieces[startY+1][startX+1]))) || 
       (x == startX && y == startY-1 && (pieces[startY-1][startX] == null || isWhite(pieces[startY-1][startX]))) || (x == startX-1 && y == startY && (pieces[startY][startX-1] == null || isWhite(pieces[startY][startX-1]))) 
       || (x == startX+1 && y == startY && (pieces[startY][startX+1] == null || isWhite(pieces[startY][startX+1]))) || (x == startX && y == startY+1 && (pieces[startY+1][startX] == null || isWhite(pieces[startY+1][startX])))) {
        return true;      
       }    
     }
     if (piece == bQueen) {
      if (validSquare(x,y,startX,startY,0,1,false)) return true;
      if (validSquare(x,y,startX,startY,0,-1,false)) return true;
      if (validSquare(x,y,startX,startY,1,0,false)) return true;
      if (validSquare(x,y,startX,startY,-1,0,false)) return true;
      if (validSquare(x,y,startX,startY,1,1,false)) return true;
      if (validSquare(x,y,startX,startY,-1,1,false)) return true;
      if (validSquare(x,y,startX,startY,1,-1,false)) return true;
      if (validSquare(x,y,startX,startY,-1,-1,false)) return true; 
     }
     if (piece == bBishop) {
      if (validSquare(x,y,startX,startY,1,1,false)) return true;
      if (validSquare(x,y,startX,startY,-1,1,false)) return true;
      if (validSquare(x,y,startX,startY,1,-1,false)) return true;
      if (validSquare(x,y,startX,startY,-1,-1,false)) return true; 
     }
     if (piece == bRook) {
      if (validSquare(x,y,startX,startY,0,1,false)) return true;
      if (validSquare(x,y,startX,startY,0,-1,false)) return true;
      if (validSquare(x,y,startX,startY,1,0,false)) return true;
      if (validSquare(x,y,startX,startY,-1,0,false)) return true; 
     }
     if (piece == bPawn) {
       if ((startY == 1 && x == startX && y == startY+2 && pieces[startY+1][startX] == null && pieces[startY+2][startX] == null) || (x == startX && y == startY+1 && pieces[startY+1][startX] == null)) {
        return true;      
       }
       if (y != 0) {
        if (isWhite(pieces[startY+1][startX-1])) {
         if (x == startX-1 && y == startY+1) return true; 
        }
        if (isWhite(pieces[startY+1][startX+1])) {
         if (x == startX+1 && y == startY+1) return true; 
        }
       }
       if (passant) {
        if (isWhite(pieces[startY][startX+1])) {
          if (y == startY+1 && x == startX+1) {
            pawnX = startX+1;
            pawnY = startY;
            return true;
          }
        }
        else if (isWhite(pieces[startY][startX-1])) {
         if (y == startY+1 && x == startX-1) {
           pawnX = startX-1;
           pawnY = startY;
           return true;
         }
        }
       }
     }
     return false;
   }
   catch (Exception e) {return false;}
 }
 
 boolean validSquare(int x, int y, int startX, int startY, int u, int d, boolean whiteS) {
  for (int j = startX+u, i = startY+d; j < 8 && i < 8 && j >= 0 && i >= 0; j += u, i += d) {
    if (whiteS) {
     if (isWhite(pieces[i][j])) break;
     if(isBlack(pieces[i][j])) {
      if(j == x && i == y) return true;
       break;
     }
    } else {
     if (isBlack(pieces[i][j])) break;
     if(isWhite(pieces[i][j])) {
      if(j == x && i == y) return true;
      break;
     }
    }
    if (j == x && i == y) return true;
  }
  return false;
 }
 
 void castling() {
  if (curr == wRook && posX == 0 && posY == 7 && !wRookMoveL) wRookMoveL = true;
  if (curr == wRook && posX == 7 && posY == 7 && !wRookMoveR) wRookMoveR = true;
  if (curr == bRook && posX == 7 && posY == 0 && !bRookMoveR) bRookMoveR = true;
  if (curr == bRook && posX == 0 && posY == 0 && !bRookMoveL) bRookMoveL = true;
  if (curr == wKing && mouseX/100 == 2 && !wRookMoveL && !wKingMove) {
   wKingMove = true;
   pieces[7][3] = pieces[7][0];
   pieces[7][0] = null;
  }
  if (curr == wKing && mouseX/100 == 6 && !wRookMoveR && !wKingMove) {
   wKingMove = true;
   pieces[7][5] = pieces[7][7];
   pieces[7][7] = null;
  }
  if (curr == bKing && mouseX/100 == 2 && !bRookMoveL && !bKingMove) {
   bKingMove = true;
   pieces[0][3] = pieces[0][0];
   pieces[0][0] = null;
  }
  if (curr == bKing && mouseX/100 == 6 && !bRookMoveR && !bKingMove) {
   bKingMove = true;
   pieces[0][5] = pieces[0][7];
   pieces[0][7] = null;
  }
  if (curr == wKing) wKingMove = true;
  if (curr == bKing) bKingMove = true;
 }
 
 boolean isWhite(PImage piece) {
  if (piece == wPawn || piece == wKnight || piece == wRook || piece == wBishop || piece == wKing || piece == wQueen) {
    return true;
  }
  return false;
 }
 
 boolean isBlack(PImage piece) {
  if (piece == bPawn || piece == bKnight || piece == bRook || piece == bBishop || piece == bKing || piece == bQueen) {
    return true;
  }
  return false;   
 }
 
 boolean check(boolean wTurn, PImage[][] piece) {
  white = new int[8][8];
  black = new int[8][8];
  
  for (int i = 0; i < 8; i++) {
   for (int j = 0; j < 8; j++) {
    if (wTurn) {
     if (isWhite(piece[j][i])) {
       for (int x = 0; x < 8; x++) {
        for (int y = 0; y < 8; y++) {
           if (valid(piece[j][i], x, y, i, j)) {
             white[y][x] = 1; 
           }
        }
       }
     }
    }
     else {
      if (isBlack(piece[j][i])) {       
       for (int x = 0; x < 8; x++) {
        for (int y = 0; y < 8; y++) {
         if (valid(piece[j][i], x, y, i, j)) {
          black[y][x] = 1; 
         }
        }
       }
      } 
     }
   }
  }

  for (int a = 0; a < 8; a++) {
   for (int b = 0; b < 8; b++) {
     if (wTurn) {
       if (piece[b][a] == bKing) {
        if (white[b][a] == 1) {
          return true;
        }
        else return false;
       }
     }
     else {
      if (piece[b][a] == wKing) {
       if (black[b][a] == 1) {
         return true;
       }
       else return false;
      }
     }
   }
  }
  return false;
 }
 
 boolean testCheck(PImage piece, int x, int y, boolean turn) {
  PImage[][] newBoard = new PImage[8][8];
  
  for (int i = 0; i < 8; i++) {
   for (int j = 0; j < 8; j++) {
    newBoard[i][j] = pieces[i][j]; 
   }
  }
  newBoard[y][x] = piece;
  
  if (check(turn,newBoard)) return true;
  else return false;
 }
 
 boolean mate() {
   boolean tMate = true;
  if (whitesTurn) {
    for (int i = 0; i < 8; i++) {
     for (int j = 0; j < 8; j++) {
      if (isWhite(pieces[j][i])) {
        for (int x = 0; x < 8; x++) {
         for (int y = 0; y < 8; y++) {
          if (valid(pieces[j][i],x,y,i,j)) {
            extra = pieces[y][x];
            extra2 = pieces[j][i];
            pieces[y][x] = extra2;
            pieces[j][i] = null;
            if (!board.check(!whitesTurn,pieces)) tMate = false;
            pieces[y][x] = extra; 
            pieces[j][i] = extra2;
          }
         }
        }
      }
     }
    }
  }
  else {
    for (int i = 0; i < 8; i++) {
     for (int j = 0; j < 8; j++) {
      if (isBlack(pieces[j][i])) {
        for (int x = 0; x < 8; x++) {
         for (int y = 0; y < 8; y++) {
          if (valid(pieces[j][i],x,y,i,j)) {
            extra = pieces[y][x];
            extra2 = pieces[j][i];
            pieces[y][x] = extra2;
            pieces[j][i] = null;
            if (!board.check(!whitesTurn,pieces)) tMate = false;
            pieces[y][x] = extra; 
            pieces[j][i] = extra2;
          }
         }
        }
      }
     }
    }    
  }
  if (tMate) return true;
  return false;
 }
}