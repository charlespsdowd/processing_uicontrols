//
// (c) 2018 Copyright Charles Dowd
// 
Debug debug = new Debug(false);

Application app;

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
