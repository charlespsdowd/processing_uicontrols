
class Debug {
  boolean on = false;
  boolean addNewline = false;
  
  Debug(boolean on) {
    this.on = on;
  }
  
  void debug(String s) {
    if(on) {
      print(s + (addNewline ? "\n" : ""));
    }
  }
}


class Rect {
  int x;
  int y;
  int w;
  int h;
  
  Rect(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  Rect(Rect r) {
    this.x = r.x;
    this.y = r.y;
    this.w = r.w;
    this.h = r.h;
  }
  
  String asString() {
    return "("+this.x+", "+this.y+", "+this.w+", "+this.h+")";
  }
  
}


class ClipRect  {
  Rect clipRect;
  ClipRect(Rect rect) {
    this.clipRect = new Rect(rect);
  }
  
  Rect intersectRect(Rect rect) {
    Rect intersetedRect = new Rect(clipRect);
    intersetedRect.x = max(rect.x, clipRect.x) - 1;
    intersetedRect.y = max(rect.y, clipRect.y) - 1;
    
    int xR = min(rect.x + rect.w, clipRect.x + clipRect.w);
    int yR = min(rect.y + rect.h, clipRect.y + clipRect.h);
    
    intersetedRect.w = max(0, xR - intersetedRect.x + 1);
    intersetedRect.h = max(0, yR - intersetedRect.y + 1);
    
    //debug.debug("Input Rects: \t" + clipRect.asString() + " intersect " + rect.asString() + "\n" 
    //    + "Intersect Rect: \t" + intersetedRect.asString() +"\n");
    
    return intersetedRect;  
  }
  
}