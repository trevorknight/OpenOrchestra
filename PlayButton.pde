class PlayButton {
  float x;
  float y;
  float d;
  
  PlayButton (float _x, float _y, float _d) {
    x = _x;
    y = _y;
    d = _d;
  }
  
  boolean contains(float mx, float my) {
    if (dist(mx,my,x,y) < d/2) {
      return true;
    } else {
      return false;
    }
  }
  
  void displayStopped(float mx, float my) {
    noFill();
    stroke(200);
    strokeWeight(1);
    ellipseMode(CENTER);
    ellipse(x,y,d,d);
    if (contains(mx,my)) {
      fill(200);
    }else{
      noFill();
    }
    triangle(x-d/5,y-d/3.5,x-d/5,y+d/3.5,x+d/3,y);
  }
  void displayPlaying(float mx, float my) {
    noFill();
    stroke(200);
    strokeWeight(1);
    ellipseMode(CENTER);
    ellipse(x,y,d,d);
    if (contains(mx,my)) {
      fill(200);
    }else{
      noFill();
    }
    rectMode(CENTER);
    rect(x,y,d/2,d/2);
    stroke(240,22,22);
  } 
}
