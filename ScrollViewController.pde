//
// 2018 Copyright (c) Charles Dowd
// 


class ScrollViewController extends ViewController implements ScrollViewDelegate {
  ScrollView scrollWindow = null;

  int srcollPositionX = 0;
  int srcollPositionY = 0;
  int pageSizeX = 0;
  int pageSizeY = 0;

  ScrollViewController(View view) {
    super(view);
    this.constructFromParts();
  }

  ScrollViewController constructFromParts() {
    scrollWindow = new ScrollView(view.x, view.y, view.w, view.h, this);
    view.moveTo(0, 0);
    pageSizeX = view.w;
    pageSizeY = view.h;
    return this;
  }

  ViewController addSubviewToParent(View parentView) {
    parentView.addSubview(this.scrollWindow);
    return this;
  }

  // ScrollViewDelegate

  // Construction
  View viewToScroll(ScrollView scrollView) {
    return view;
  }

  int scrollBarSize(ScrollView scrollView) {
    return 30;
  }
  boolean shouldAddHorizontalScrollBar(ScrollView scrollView) {
    return false;
  }

  boolean shouldAddVerticalScrollBar(ScrollView scrollView) {
    return false;
  }

  float verticalPageSize(ScrollView scrollView) {
    return float(scrollView.viewToScroll.h);
  }

  float verticalContentSize(ScrollView scrollView) {
    return 1.0;
  }

  float horizontalPageSize(ScrollView scrollView) {
    return float(scrollView.viewToScroll.w);
  }

  float horizontalContentSize(ScrollView scrollView) {
    return float(scrollView.viewToScroll.w);
  }


  // Events
  void scrollViewSizeDidChange(ScrollView scrollView) {
    pageSizeX = view.w;
    pageSizeY = view.h;
  }

  void scrollViewDidScrollHorizontal(ScrollView scrollView, int toPos, int fromPos) {
    srcollPositionX = toPos;
  }

  void scrollViewDidScrollVertical(ScrollView scrollView, int toPos, int fromPos) {
    srcollPositionY = toPos;
  }
}