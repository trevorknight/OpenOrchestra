class VisualizationButton {

  String name;
  int x;
  int y;
  int w;
  int h;
  boolean active;


  //Constructor
  VisualizationButton(String _name, int _x, int _y, int _w, int _h) {
    name = _name;
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    active = false;
  }

  void display() {
    fill(200);
    textAlign(CENTER);
    text(name,x+w/2,y-5);
    noFill();
    rectMode(CORNER);
    stroke(200);
    strokeWeight(0.5);
    rect(x,y,w,h);
    if (active) {
      strokeWeight(3);
      line(x,y+h+5,x+w,y+h+5);
    }
  }

  boolean pressed() {
    return (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h);
  }
}

