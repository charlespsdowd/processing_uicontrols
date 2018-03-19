//
// 2018 Copyright (c) Charles Dowd
// 


class Window extends View {
  Window(int x, int y, int w, int h) {
    super(x, y, w, h);
    this.bg = color(32);
    this.bgHighlight = color(64);
    this.frameHightlight = color(255);
  }

  void draw() {
    //willDraw();
    drawRect();
    writeText();
    super.draw();
  }

  void drawRect() {
    if (isMouseOver) {
      stroke(frameHightlight); 
      fill(bgHighlight);
    } else {
      stroke(bg);
      fill(bg);
    }

    rectMode(CORNER);
    rect(xP, yP, w-1, h-1);
  }

  void writeText() {
  }
}
