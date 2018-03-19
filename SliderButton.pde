//
// 2018 Copyright (c) Charles Dowd
// 


enum SliderActions {
  UP, DOWN, LEFT, RIGHT
};

interface Slidable {
  void slide(SliderActions action);
}

class SliderButton extends Button implements ButtonDelegate {
  Slidable target = null;
  SliderActions action = null; // = SliderActions.RIGHT;

  SliderButton(int x, int y, int w, int h) {
    super(x, y, w, h);
    this.title = "NA";
    this.singleClick = false;
  }

  SliderButton(int x, int y, int w, int h, SliderActions action) {
    super(x, y, w, h);
    this.addAction(action);
    this.buttonDelegate = this;
  }

  void draw() {
    //willDraw();
    debug.debug("SliderButton.draw() " + title  + "\n");
    super.draw();
  }

  SliderButton addAction(SliderActions action) {
    this.action = action;
    this.addTitle();
    return this;
  }


  SliderButton addTitle() {
    if (action == null) {
      title = "NA";
      return this;
    }
    switch(action) {
    case UP:
      title = "/\\";
      break;
    case DOWN:
      title = "\\/";
      break;
    case LEFT:
      title = "<-";
      break;
    case RIGHT:
      title = "->";
      break;
    default:
      title = "**";
      break;
    }
    return this;
  }


  void buttonClicked(Button button) {
    if (button == null) return;
    if (target == null || action == null) return;
    target.slide(action);
  }
}