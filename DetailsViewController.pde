

class DetailsViewController extends ScrollViewController {
  int numberOfButtons = 12;
  int sizeOfButton = 30;
  int seperatorOfButtons = 2;

  final String b1Name = "B1";
  final String b2Name = "B2";
  final String b3Name = "B3";

  ArrayList<Button> buttons = new ArrayList<Button>();

  DetailsViewController(View view) {
    super(view);
    this.setup();
  }

  DetailsViewController setup() {
    if (view == null) return this;

    view.bg = color(0, 125, 0);
    view.bgHighlight = color(125, 0, 0);

    int bXPos = view.w/2 - view.w/4;
    int bW = view.w/2;

    for (int i = 0; i < 2*numberOfButtons; i ++) {
      Button button = null;
      button = new Button(bXPos, seperatorOfButtons * (i + 1) + sizeOfButton * i, bW, sizeOfButton);
      button.title = i+ "!";
      button.selector = "SELECT" + i;
      view.addSubview(button);
      buttons.add(button);
    }

    debug.debug("DetailsViewController.setup() buttons: " + buttons.size() +"\n");

    return this;
  }


  // ScrollViewDelegate

  // Construction

  int scrollBarSize(ScrollView scrollView) {
    return super.scrollBarSize(scrollView);
  }

  boolean shouldAddHorizontalScrollBar(ScrollView scrollView) {
    return true;
  }

  boolean shouldAddVerticalScrollBar(ScrollView scrollView) {
    return true;
  }

  float verticalPageSize(ScrollView scrollView) {
    return float(scrollView.viewToScroll.h);
  }

  float verticalContentSize(ScrollView scrollView) {
    float div = (numberOfButtons * (sizeOfButton + seperatorOfButtons)) + seperatorOfButtons;

    if (buttons != null) {
      div = buttons.size() * (sizeOfButton + seperatorOfButtons);
    }
    return div;
  }

  float horizontalPageSize(ScrollView scrollView) {
    return float(scrollView.viewToScroll.w);
  }

  float horizontalContentSize(ScrollView scrollView) {
    return float(scrollView.viewToScroll.w);
  }



  // Events (must call super)
  void scrollViewSizeDidChange(ScrollView scrollView) {
    super.scrollViewSizeDidChange(scrollView);
  }

  void scrollViewDidScrollVertical(ScrollView scrollView, int toPos, int fromPos) {
    super.scrollViewDidScrollVertical(scrollView, toPos, fromPos);
    debug.debug("DetailsViewController: toPos:  " + toPos + "fromPos: "+ fromPos + " DIFF" + (fromPos - toPos)  + "\n");

    for (int i=0; i < buttons.size(); i ++) {
      Button button = buttons.get(i);
      button.moveTo(button.x, button.y + (fromPos - toPos));
    }
  }

  void scrollViewDidScrollHorizontal(ScrollView scrollView, int toPos, int fromPos) {
    super.scrollViewDidScrollHorizontal(scrollView, toPos, fromPos);
    debug.debug("DetailsViewController: toPos:  " + toPos + "fromPos: "+ fromPos + " DIFF" + (fromPos - toPos)  + "\n");
    for (int i=0; i < buttons.size(); i ++) {
      Button button = buttons.get(i);
      button.moveTo(button.x + (fromPos - toPos), button.y);
    }
  }
}