//
// 2018 Copyright (c) Charles Dowd
// 

interface ScrollViewDelegate {
  // Construction
  View viewToScroll(ScrollView scrollView);
  int scrollBarSize(ScrollView scrollView);
  boolean shouldAddHorizontalScrollBar(ScrollView scrollView);
  boolean shouldAddVerticalScrollBar(ScrollView scrollView);
  float horizontalPageSize(ScrollView scrollView);
  float horizontalContentSize(ScrollView scrollView);
  float verticalPageSize(ScrollView scrollView);
  float verticalContentSize(ScrollView scrollView);

  // Events
  void scrollViewSizeDidChange(ScrollView scrollView);
  void scrollViewDidScrollVertical(ScrollView scrollView, int toPos, int fromPos);
  void scrollViewDidScrollHorizontal(ScrollView scrollView, int toPos, int fromPos);
}


class ScrollView extends View implements ScrollBarDelegate {
  ScrollViewDelegate delegate = null;
  View viewToScroll = null;
  private ScrollBar hScrollBar = null;
  private ScrollBar vScrollBar = null;

  private int scrollBarSize = 30;
  private boolean hasHorizontalScrollBar = false;
  private boolean hasVerticalScrollBar = false;

  private String srollViewSelector = "SCROLLVIEW";
  private String hScrollBarSelector = "HSCROLLBAR";
  private String vScrollBarSelector = "VSCROLLBAR";

  int sizeX = 0, sizeY = 0;

  ScrollView(int x, int y, int w, int h) {
    super(x, y, w, h);
    this.constructScrollView();
  }

  ScrollView(int x, int y, int w, int h, ScrollViewDelegate delegate) {
    super(x, y, w, h);
    this.delegate = delegate;
    this.updateScrollBarSizeFromDelegate()
      .updateScrollBarsToAddFromDelegate()
      .constructScrollView();
  }

  void draw() {
    debug.debug("ScrollView.draw() " + title + "\n");
    this.updateScrollBarSizeFromDelegate()
      .updateScrollBarsToAddFromDelegate();
    super.draw();
  }

  ScrollView constructScrollView() {
    // scrollView
    this.viewToScroll = this.viewToScrollFromDelegate();   

    sizeX = w - (hasVerticalScrollBar ? scrollBarSize : 0);
    sizeY = h - (hasHorizontalScrollBar ? scrollBarSize : 0);

    // Add HorizontalScrollBar
    // Add VerticalScrollBar
    // Add Both!

    if (hasHorizontalScrollBar) {
      hScrollBar = new ScrollBar(0, h - scrollBarSize, sizeX, scrollBarSize, ScollBarType.HORIZONTAL, this);
      hScrollBar.title = "Scroll Bar H";
      hScrollBar.selector = hScrollBarSelector;
    }

    if (hasVerticalScrollBar) {
      vScrollBar = new ScrollBar(w - scrollBarSize, 0, scrollBarSize, sizeY, ScollBarType.VERTICAL, this);
      vScrollBar.title = "Scroll Bar V";
      vScrollBar.selector = vScrollBarSelector;
    }

    // now update the viewToScroll
    return updateScrollViewSizeAndInformDelegate();
  }

  ScrollView updateScrollViewSizeAndInformDelegate() {
    int viewToScrollW = w;
    int viewToScrollH = h;

    // Size viewToScroll and tell the delegate that it changed
    if (hScrollBar != null) {
      addSubview(hScrollBar);
      viewToScrollH -= hScrollBar.h;
    }
    if (vScrollBar != null) {
      addSubview(vScrollBar);
      viewToScrollW -= vScrollBar.w;
    }

    // size the scollView now!
    if (viewToScroll != null) { 
      viewToScroll.w = viewToScrollW;
      viewToScroll.h = viewToScrollH;
      addSubview(viewToScroll);
    }

    if (delegate != null) {
      delegate.scrollViewSizeDidChange(this);
    }

    return this;
  }

  // ScrollViewDelegate calls
  ScrollView updateScrollBarSizeFromDelegate() {
    this.scrollBarSize = delegate == null ? scrollBarSize : delegate.scrollBarSize(this);
    return this;
  }

  ScrollView updateScrollBarsToAddFromDelegate() {
    this.hasHorizontalScrollBar = delegate == null ? hasHorizontalScrollBar : delegate.shouldAddHorizontalScrollBar(this);
    this.hasVerticalScrollBar = delegate == null ? hasVerticalScrollBar : delegate.shouldAddVerticalScrollBar(this);
    return this;
  }

  View viewToScrollFromDelegate() {
    return delegate == null ? viewToScroll : delegate.viewToScroll(this);
  }

  // ScrollBarDelegate
  // Manage both scroll bars

  ScollBarType scrollBarType(ScrollBar scrollBar) {
    ScollBarType type = ScollBarType.VERTICAL;
    switch(scrollBar.selector) {
    case "HSCROLLBAR":
      type = ScollBarType.HORIZONTAL;
      break;
    case "VSCROLLBAR":
      type = ScollBarType.VERTICAL;
      break;
    }
    return type;
  }

  float indicatorSize(ScrollBar scrollBar, float currentSize) {
    float page = 0.0;
    float div = 1.0;
    switch(scrollBar.type) {
    case HORIZONTAL:
      page = delegate == null ? page : delegate.horizontalPageSize(this);
      div = delegate == null ? div : delegate.horizontalContentSize(this);
      break;
    case VERTICAL:
      page = delegate == null ? page : delegate.verticalPageSize(this);
      div = delegate == null ? div : delegate.verticalContentSize(this);
      break;
    }

    return page/div;
  }

  void scroll(ScrollBar scrollBar, float toPos, float fromPos) {
    int fromOffset = 0, toOffset = 0;
    int lengthOfContent = 1, offsetSize = 1;
    float size = max(0.1, scrollBar.size);
    debug.debug("Scrolled " +  scrollBar.selector + " from "+ fromPos +  "  to  " + toPos +"\n");

    if (delegate != null) {
      switch(scrollBar.type) {
      case HORIZONTAL:
        lengthOfContent = round((1/size)*sizeX); 
        offsetSize = (lengthOfContent - sizeX);
        fromOffset = round(fromPos*offsetSize);
        toOffset = round(toPos*offsetSize);
        // The delaegate is passed the absolute values in window position offsets
        // Where in the document, the pixel position to offset for either the x -or- y axis
        delegate.scrollViewDidScrollHorizontal(this, toOffset, fromOffset);
        break;
      case VERTICAL:
        lengthOfContent = round((1/size)*sizeY); 
        offsetSize = (lengthOfContent - sizeY);
        fromOffset = round(fromPos*offsetSize);
        toOffset = round(toPos*offsetSize);
        // The delaegate is passed the absolute values in window position offsets
        // Where in the document, the pixel position to offset for either the x -or- y axis
        delegate.scrollViewDidScrollVertical(this, toOffset, fromOffset);
        break;
      }
    }
  }
}