//
// 2018 Copyright (c) Charles Dowd
// 


interface Actionable {
  void execute();
}

interface ButtonDelegate {
  void buttonClicked(Button button);
}


class Button extends View implements Actionable {
  ButtonDelegate buttonDelegate = null;
  Actionable action = null;

  boolean singleClick = true;
  boolean isRounded = true;
  float radius = 0;

  private float defaultRadius = 2.3;
  private boolean locked = false;

  Button(int x, int y, int w, int h) {
    super(x, y, w, h);
    this.addAction(this);
  }

  void addAction(Actionable action) {
    this.action  = action;
  }

  void setup() {
  }

  void draw() {
    drawRect();
    writeText();
    super.draw();
  }

  void mousePressed() {
    if (isMouseOver && !singleClick) {
      if (action != null) {
        action.execute();
      }
    } else if (isMouseOver || locked) { 
      if (!locked ) {
        locked = true;
        if (action != null) {
          action.execute();
        }
      }

      fill(255, 255, 255);
    } else {
      locked = false;
    }
  }

  void mouseDragged() {
  }

  void mouseReleased() {
    locked = false;
  }


  // Helpers

  void highlightRollOver() {
    if (!highlight) return;

    if (isMouseOver) {
      stroke(255); 
      fill(153);
    } else {
      stroke(153);
      fill(153);
    }
  }

  void drawRect() {
    highlightRollOver();
    rectMode(CORNER);
    float r = isRounded ? (radius == 0 ? defaultRadius : radius) : 0;
    rect(xP, yP, w, h, r);
  }

  void writeText() {
    if (title == null) return;
    textSize(11);
    textAlign(CENTER, CENTER);
    fill(highlight && isMouseOver ? 255 : 0);
    text(title, xP, yP, w, h);
  }

  // Actionable
  void execute() {
    if (buttonDelegate != null) {
      buttonDelegate.buttonClicked(this);
      return;
    }
  }
}
