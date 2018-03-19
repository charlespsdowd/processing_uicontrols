

interface Processable {
  void setup();
  void draw();
  void mousePressed();
  void mouseDragged();
  void mouseReleased();
}


interface Actionable {
  void execute();
}