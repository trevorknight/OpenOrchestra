// Class for each note in recordings

class Note {

  // Variables
  int noteNumber;
  int startIndex;
  int duration;
  Performance performance;
  float avgPitch;
  float offset;

  // Contructor
  Note(int _noteNumber, int _startIndex, int _duration, Performance _performanceInstance) {
    noteNumber = _noteNumber;
    startIndex = _startIndex;
    duration = _duration;
    performance = _performanceInstance;
    offset = map(performance.pitchOffset,0,1,globalMaxPitch,globalMinPitch);

    // Determine average pitch
    avgPitch = 0;
    for (int i = startIndex; i < (startIndex+duration); i++) {
      avgPitch += performance.pitch[i];
    }
    avgPitch /= (duration);
  }

// Original "embodied notes" display -- pitch and amplitude data in one
//  void displayA(int leftBorder, int rightBorder, int topBorder, int bottomBorder) {
//    if (startIndex + duration > startTime && startIndex < endTime) {
//      //Note bodies
//      fill(performance.noteColor);
//      strokeWeight(0);
//      stroke(0);
//      noStroke();
//      float xPoint;
//      float yPoint;      
//      beginShape();
//      //  Along the bottom 
//      for (int i = startIndex; i < startIndex + duration; i++) {
//        xPoint = map(i, startTime, endTime, leftBorder, rightBorder);
//        yPoint = map(performance.pitch[i] + performance.rms[i] * performance.rmsScalar, globalMinPitch, globalMaxPitch, bottomBorder, topBorder);
//        if ( xPoint <= rightBorder && xPoint >= leftBorder) { vertex(xPoint, yPoint); }
//      }
//      // Back along the top
//      for (int i = startIndex + duration - 1; i > startIndex-1; i--) {
//        xPoint = map(i, startTime, endTime, leftBorder, rightBorder);
//        yPoint = map(performance.pitch[i] - performance.rms[i] * performance.rmsScalar, globalMinPitch, globalMaxPitch, bottomBorder, topBorder);
//        if ( xPoint <= rightBorder && xPoint >= leftBorder) { vertex(xPoint, yPoint); }
//      }
//      endShape(CLOSE);
//    }
//  }
  
  void displayA(int leftBorder, int rightBorder, int topBorder, int bottomBorder) {  
    if (startIndex + duration > startTime && startIndex < endTime) { 
      //Note bodies
      noFill();
      stroke(performance.noteColor);
      strokeWeight(2);
      float xPoint;
      float yPoint;
  
      beginShape();
      //  Along the bottom 
      for (int i = startIndex; i < startIndex + duration; i++) {
        xPoint = map(i, startTime, endTime, leftBorder, rightBorder);
        yPoint = map(performance.pitch[i], globalMinPitch, globalMaxPitch, bottomBorder, topBorder);
        if ( xPoint <= rightBorder && xPoint >= leftBorder)  vertex(xPoint, yPoint);
      }
      endShape();
    }
  }
  
  void displayB(int leftBorder, int rightBorder, int topBorder, int bottomBorder) {  
    if (startIndex + duration > startTime && startIndex < endTime) {   
      //Note bodies
      fill(performance.noteColor);
      noStroke();
      float xPoint;
      float yPoint;
  
      beginShape();
      //  Along the bottom 
      for (int i = startIndex; i < startIndex + duration; i++) {
        xPoint = map(i, startTime, endTime, leftBorder, rightBorder);
        yPoint = map(offset + performance.rms[i] * performance.rmsScalar, globalMinPitch, globalMaxPitch, bottomBorder, topBorder);
        if ( xPoint <= rightBorder && xPoint >= leftBorder)  vertex(xPoint, yPoint); 
      }
      // Back along the top
      for (int i = startIndex + duration - 1; i > startIndex-1; i--) {
        xPoint = map(i, startTime, endTime, leftBorder, rightBorder);
        yPoint = map(offset - performance.rms[i] * performance.rmsScalar, globalMinPitch, globalMaxPitch, bottomBorder, topBorder);
        if ( xPoint <= rightBorder && xPoint >= leftBorder)  vertex(xPoint, yPoint); 
      }
      endShape(CLOSE);
    }
  }
  
  void displayC(int leftBorder, int rightBorder, int topBorder, int bottomBorder) {  
    if (startIndex + duration > startTime && startIndex < endTime) {   
      //Note bodies
      fill(performance.noteColor);
      noStroke();
      float xPoint1;
      float xPoint2;
      float yPoint1;
      float yPoint2;
      float yPoint3;  

      for (int i = startIndex + duration - 1; i > startIndex-1; i--) {
        xPoint1 = map(i, startTime, endTime, leftBorder, rightBorder);
        xPoint2 = map(i+1, startTime, endTime, leftBorder, rightBorder);
        yPoint1 = map(offset + performance.rmsSmoothed[i] * performance.rmsScalar, globalMinPitch, globalMaxPitch, bottomBorder, topBorder);
        yPoint2 = map(offset, globalMinPitch, globalMaxPitch, bottomBorder, topBorder);
        yPoint3 = map(offset + performance.rmsSmoothed[i+1] * performance.rmsScalar, globalMinPitch, globalMaxPitch, bottomBorder, topBorder);

        setAmpColor(performance.rmsSmoothed[i]/performance.maxRms);
        if ( xPoint2 <= rightBorder && xPoint1 >= leftBorder) quad(xPoint1,yPoint2,xPoint1,yPoint1,xPoint2,yPoint3,xPoint2,yPoint2);
      }
//      stroke(performance.noteColor);
//      strokeWeight(5);
//      noFill();
//
//      xPoint1 = constrain(map(startIndex, startTime, endTime, leftBorder, rightBorder),leftBorder,rightBorder);
//      xPoint2 = constrain(map(startIndex+duration-1, startTime, endTime, leftBorder, rightBorder),leftBorder,rightBorder);
//      yPoint2 = map(offset, globalMinPitch, globalMaxPitch, bottomBorder, topBorder);
//      line(xPoint1,yPoint2+2,xPoint2,yPoint2+2.5);
    }
  }
  
  void setAmpColor(float sca) {
    float R = 255;
    float G;
    if (sca < 0.98) {
      G = 255*pow((0.98-sca)/.98,1.0/1.5);
    } 
    else {
      R = 255;
      G = 0;
    }  
    noStroke();
    fill(R,G,0,255);
  }
  
}

