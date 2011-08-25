// Button for choosing the number of measures

class ZoomButton {
  float x; //x position
  float y; //y position
  int s; //side
  String buttonText;

  ZoomButton(float _x, float _y, int _s, String _buttonText) {

    x = _x - _s/2;
    y = _y - _s/2;
    s = _s;
    buttonText = _buttonText;
  }

  void display(boolean available) {
    rectMode(CORNER);
    noStroke();
    fill(230);
    if (available) {
      fill(200);
    }
    rect(x, y, s, s);
    fill(255);
    textAlign(CENTER);
    textFont(font, 28);
    text(buttonText,x+s/2,y+s/2+8);
    textFont(font, 20);
  }

  boolean pressed() {
    return (mouseX > x && mouseX < x+s && mouseY > y && mouseY < y+s);
  }
}

