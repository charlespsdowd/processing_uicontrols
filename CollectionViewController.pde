

class CollectionViewController extends ScrollViewController implements CollectionViewDelegate, CollectionViewDataSource {
  int numberOfButtons = 12;
  int sizeOfButton = 30;
  int seperatorOfButtons = 2;

  final String b1Name = "B1";
  final String b2Name = "B2";
  final String b3Name = "B3";

  ArrayList<Button> buttons = new ArrayList<Button>();
  CollectionView collectionView;


  CollectionViewController(CollectionView view) {
    super(view);
    this.collectionView = view;
    this.setup();
  }

  CollectionViewController setup() {
    if (view == null) return this;

    view.bg = color(0, 125, 0);
    view.bgHighlight = color(125, 0, 0);

    int bXPos = view.w/2 - view.w/4;
    int bW = view.w/2;

    return this;
  }


  // ScrollViewDelegate

  // Construction

  int scrollBarSize(ScrollView scrollView) {
    return super.scrollBarSize(scrollView);
  }

  boolean shouldAddHorizontalScrollBar(ScrollView scrollView) {
    return false;
  }

  boolean shouldAddVerticalScrollBar(ScrollView scrollView) {
    return true;
  }

  float verticalPageSize(ScrollView scrollView) {
    return float(scrollView.viewToScroll.h);
  }

  float verticalContentSize(ScrollView scrollView) {
    float div = float(collectionView == null ? scrollView.viewToScroll.h : collectionView.contentHeight());
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
    debug.debug("CollectionViewController: toPos:  " + toPos + "fromPos: "+ fromPos + " DIFF" + (fromPos - toPos)  + "\n");
    collectionView.scrollViewVertical(toPos, fromPos);
  }

  void scrollViewDidScrollHorizontal(ScrollView scrollView, int toPos, int fromPos) {
    super.scrollViewDidScrollHorizontal(scrollView, toPos, fromPos);
    debug.debug("CollectionViewController: toPos:  " + toPos + "fromPos: "+ fromPos + " DIFF" + (fromPos - toPos)  + "\n");
    collectionView.scrollViewHorizontal(toPos, fromPos);
  }


  // CollectionViewDelegate
  int cellWidthForSection(int section) {
    return view.w;
  }

  int cellHeightForSection(int section) {
    return 40;
  }

  int cellHeightPaddingForSection(int section) {
    return 0;
  }
  int cellWidthPaddingForSection(int section) {
    return 0;
  }

  boolean sectionHasHeader(int section) {
    return false;
  }

  boolean sectionHasFooter(int section) {
    return false;
  }

  int sectionHeaderHeight(int section) {
    return 24;
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
    return 3;
  }

  String titleForSection(int section) {
    return "secion " + section + " title";
  }

  String footerForSection(int section) {
    return "secion " + section + " footer";
  }

  CellView cellViewForIndex(int section, int element) {
    return new CellView(0, 0, 0, 0);
  }
  
  void didSelectElementAtIndex(int section, int element) {
    print("Selected: "+ section +":"+element);
  }

  // interface CollectionViewDataSource 

  int numberOfSections() {
    return 10;
  }

  int numberOfElementsInSection(int section) {
    int elements = 0;
    return elements;
  }
}