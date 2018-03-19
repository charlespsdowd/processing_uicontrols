

enum ScollBarType {
  VERTICAL, 
    HORIZONTAL,
};

interface ScrollBarDelegate {
  ScollBarType scrollBarType(ScrollBar scrollBar); // default: VERTICAL
  float indicatorSize(ScrollBar scrollBar, float currentSize); // returns a value 0..1 (>=1 turns OFF scolling), 0.0 is defalt (inifinity)
  void scroll(ScrollBar scrollBar, float toPos, float fromPos); // toPos, fromPos = {0..1}
}


class ScrollBar extends Window implements Slidable, ButtonDelegate {
  ScrollBarDelegate delegate = null;
  ScollBarType type = ScollBarType.VERTICAL;
  SliderButton first, second;
  Window barArea = null;
  Button indicator;
  float pos = 0.0;
  float size = 0.0; // default (anything up to 1.0, 1.0 disables the scrolling).
  private int majorAxisLength = 0; // (h - 2 * w) for VERT; (w - 2 * h) for HORIZ
  private int minorAxisLength = 0; //  w for VERT; h for HORIZ
  private int indicatorLength = 0; // range: [minorAxisLength .. majorAxisLength], default minorAxisLength when size == 0.0


  ScrollBar(int x, int y, int w, int h) {
    super(x, y, w, h);
    this.updateTypeFromDelegate().updateSizeFromDelegate().updateAxes().setupSlider();
  }

  ScrollBar(int x, int y, int w, int h, ScollBarType type) {
    super(x, y, w, h);
    this.type = type;
    this.updateSizeFromDelegate().updateAxes().setupSlider();
  }

  ScrollBar(int x, int y, int w, int h, ScollBarType type, float size) {
    super(x, y, w, h);
    this.type = type;
    this.size =  min(1.0, max(0.0, size));
    this.updateAxes().setupSlider();
  }

  ScrollBar(int x, int y, int w, int h, ScrollBarDelegate delegate) {
    super(x, y, w, h);
    this.delegate = delegate;
    this.updateTypeFromDelegate().updateSizeFromDelegate().updateAxes().setupSlider();
  }

  ScrollBar(int x, int y, int w, int h, ScollBarType type, ScrollBarDelegate delegate) {
    super(x, y, w, h);
    this.type = type;
    this.delegate = delegate;
    this.updateSizeFromDelegate().updateAxes().setupSlider();
  }

  void draw() {
    debug.debug("ScrollBar.draw() " + title + "\n");
    this.updateTypeFromDelegate()
      .updateSizeFromDelegate()
      .updateAxes()
      .didScrollToNewPos();
    super.draw();
  }

  ScrollBar updateTypeFromDelegate() {
    this.type = (delegate == null) ? type : delegate.scrollBarType(this);
    return this;
  }

  ScrollBar updateSizeFromDelegate() {
    this.size = (delegate == null) ? size : delegate.indicatorSize(this, size);
    this.size = min(1.0, max(0.0, size));
    return this;
  }

  ScrollBar updateAxes() {
    int major = 0;
    int minor = 0; 
    int nub = 0;

    switch (type) {
    case VERTICAL:
      minor = w; 
      major = (h - 2 * w);
      major = max(major, minor);
      break;
    case HORIZONTAL:
      minor = h;
      major = (w - 2 * h);
      major = max(major, minor);
      break;
    }

    nub = size == 0.0 ? minor : round(size * major);
    nub = max(nub, minor);

    this.majorAxisLength = major;
    this.minorAxisLength = minor;
    this.indicatorLength = nub;

    return this;
  }

  ScrollBar setupSlider() {
    Rect fRect = null, lRect = null, iRect = null, aRect = null;

    switch (type) {
    case VERTICAL:
      fRect = new Rect(0, 0, w, w);
      lRect = new Rect(0, h - w, w, w);

      iRect = new Rect(0, w, w, majorAxisLength);
      aRect = new Rect(0, 0, w, indicatorLength); // in iRect reference 
      first = new SliderButton(fRect.x, fRect.y, fRect.w, fRect.h, SliderActions.UP);
      second = new SliderButton(lRect.x, lRect.y, lRect.w, lRect.h, SliderActions.DOWN);
      break;
    case HORIZONTAL:
      fRect = new Rect(0, 0, h, h);
      lRect = new Rect(w - h, 0, h, h);

      iRect = new Rect(h, 0, majorAxisLength, h);
      aRect = new Rect(0, 0, indicatorLength, h); // in iRect reference 
      first = new SliderButton(fRect.x, fRect.y, fRect.w, fRect.h, SliderActions.LEFT);
      second = new SliderButton(lRect.x, lRect.y, lRect.w, lRect.h, SliderActions.RIGHT);
      break;
    }

    first.target = this;
    second.target = this;

    barArea = new Window(iRect.x, iRect.y, iRect.w, iRect.h);
    indicator = new Button(aRect.x, aRect.y, aRect.w, aRect.h);
    indicator.buttonDelegate = this;
    indicator.selector = "HANDLE";
    indicator.title = ""; //"("+pos+")";
    indicator.bg = color(0);

    this.addSubview(first);
    this.addSubview(second);
    this.barArea.addSubview(indicator);
    this.addSubview(barArea);

    didScrollToNewPos();

    return this;
  }


  // Slidable
  void slide(SliderActions action) {
    float newPos = pos; 
    this.updateSizeFromDelegate().updateAxes();

    switch (action) {
    case UP:
      newPos = max(0.0, newPos - (size == 0.0 ? 0.1 : size)); 
      break;
    case DOWN:
      newPos = min(1.0, newPos + (size == 0.0 ? 0.1 : size)); 
      break;
    case LEFT:
      newPos = max(0.0, newPos - (size == 0.0 ? 0.1 : size)); 
      break;
    case RIGHT:
      newPos = min(1.0, newPos + (size == 0.0 ? 0.1 : size)); 
      break;
    }

    if (delegate != null && newPos != pos) { 
      delegate.scroll(this, newPos, pos);
    }
    pos = newPos;
    indicator.title = ""; // "("+pos+")";
    didScrollToNewPos();
  }


  void didScrollToNewPos() {
    int x = 0, y = 0;
    int scrollLength = majorAxisLength - indicatorLength;
    int scrollPosition = round(scrollLength * pos);
    scrollPosition = pos == 1.0 ? scrollLength : scrollPosition;

    switch (type) {
    case VERTICAL:
      indicator.h = indicatorLength;
      x = 0;
      y = scrollPosition;
      break;
    case HORIZONTAL:
      indicator.w = indicatorLength;
      x = scrollPosition;
      y = 0;
      break;
    }

    indicator.moveTo(x, y);
    indicator.isVisible = (size < 1);
  }

  // ButtonDelegate
  void buttonClicked(Button button) {
    if (delegate == null) return;
    float newPos = pos; 

    switch(button.selector) {
    case "HANDLE":
      delegate.scroll(this, newPos, pos); 
      break;
    default:
      debug.debug("no button pressed on scroll bar");
    }

    pos = newPos;
  }
}