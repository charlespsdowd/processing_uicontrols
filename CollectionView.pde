//
// 2018 Copyright (c) Charles Dowd
// 


class Size {
  int width;
  int height;
}

class CellView extends Window {
  CellView(int x, int y, int w, int h) {
    super(x, y, w, h);
  }

  void draw() {
    super.draw();
  }
}

class HeaderView extends Window {
  HeaderView(int x, int y, int w, int h) {
    super(x, y, w, h);
  }

  void draw() {
    writeText();
    super.draw();
  }

  void writeText() {
    if (title == null) return;
    textSize(11);
    textAlign(CENTER, CENTER);
    fill(160);
    text(title, xP, yP, w, h);
  }
}

interface CollectionViewDelegate {
  int cellWidthForSection(int section);
  int cellHeightForSection(int section);
  int cellHeightPaddingForSection(int section);
  int cellWidthPaddingForSection(int section);
  boolean sectionHasHeader(int section);
  boolean sectionHasFooter(int section);
  int sectionHeaderHeight(int section);
  int sectionFooterHeight(int section);
  boolean sectionShouldFlow(int section);
  boolean sectionShouldFitToWidth(int section);
  int numberOfCols(int section); // 0 == fit based on cellW 
  String titleForSection(int section);
  String footerForSection(int section);
  CellView cellViewForIndex(int section, int element);

  void didSelectElementAtIndex(int section, int element);
}

interface CollectionViewDataSource {
  int numberOfSections();
  int numberOfElementsInSection(int section);
}

interface CollectViewDataSourceDelegate {
  void dataSourceUpdated();
}

class CollectionViewSection {
  int sectionIndex;
  CollectionViewDelegate delegate;
  CollectionViewDataSource datasource;

  int sectionHeaderHeight = 24;
  int sectionFooterHeight = 24;

  String title; // to find seciton by name
  String footerText;
  int numberOfElements = 0;
  boolean hasHeader = false;
  boolean hasFooter = false;
  int cellH;
  int cellW;
  boolean flow = true; 
  boolean fitToSectionWidth = true;
  int cellHPadding = 0;
  int cellWPadding = 0;
  int numberOfCols = 1;

  // sectionView
  //  |
  //  |--headerView
  //  |--cellsView
  //      |
  //      -- cellFrame(i)
  //          |
  //          -- cellView(i)
  //  |--footerView

  View sectionView = new Window(0, 0, 0, 0); // parent for all views in sectionView.
  View headerView = new HeaderView(0, 0, 0, 0);
  View cellsView = new Window(0, 0, 0, 0);
  ArrayList<View> cellFrames = new  ArrayList<View>();
  ArrayList<View> cellViews = new  ArrayList<View>();
  View footerView  = new HeaderView(0, 0, 0, 0);

  CollectionViewSection(int sectionIndex, CollectionViewDelegate delegate, CollectionViewDataSource datasource) {
    this.sectionIndex = sectionIndex;
    this.delegate = delegate;
    this.datasource = datasource;
    sectionView.addSubview(headerView);
    sectionView.addSubview(cellsView);
    sectionView.addSubview(footerView);
  }

  CollectionViewSection attachToParent(View parent) {
    sectionView.w = parent.w;
    parent.addSubview(this.sectionView);
    sectionView.bg = parent.bg;
    sectionView.bgHighlight = parent.bgHighlight;
    headerView.bg = sectionView.bg;
    headerView.bgHighlight = sectionView.bgHighlight;
    footerView.bg = sectionView.bg;
    footerView.bgHighlight = sectionView.bgHighlight;
    cellsView.bg = sectionView.bg;
    cellsView.bgHighlight = sectionView.bgHighlight;
    return this;
  }

  int heightOfSection() {
    return sectionView.h;
  }

  CollectionViewSection updateFromDelegates() {
    numberOfElements = datasource == null ? 0 : datasource.numberOfElementsInSection(sectionIndex);
    title = delegate == null ? "" : delegate.titleForSection(sectionIndex);
    footerText = delegate == null ? "" : delegate.footerForSection(sectionIndex);
    hasHeader = delegate == null ? false : delegate.sectionHasHeader(sectionIndex);
    hasFooter = delegate == null ? false : delegate.sectionHasFooter(sectionIndex);
    sectionHeaderHeight = delegate == null ? sectionHeaderHeight : delegate.sectionHeaderHeight(sectionIndex);
    sectionFooterHeight = delegate == null ? sectionFooterHeight : delegate.sectionFooterHeight(sectionIndex);
    cellH = delegate == null ? 50 : delegate.cellHeightForSection(sectionIndex);
    cellW = delegate == null ? 50 : delegate.cellWidthForSection(sectionIndex);
    flow = delegate == null ? false : delegate.sectionShouldFlow(sectionIndex); 
    fitToSectionWidth = delegate == null ? false : delegate.sectionShouldFitToWidth(sectionIndex);
    cellHPadding = delegate == null ? 0 : delegate.cellHeightPaddingForSection(sectionIndex);
    cellWPadding = delegate == null ? 0 : delegate.cellWidthPaddingForSection(sectionIndex);
    numberOfCols = delegate == null ? 1 : delegate.numberOfCols(sectionIndex);
    return this;
  }

  CollectionViewSection createViews() {
    // add all the Cells to the cellsView.
    for (int i = 0; i < numberOfElements; i++) {
      // cellFrame
      //  |
      //  --cellView
      View frameView = new View(0, 0, 0, 0);
      cellsView.addSubview(frameView);
      CellView cellView = delegate == null ? new CellView(0, 0, 0, 0) : delegate.cellViewForIndex(sectionIndex, i);
      frameView.addSubview(cellView);
      cellFrames.add(frameView);
      cellViews.add(cellView);
    }
    return this;
  }


