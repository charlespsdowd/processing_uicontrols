

class View implements Processable {
  String title = null;

  ViewController vc = null;
  String selector = null;

  color bg = color(0);
  color bgHighlight = color(0);
  color frameHightlight = color(0);
  boolean highlight = true;

  View parent = null;
  ArrayList<View> children = null;
  boolean isVisible = true;
  boolean isClipped = true;

  int selectedChildIndex = 0;
  boolean isSelected = false;

  // Local reference frame
  int x = 0;
  int y = 0;
  int w = 0;
  int h = 0;

  // Global reference frame
  int xP = 0;
  int yP = 0;

  boolean isMouseOver = false;

  View(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.xP = x;
    this.yP = y;
    this.children = new ArrayList<View>();
  }

  void setup() {
  }

  void draw() {
    debug.debug("View.draw() " + title  + "\n");
    String t = (title == null) ? "None" : title;
    handleMousePosition(mouseX, mouseY);
    if (children == null) return;
    for (int i = 0; i < children.size(); i++) {
      View child = children.get(i);
      if (child.isVisible) {
        willDraw();
        child.draw();
      }
    }
  }


  void mousePressed() {
    int j = children.size() - 1;
    while (j >= 0 && !children.get(j).isMouseOver) {
      j--;
    }

    isSelected = false;
    selectedChildIndex = j;

    if (j >= 0) {
      isSelected = true;      
      children.get(j).mousePressed();
    }
  }

  void mouseReleased() {
    for (int i = 0; i < children.size(); i ++) {
      children.get(i).mouseReleased();
    }
    isSelected = false;
    selectedChildIndex = 0;
  }


  void mouseDragged() {
  }


  void handleMousePosition(int mX, int mY) {
    if (mX >= xP && mX <= xP+w && mY >= yP && mY <= yP+h) {
      isMouseOver = true;
    } else {
      isMouseOver = false;
    }
  }  

  View addSubview(View view) {
    children.add(view);
    view.parent = this;
    view.onMove();
    return this;
  }

  void onMove() {
    xP = (parent == null ? 0 : parent.xP) + x;
    yP = (parent == null ? 0 : parent.yP) + y;
    for (int i = 0; i < children.size(); i ++) {
      children.get(i).onMove();
    }
  }

  View moveTo(int x, int y) {
    this.x = x;
    this.y = y;
    this.onMove();
    return this;
  }

  void willDraw() {
    View p = parent;
    Rect wP = new Rect(0, 0, width, height);

    noClip();
    imageMode(CORNER);

    while ( p!= null ) {
      if (isClipped) {
        wP = new Rect(p.xP, p.yP, p.w, p.h);
        Rect tR = new Rect(xP, yP, w, h);
        ClipRect cr = new ClipRect(wP);
        Rect rR = cr.intersectRect(tR);

        clip(rR.x, rR.y, rR.w, rR.h);
      } else {
        noClip();
      }
      p = p.parent;
    }
  }

  void didDraw() {
    noClip();
  }
}