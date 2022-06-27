ChessBoard board = new ChessBoard();
PImage[][] pieces; //Pjäsernas positioner

PImage bPawn, wPawn, bRook, wRook, bBishop, wBishop, bKnight, wKnight, bKing, wKing, bQueen, wQueen;
PImage curr, prev, dead;
boolean drag; //Om pjäsen dras
boolean pressed;
int posX, posY;
int rmX, rmY;
int pawnX, pawnY;
boolean whitesTurn;
boolean promote;
boolean wKingMove, bKingMove, bRookMoveL, bRookMoveR, wRookMoveL, wRookMoveR;
boolean moved;
boolean passant;

void setup() {
 size(800,800);
 background(500,255,500);
 noStroke();
 
 bPawn = loadImage("Pawn1.png");
 wPawn = loadImage("Pawn.png");
 bRook = loadImage("Rook1.png");
 wRook = loadImage("Rook.png");
 bBishop = loadImage("Bishop1.png");
 wBishop = loadImage("Bishop.png");
 bKnight = loadImage("Knight1.png");
 wKnight = loadImage("Knight.png");
 bKing = loadImage("King1.png");
 wKing = loadImage("King.png");
 bQueen = loadImage("Queen1.png");
 wQueen = loadImage("Queen.png");
 
 bPawn.resize(width/8,height/8);
 wPawn.resize(width/8,height/8);
 bRook.resize(width/8,height/8);
 wRook.resize(width/8,height/8);
 bBishop.resize(width/8,height/8);
 wBishop.resize(width/8,height/8);
 bKnight.resize(width/8,height/8);
 wKnight.resize(width/8,height/8);
 bKing.resize(width/8,height/8);
 wKing.resize(width/8,height/8);
 bQueen.resize(width/8,height/8);
 wQueen.resize(width/8,height/8);
 board.startPos();
 
 draw();
}

void draw() {
 for (int i = 0; i < 8; i++) {
   
  for (int j = 0; j < 8; j++) {
    
   if( (i+j)%2 == 0) fill(238,238,210,100);
    else fill(118,150,86,100);
    
    //Schackrutor
    rect(i*width/8,j*height/8,width/8,height/8);
    
    if(pieces[j][i] != null) { 
     //Ritar pjäser
     image(pieces[j][i], i*width/8, j*height/8); 
    }
    
    if (pressed == true) {
     try {
       if (board.valid(curr,i,j,posX,posY)) {
         if ((whitesTurn && board.isWhite(pieces[j][i]) || !whitesTurn && board.isBlack(pieces[j][i])));
         else {
          fill(0,100,255,100);
          rect(i*width/8,j*height/8, width/8,height/8);
         }
       }
     }
     catch (Exception e) {} //För att fixa en bugg med ritning för bönder
    }
  }
 }
 
 if (promote) {
  stroke(1);
  fill(100,0,0,100);
  rect(0,0,2*width/8,height);
  fill(0,100,0,100);
  rect(2*width/8, 0, 2*width/8, height);
  fill(0,0,100,100);
  rect(4*width/8, 0, 2*width/8, height);
  fill(100,100,100,100);
  rect(6*width/8, 0, 2*width/8, height);
  if (!whitesTurn) {
   image(wQueen, 0.5*width/8, 3.5*height/8);
   image(wRook, 2.5*width/8, 3.5*height/8);
   image(wBishop, 4.5*width/8, 3.5*height/8);
   image(wKnight, 6.5*width/8, 3.5*height/8);       
  }
  else {
   image(bQueen, 0.5*width/8, 3.5*height/8);
   image(bRook, 2.5*width/8, 3.5*height/8);
   image(bBishop, 4.5*width/8, 3.5*height/8);
   image(bKnight, 6.5*width/8, 3.5*height/8);       
  }
  noStroke();
 }
 
 if (drag) {
  image(curr, mouseX-50, mouseY-50); 
 } 
} 

