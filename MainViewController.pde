//
// 2018 Copyright (c) Charles Dowd
// 


class MainViewController extends ViewController implements ButtonDelegate, ScrollBarDelegate {
  final String b1Name = "B1";
  final String b2Name = "B2";
  final String b3Name = "B3";

  Button myButton = null;
  Button myButton2 = null;
  Button myButton3 = null;

  MainViewController(View view) {
    super(view);
    this.setup();
  }


  MainViewController setup() {
    if (view == null) return this;

    view.bg = color(0, 125, 0);
    view.bgHighlight = color(125, 0, 0);

    int bXPos = view.w/2 - view.w/4;
    int bW = view.w/2;
    myButton = new Button(bXPos, 2, bW, 30);
    myButton.title = "Debug on/off";
    myButton.selector = b1Name;
    myButton.buttonDelegate = this;

    myButton2 = new Button(bXPos, 42, bW, 30);
    myButton2.title = "Not you!";
    myButton2.isRounded = false;
    myButton2.selector = b2Name;
    myButton2.buttonDelegate = this;

    myButton3 = new Button(bXPos, 82, bW, 30);
    myButton3.title = "Me again!";
    myButton3.radius = 5;
    myButton3.selector = b3Name;
    myButton3.buttonDelegate = this;

    view.addSubview(myButton);
    view.addSubview(myButton2);
    view.addSubview(myButton3);
    
    return this;
  }

  // ButtonDelegate
  void buttonClicked(Button button) {
    if (button == null) return;

    switch(button.selector) {
    case b1Name:

      if (view != null) {
        //view.moveTo(view.x + 4, view.y + 4);
      }
      break;
    case b2Name:
      if (view != null) {
        //view.moveTo(view.x + 4, view.y - 4);
      }
      break;
    case b3Name:
      if (view != null) {
        //view.moveTo(view.x - 4, view.y - 4);
      }
      break;
    default:
    }
  }


  // ScrollBarDelegate

  ScollBarType scrollBarType(ScrollBar scrollBar) {
    return ScollBarType.HORIZONTAL;
  }

  float indicatorSize(ScrollBar scrollBar, float currentSize) {
    return 0.8;
  }

  void scroll(ScrollBar scrollBar, float toPos, float fromPos) {
  }
}
