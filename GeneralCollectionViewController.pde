//
// 2018 Copyright (c) Charles Dowd
// 


class GeneralCellView extends CellView {
  PImage image;
  String name;
  String id;
  int imageH; 
  int frameSize = 0;

  GeneralCellView(int x, int y, int w, int h) {
    super(x, y, w, h);
  }

  GeneralCellView loadPerson(String id, String name) {
    this.name = name;
    this.id = id;
    this.image = loadImage("images/"+id+".png");
    this.title = name;
    return this;
  }

  void draw() {
    this.bg = color(255);
    super.draw();
    willDraw();
    if (image != null) {
      imageMode(CORNER);
      //      tint(125, 125, 125);
      frameSize = h/6; 
      imageH = h - frameSize;
      image(image, xP + w/2 - imageH/2, yP + 5, imageH, imageH);
      writeText();
    }
  }

  void writeText() {
    if (title == null) return;
    textSize(11);
    textAlign(CENTER, CENTER);
    fill(highlight && isMouseOver ? 255 : 127);
    text(title, xP, yP + imageH + 3, w, h - imageH - 5);
  }
}


class GeneralCollectionViewController extends CollectionViewController {

  GeneralCollectionViewController(CollectionView view) {
    super(view);
  }

  int numberOfSections() {
    return 6;
  }

  int numberOfElementsInSection(int section) {
    int elements = 6;
    switch(section) {
    case 0:
      elements = 5;
      break;
    case 1:
      elements = 3;
      break;
    case 2:
      elements = 4;
      break;
    case 3:
      elements = 6;
      break;
    case 4:
      elements = 9;
      break;
    case 5:
      elements = 1;
      break;
    default:
      elements = 6;
    }
    return elements;
  }

  String titleForSection(int section) {
    String title = "None";
    switch(section) {
    case 0:
      title = "Admins";
      break;
    case 1:
      title = "Authors";
      break;
    case 2:
      title = "Testers";
      break;
    case 3:
      title = "Publishers";
      break;
    case 4:
      title = "General";
      break;
    case 5:
      title = "Developers";
      break;
    default:
      title = "Others";
    }
    return title;
  }



  // CollectionViewDelegate
  int cellWidthForSection(int section) {
    return 100;
  }

  int cellHeightForSection(int section) {
    return 120;
  }

  int cellHeightPaddingForSection(int section) {
    return 3;
  }
  int cellWidthPaddingForSection(int section) {
    return 6;
  }

  boolean sectionHasHeader(int section) {
    return true;
  }

  boolean sectionHasFooter(int section) {
    return true;
  }

  int sectionHeaderHeight(int section) {
    return 40;
  }

  int sectionFooterHeight(int section) {
    return 24;
  }


  boolean sectionShouldFlow(int section) {
    return false;
  }
  boolean sectionShouldFitToWidth(int section) {
    return true;
  }

  int numberOfCols(int section) {
    return 6;
  }

  String footerForSection(int section) {
    return "Total: " + numberOfElementsInSection(section) + " people";
  }

  CellView cellViewForIndex(int section, int element) {
    GeneralCellView cell = new GeneralCellView(0, 0, 0, 0);
    cell.title = "("+section+":"+element+")";
    cell.loadPerson("" + element, section+":"+element);
    return cell;
  }
}