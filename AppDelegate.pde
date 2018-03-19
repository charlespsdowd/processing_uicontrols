


interface Processable {
  void setup();
  void draw();
  void mousePressed();
  void mouseDragged();
  void mouseReleased();
}


interface AppDelegate {
}



class Application implements AppDelegate, Processable {

  Window window;
  MainViewController mainViewController;
  DetailsViewController detailViewController;
  ScrollBar scrollBar, scrollBar2;
  Window leftWindow;
  Window detailWindow;
  CollectionView collectionView;
  CollectionViewController collectionViewController;

  void setup() {
    //fullScreen();
    size(1080, 600);
    window = new Window(0, 0, width, height);
    window.title = "App Window";
    window.bg = color(125, 125, 125);

    leftWindow = new Window(0, 0, window.w/4, window.h);
    mainViewController = new MainViewController(leftWindow);
    leftWindow.title = "Main";
    mainViewController.addSubviewToParent(window);

    collectionView = new CollectionView(window.w/4, 0, 3 * window.w/4, window.h, null, null);
    collectionViewController = new GeneralCollectionViewController(collectionView);
    collectionView.title = "Detail";
    collectionView.delegate = collectionViewController;
    collectionView.datasource = collectionViewController;
    collectionViewController.addSubviewToParent(window);
    collectionView.dataSourceUpdated();
  }

  void draw() { 
    background(0);
    window.draw();
    //noLoop();
  }

  void mousePressed() {
    window.mousePressed();
  }

  void mouseDragged() {
    window.mouseDragged();
  }

  void mouseReleased() {
    window.mouseReleased();
  }
}