ChessBoard board = new ChessBoard();
PImage[][] pieces; //Pjäsernas positioner

PImage bPawn, wPawn, bRook, wRook, bBishop, wBishop, bKnight, wKnight, bKing, wKing, bQueen, wQueen;
PImage curr, prev, dead, extra, extra2, checker;
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
boolean check, mate;
int[][] white, black;

void setup() {
 size(800,800);
 background(500,255,500);
 noStroke();
 textSize(width/8);
 textAlign(CENTER);
 
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
    noTint();
    
   if( (i+j)%2 == 0) fill(238,238,210);
    else fill(118,150,86);
    
    //Schackrutor
    rect(i*width/8,j*height/8,width/8,height/8);
    
    if(pieces[j][i] != null) { 
     //Ritar pjäser
     image(pieces[j][i], i*width/8, j*height/8); 
    }
    
    if (pressed == true) {
     try {
       if (board.valid(curr,i,j,posX,posY)) {
         extra = pieces[j][i];
         extra2 = pieces[posY][posX];
         pieces[j][i] = curr;
         pieces[posY][posX] = null;
         if (board.check(!whitesTurn,pieces)){}
         //else if (board.check(whitesTurn,pieces)) {
          //fill(0,255,0,100);
          //rect(i*width/8,j*height/8, width/8,height/8);
         //}
         else {
          fill(100,100,100,100);
          circle(width/16 + i*width/8, height/16 + j*height/8, width/20);
         }
         pieces[j][i] = extra;
         pieces[posY][posX] = extra2;
       }
       if (i == posX && j == posY) {
        tint(255, 126);
        image(curr, i*width/8, j*height/8);
       }
     }
     catch (Exception e) {} //För att fixa en bugg med ritning för bönder
    }    
  }
 }
  
  if (mate) {
    fill(255,0,0);
    text("CHECKMATE", 0, height/2, width, height);
  }
  else if (check) {
    fill(255,0,0);
    text("CHECK", 0, height/2, width, height); 
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
   else if (!mate) {
     posX = mouseX/100;
     posY = mouseY/100;
     moved = false;
     curr = pieces[mouseY/100][mouseX/100];
     if ((whitesTurn && board.isWhite(curr)) || (!whitesTurn && board.isBlack(curr))) {
       pressed = true;
       drag = true;
       pieces[posY][posX] = null;
     }
     else curr = null;
   }
   else {
    pieces = new PImage[8][8];
    board.startPos();
    whitesTurn = true;  
    mate = false;
    check = false;
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
       
       if (check) {
         boolean antiCheck = board.check(!whitesTurn, pieces);
         if (antiCheck) {
          pieces[posY][posX] = curr;
          pieces[mouseY/100][mouseX/100] = dead;
         }
         else {
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
           checker = curr;
           pressed = false;
           moved = true;
           check = false;
           
           if (whitesTurn) whitesTurn = false;
           else whitesTurn = true; 
           check = board.check(!whitesTurn, pieces);  
           
           if (check && board.mate()) mate = true;
         }
       } 
       else {
         check = board.check(whitesTurn, pieces);
         boolean antiCheck = board.check(!whitesTurn, pieces);
         if ((check && (curr == wKing || curr == bKing)) || antiCheck) {
          pieces[posY][posX] = curr;
          pieces[mouseY/100][mouseX/100] = dead; 
          check = false;
         }
         else {           
         
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
           checker = curr;
           curr = null;
           pressed = false;
           moved = true;   
           
           if (whitesTurn) whitesTurn = false;
           else whitesTurn = true; 
           if (check && board.mate()) mate = true;
         }
       }
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
   curr = null;
   mate = false;
   check = false;
 }
 else if (key == 'b') {
   if (moved) {
     pieces[rmY][rmX] = prev;
     pieces[posY][posX] = dead;
     if (whitesTurn) whitesTurn = false;
     else whitesTurn = true;
     check = board.check(!whitesTurn, pieces);
     mate = false;
   }
 }
 else if (key == 'q') {
  exit(); 
 }
}