void mousePressed() {
   if (promote) {
    int x = mouseX/(width/4);
    if (!whitesTurn) {
     if (x == 0) pieces[posY][posX] = wQueen;
     if (x == 1) pieces[posY][posX] = wRook;
     if (x == 2) pieces[posY][posX] = wBishop;
     if (x == 3) pieces[posY][posX] = wKnight;
    }
    else {
     if (x == 0) pieces[posY][posX] = bQueen;
     if (x == 1) pieces[posY][posX] = bRook;
     if (x == 2) pieces[posY][posX] = bBishop;
     if (x == 3) pieces[posY][posX] = bKnight;
    }
    promote = false;
   }
   else {
     posX = mouseX/100;
     posY = mouseY/100;
     moved = false;
     curr = pieces[mouseY/100][mouseX/100];
     if ((whitesTurn && board.isWhite(curr)) || (!whitesTurn && board.isBlack(curr))) pressed = true;
     else curr = null;
   }
}

void mouseDragged() {
  if (curr != null) {
    pieces[posY][posX] = null;
    drag = true;
  }
}

void mouseReleased() {
  try {
   if (board.valid(curr,mouseX/100,mouseY/100, posX, posY) && curr != null) {
     if ((pieces[mouseY/100][mouseX/100] == null) || (whitesTurn && board.isBlack(pieces[mouseY/100][mouseX/100]))
         || (!whitesTurn && board.isWhite(pieces[mouseY/100][mouseX/100]))) {
       drag = false;
       dead = pieces[mouseY/100][mouseX/100];
       pieces[mouseY/100][mouseX/100] = curr; 
       if (curr == wPawn && mouseY/100 == 0) promote = true;
       else if (curr == bPawn && mouseY/100 == 7) promote = true;
       
       if (passant) {
        if (curr == wPawn && (mouseX/100 == posX-1 || mouseX/100 == posX+1) && dead == null) {
         pieces[pawnY][pawnX] = null; 
        }
        else if (curr == bPawn && (mouseX/100 == posX-1 || mouseX/100 == posX+1) && dead == null) {
         pieces[pawnY][pawnX] = null; 
        }
       }
       
       if (curr == wPawn && posY == 6 && mouseY/100 == 4) passant = true;
       else if (curr == bPawn && posY == 1 && mouseY/100 == 3) passant = true;
       else passant = false;
      
       
       board.castling();
       
       rmX = posX;
       rmY = posY;
       posX = mouseX/100;
       posY = mouseY/100;
       prev = curr;
       curr = null;
       pressed = false;
       moved = true;
       if (whitesTurn) whitesTurn = false;
       else whitesTurn = true;
     }
     else {
      pieces[posY][posX] = curr;
      pressed = false;
      drag = false;
      curr = null;       
     }
   }
   else if (curr != null) {
    pieces[posY][posX] = curr;
    pressed = false;
    drag = false;
    curr = null;
   }
  }
  catch (Exception e) {
    pieces[posY][posX] = curr;
    pressed = false;
    drag = false;
    curr = null;
  }
}

void keyPressed() {
 if (key == 'r') {
   pieces = new PImage[8][8];
   board.startPos();
   whitesTurn = true;
 }
 else if (key == 'b') {
   if (moved) {
     pieces[rmY][rmX] = prev;
     pieces[posY][posX] = dead;
     if (whitesTurn) whitesTurn = false;
     else whitesTurn = true;
   }
 }
 else if (key == 'q') {
  exit(); 
 }
}

class ChessBoard {
  
  ChessBoard() {
    pieces = new PImage[8][8];
    whitesTurn = true;
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
 
 boolean validSquare(int x, int y, int startX, int startY, int u, int d, boolean white) {
  for (int j = x+u, i = y+d; j < 8 && i < 8 && j >= 0 && i >= 0; j += u, i += d) {
    if (white) {
     if (isWhite(pieces[i][j])) break;
     if(isBlack(pieces[i][j])) {
      if(j == startX && i == startY) return true;
       break;
     }
    } else {
     if (isBlack(pieces[i][j])) break;
     if(isWhite(pieces[i][j])) {
      if(j == startX && i == startY) return true;
      break;
     }     
    }
    if (j == startX && i == startY) return true;
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
}