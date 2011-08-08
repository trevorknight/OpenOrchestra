class VisualizationButton {

  //Variables
  int x;
  int y;
  int w;
  int h;
  boolean active;


  //Constructor
  VisualizationButton(int _x, int _y, int _w, int _h) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    active = false;
  }

  void changeColor() {
    if (active) {
      fill(200);
    } 
    else {
      noFill();
    }
  }

  void display() {
    rectMode(CORNER);
    stroke(200);
    strokeWeight(0.5);
    rect(x,y,w,h);

  }

  boolean pressed() {
    return (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h);
  }
}

