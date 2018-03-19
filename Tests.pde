//
// 2018 Copyright (c) Charles Dowd
// 


void testRects(Window window, Window mainWindow, Window detailWindow) {
  Rect wR = new Rect(window.xP, window.yP, window.w, window.h);
  Rect wM = new Rect(mainWindow.xP, mainWindow.yP, mainWindow.w, mainWindow.h);
  Rect wD = new Rect(detailWindow.xP, detailWindow.yP, detailWindow.w, detailWindow.h);

  ClipRect xx = new ClipRect(wR);
  xx.intersectRect(wM);
  xx.intersectRect(wD);
}