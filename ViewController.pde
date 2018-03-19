//
// 2018 Copyright (c) Charles Dowd
// 


class ViewController {
  View view = null; 
  
  ViewController(View view) {
    this.view = view;
    if(view != null ) {
      view.vc = this;
    }
  }
 
   ViewController addSubviewToParent(View parentView) {
     parentView.addSubview(this.view);
     this.view.moveTo(0,0);
     return this;
   }
 
}