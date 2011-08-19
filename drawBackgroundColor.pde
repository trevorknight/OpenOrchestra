void drawHighlightingSquare() {  
  for (int i : measuresOfInterest) {
    if (currentMeasure == i) {
      fill(255, 0, 0, 30);
      rectMode(CORNERS);
      rect(0,0,width,height);
      break;
    }
  }
}
