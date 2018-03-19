//
// (c) 2018 Copyright Charles Dowd
// 


Processable app;

void setup() {
  //fullScreen();
  size(1080, 600);
  app = new Application();
  app.setup();  
}

void draw() { 
  background(0);
  app.draw();
  //noLoop();
}

void mousePressed() {
  app.mousePressed();
}

void mouseDragged() {
  app.mouseDragged();
}

void mouseReleased() {
  app.mouseReleased();
}

void keyPressed() {
  app.keyPressed();
}

void keyReleased() {
  app.keyReleased();
}