  CollectionViewSection resizeViews() {
    headerView.title = title;
    footerView.title = footerText;

    Rect cellRect, frameRect, sectionRect;

    int sectionHeight = 0; 
    sectionHeight += hasHeader ? sectionHeaderHeight : 0;
    sectionHeight += hasFooter ? sectionFooterHeight : 0;

    int cellHeight = this.cellH;
    int frameHeight = cellHeight + 2 * cellHPadding;

    int cellWidth = this.cellW;
    int frameWidth = cellWidth + 2 * cellWPadding;

    int numberOfRows = int(float(numberOfElements)/float(numberOfCols)) + (numberOfElements%numberOfCols == 0 ? 0 : 1); // add a row

    sectionHeight += frameHeight * numberOfRows;

    if (fitToSectionWidth) {
      frameWidth = round(sectionView.w / float(numberOfCols)); // we'll reset the width to match the cols number exactly...
      cellWidth = frameWidth - 2 * cellWPadding;
    }

    cellRect = new Rect(cellWPadding, cellHPadding, cellWidth, cellHeight); // the CellViews always sit in the frame context
    frameRect = new Rect(0, 0, frameWidth, frameHeight); //only the fame moves relative to the cellsView
    sectionRect = new Rect(0, 0, frameWidth * numberOfCols, sectionHeight); // Need tomake sure the sectionView.w is preset...??


    sectionView.w = sectionRect.w;
    sectionView.h = sectionRect.h;
    headerView.w = sectionRect.w;
    headerView.h = hasHeader ? sectionHeaderHeight : 0;
    footerView.w = sectionRect.w;
    footerView.h = hasFooter ? sectionFooterHeight : 0;
    cellsView.h = frameHeight * numberOfRows;
    cellsView.w = sectionRect.w;

    headerView.moveTo(0, 0);
    cellsView.moveTo(0, headerView.h);
    footerView.moveTo(0, headerView.h + cellsView.h);

    for (int i = 0; i < numberOfElements; i++) {
      View frameView = cellFrames.get(i);
      frameView.w = frameRect.w;
      frameView.h = frameRect.h;
      frameView.moveTo((i%numberOfCols)*frameRect.w, round(i/numberOfCols)*frameRect.h);
      View cellView = cellViews.get(i);
      cellView.w = cellRect.w;
      cellView.h = cellRect.h;
      cellView.moveTo(cellRect.x, cellRect.y);
      //cellView.title = "[" + i +"]";
    }

    return this;
  }

  CollectionViewSection moveTo(int x, int y) {
    // only move each section
    sectionView.moveTo(x, y);
    return this;
  }
}


class CollectionView extends Window implements CollectViewDataSourceDelegate, Actionable {
  CollectionViewDelegate delegate;
  CollectionViewDataSource datasource;

  // Actionable -- needs to be better!
  Actionable action = null;
  private boolean locked = false;

  ArrayList<CollectionViewSection> sections = new ArrayList<CollectionViewSection>();
  int contentHeight = 0;
  int scrollOffsetH = 0;
  int scrollOffsetV = 0;


  CollectionView(int x, int y, int w, int h, CollectionViewDelegate delegate, CollectionViewDataSource datasource) {
    super(x, y, w, h);
    this.delegate = delegate;
    this.datasource = datasource;
    this.addAction(this);
    this.setup();
  }

  void setup() {
    bg = color(125);
    bgHighlight = color(125);
    if (delegate == null || datasource == null) {
      return;
    }

    int numberOfSections = datasource == null ? 0 : datasource.numberOfSections();     
    sections.clear();

    for (int i = 0; i < numberOfSections; i ++) {
      CollectionViewSection collectionViewSection = new CollectionViewSection(i, delegate, datasource);
      collectionViewSection.attachToParent(this); // force fit to this view width...the heght comes from a calcultion based on content
      collectionViewSection.updateFromDelegates().createViews();
      sections.add(collectionViewSection);
    }
  }

  void addAction(Actionable action) {
    this.action  = action;
  }

  // Actionable
  void execute() {
    if (delegate != null) {
      for (int s = 0; s < sections.size(); s ++) {
        CollectionViewSection collectionViewSection = sections.get(s);
        for(int e = 0; e < collectionViewSection.cellViews.size(); e++) {
          View cellView = collectionViewSection.cellViews.get(e);
          if(cellView.isMouseOver) {
            delegate.didSelectElementAtIndex(s, e);
            locked = false;
            break;
          }
        }
      }
      return;
    }
  }

  void draw() {
    willDraw();
    int heightOfContent = 0;
    int xPos = scrollOffsetH;
    int yPos = scrollOffsetV;
    for (int i = 0; i < sections.size(); i ++) {
      CollectionViewSection collectionViewSection = sections.get(i);
      collectionViewSection.resizeViews().moveTo(xPos, yPos);
      yPos += collectionViewSection.heightOfSection();
      heightOfContent += collectionViewSection.heightOfSection();
    }
    contentHeight = heightOfContent;
    super.draw();
  }

  void mousePressed() {
    if (isMouseOver || locked) { 
      if (!locked) {
        locked = true;
        if (action != null) {
          action.execute();
        }
      }

      fill(255, 255, 255);
    } else {
      locked = false;
    }
  }


  int contentHeight() {
    return max(contentHeight, this.h);
  }


  void scrollViewVertical(int toPos, int fromPos) {
    scrollOffsetV += (fromPos - toPos);
  }

  void scrollViewHorizontal(int toPos, int fromPos) {
    scrollOffsetH += (fromPos - toPos);
  }


  // CollectionViewDataSourceDelegate

  void dataSourceUpdated() {
    setup();
  }
}
