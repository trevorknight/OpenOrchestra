class ScrollButton {

  float x; //x position
  float y; //y position
  int s; //side
  String direction;
  float[] triangle_vertices;

  ScrollButton(float _x, float _y, int _s, String _direction) {

    x = _x - _s/2;
    y = _y - _s/2;
    s = _s;
    direction = _direction;
    triangle_vertices = new float[6];

    if ( direction.equals("right") ) {
      triangle_vertices[0] = map(0.15, 0, 1, x, x+s);
      triangle_vertices[1] = map(0.15, 0, 1, y, y+s);
      triangle_vertices[2] = map(0.15, 0, 1, x, x+s);
      triangle_vertices[3] = map(0.85, 0, 1, y, y+s);
      triangle_vertices[4] = map(0.85, 0, 1, x, x+s);
      triangle_vertices[5] = y + s/2;
    }
    if ( direction.equals("left") ) {
      triangle_vertices[0] = map(0.15, 0, 1, x+s, x);
      triangle_vertices[1] = map(0.15, 0, 1, y, y+s);
      triangle_vertices[2] = map(0.15, 0, 1, x+s, x);
      triangle_vertices[3] = map(0.85, 0, 1, y, y+s);
      triangle_vertices[4] = map(0.85, 0, 1, x+s, x);
      triangle_vertices[5] = y + s/2;
    }
  }

  void display() {
    rectMode(CORNER);
    stroke(0);
    noStroke();
    fill(200);
    rect(x,y,s,s);
    fill(255);
    triangle(triangle_vertices[0],triangle_vertices[1],triangle_vertices[2],triangle_vertices[3],triangle_vertices[4],triangle_vertices[5]);
  }
  
  boolean pressed() {
    return (mouseX > x && mouseX < x+s && mouseY > y && mouseY < y+s);
  }
}

