void drawHighlightingSquare() {
  float xPoint1;
  float xPoint2;
  rectMode(CORNERS);
  
  fill(255, 255, 0, 60);  
  for (int i : timeMOIs) {
    xPoint1 = map(measureStartIndices[i], startTime, endTime, 0, width);
    xPoint2 = map(measureStartIndices[i+1], startTime, endTime, 0, width);    
    rect(xPoint1, 0, xPoint2, height);
  }

  fill(0, 255, 0, 50);
  for (int i : pitchMOIs) {
    xPoint1 = map(measureStartIndices[i], startTime, endTime, 0, width);
    xPoint2 = map(measureStartIndices[i+1], startTime, endTime, 0, width);    
    rect(xPoint1, 0, xPoint2, height);
  }
  
  strokeWeight(1);
  stroke(200);
  for (int i : measureStartIndices) {
    xPoint1 = map(i, startTime, endTime, 0, width);
    line(xPoint1,0,xPoint1,height);
  }
}

