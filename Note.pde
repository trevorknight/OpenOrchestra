// Class for each note in recordings

class Note {


  // Variables
  int noteNumber;
  int startIndex;
  int duration;
  Data data;
  float avgPitch;
  float offset;

  // Contructor
  Note(int _noteNumber, int _startIndex, int _duration, Data _dataInstance) {
    noteNumber = _noteNumber;
    startIndex = _startIndex;
    duration = _duration;
    data = _dataInstance;
    offset = map(data.pitchOffset,0,1,globalMaxPitch,globalMinPitch);

    // Determine average pitch
    avgPitch = 0;
    for (int i = startIndex; i < (startIndex+duration); i++) {
      avgPitch += data.pitch[i];
    }
    avgPitch /= (duration);
  }

// Original "embodied notes" display -- pitch and amplitude data in one
//  void displayA(int leftBorder, int rightBorder, int topBorder, int bottomBorder) {
//    if (startIndex + duration > startTime && startIndex < endTime) {
//      //Note bodies
//      fill(data.noteColor);
//      strokeWeight(0);
//      stroke(0);
//      noStroke();
//      float xPoint;
//      float yPoint;      
//      beginShape();
//      //  Along the bottom 
//      for (int i = startIndex; i < startIndex + duration; i++) {
//        xPoint = map(i, startTime, endTime, leftBorder, rightBorder);
//        yPoint = map(data.pitch[i] + data.rms[i] * data.rmsScalar, globalMinPitch, globalMaxPitch, bottomBorder, topBorder);
//        if ( xPoint <= rightBorder && xPoint >= leftBorder) { vertex(xPoint, yPoint); }
//      }
//      // Back along the top
//      for (int i = startIndex + duration - 1; i > startIndex-1; i--) {
//        xPoint = map(i, startTime, endTime, leftBorder, rightBorder);
//        yPoint = map(data.pitch[i] - data.rms[i] * data.rmsScalar, globalMinPitch, globalMaxPitch, bottomBorder, topBorder);
//        if ( xPoint <= rightBorder && xPoint >= leftBorder) { vertex(xPoint, yPoint); }
//      }
//      endShape(CLOSE);
//    }
//  }
  
  void displayA(int leftBorder, int rightBorder, int topBorder, int bottomBorder) {  
    if (startIndex + duration > startTime && startIndex < endTime) { 
      //Note bodies
      noFill();
      stroke(data.noteColor);
      strokeWeight(2);
      float xPoint;
      float yPoint;
  
      beginShape();
      //  Along the bottom 
      for (int i = startIndex; i < startIndex + duration; i++) {
        xPoint = map(i, startTime, endTime, leftBorder, rightBorder);
        yPoint = map(data.pitch[i], globalMinPitch, globalMaxPitch, bottomBorder, topBorder);
        if ( xPoint <= rightBorder && xPoint >= leftBorder)  vertex(xPoint, yPoint);
      }
      endShape();
    }
  }
  
  void displayB(int leftBorder, int rightBorder, int topBorder, int bottomBorder) {  
    if (startIndex + duration > startTime && startIndex < endTime) {   
      //Note bodies
      fill(data.noteColor);
      noStroke();
      float xPoint;
      float yPoint;
  
      beginShape();
      //  Along the bottom 
      for (int i = startIndex; i < startIndex + duration; i++) {
        xPoint = map(i, startTime, endTime, leftBorder, rightBorder);
        yPoint = map(offset + data.rms[i] * data.rmsScalar, globalMinPitch, globalMaxPitch, bottomBorder, topBorder);
        if ( xPoint <= rightBorder && xPoint >= leftBorder)  vertex(xPoint, yPoint); 
      }
      // Back along the top
      for (int i = startIndex + duration - 1; i > startIndex-1; i--) {
        xPoint = map(i, startTime, endTime, leftBorder, rightBorder);
        yPoint = map(offset - data.rms[i] * data.rmsScalar, globalMinPitch, globalMaxPitch, bottomBorder, topBorder);
        if ( xPoint <= rightBorder && xPoint >= leftBorder)  vertex(xPoint, yPoint); 
      }
      endShape(CLOSE);
    }
  }
  
  void displayC(int leftBorder, int rightBorder, int topBorder, int bottomBorder) {  
    if (startIndex + duration > startTime && startIndex < endTime) {   
      //Note bodies
      fill(data.noteColor);
      noStroke();
      float xPoint1;
      float xPoint2;
      float yPoint1;
      float yPoint2;
      float yPoint3;  
//      beginShape();

      for (int i = startIndex + duration - 1; i > startIndex-1; i--) {
        xPoint1 = map(i, startTime, endTime, leftBorder, rightBorder);
        xPoint2 = map(i+1, startTime, endTime, leftBorder, rightBorder);
        yPoint1 = map(offset + data.rmsSmoothed[i] * data.rmsScalar, globalMinPitch, globalMaxPitch, bottomBorder, topBorder);
        yPoint2 = map(offset, globalMinPitch, globalMaxPitch, bottomBorder, topBorder);
        yPoint3 = map(offset + data.rmsSmoothed[i+1] * data.rmsScalar, globalMinPitch, globalMaxPitch, bottomBorder, topBorder);
//        if ( xPoint2 <= rightBorder && xPoint1 >= leftBorder) vertex(xPoint1, yPoint1); 
        setAmpColor(data.rmsSmoothed[i]/data.maxRms);
        if ( xPoint2 <= rightBorder && xPoint1 >= leftBorder) quad(xPoint1,yPoint2,xPoint1,yPoint1,xPoint2,yPoint3,xPoint2,yPoint2);
      }
      stroke(data.noteColor);
      strokeWeight(2);
      noFill();
//      endShape();
      xPoint1 = constrain(map(startIndex, startTime, endTime, leftBorder, rightBorder),leftBorder,rightBorder);
      xPoint2 = constrain(map(startIndex+duration-1, startTime, endTime, leftBorder, rightBorder),leftBorder,rightBorder);
      yPoint2 = map(offset, globalMinPitch, globalMaxPitch, bottomBorder, topBorder);
      line(xPoint1,yPoint2+1,xPoint2,yPoint2+1);
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

