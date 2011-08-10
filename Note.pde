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

  void displayA(int leftBorder, int rightBorder, int topBorder, int bottomBorder) {
    if (startIndex + duration > startTime && startIndex < endTime) {
      //Note bodies
      fill(data.noteColor);
      strokeWeight(0);
      stroke(0);
      noStroke();
      float xPoint;
      float yPoint;      
      beginShape();
      //  Along the bottom 
      for (int i = startIndex; i < startIndex + duration; i++) {
        xPoint = map(i, startTime, endTime, leftBorder, rightBorder);
        yPoint = map(data.pitch[i] + data.rms[i] * data.rmsScalar, globalMinPitch, globalMaxPitch, bottomBorder, topBorder);
        if ( xPoint <= rightBorder && xPoint >= leftBorder) { vertex(xPoint, yPoint); }
      }
      // Back along the top
      for (int i = startIndex + duration - 1; i > startIndex-1; i--) {
        xPoint = map(i, startTime, endTime, leftBorder, rightBorder);
        yPoint = map(data.pitch[i] - data.rms[i] * data.rmsScalar, globalMinPitch, globalMaxPitch, bottomBorder, topBorder);
        if ( xPoint <= rightBorder && xPoint >= leftBorder) { vertex(xPoint, yPoint); }
      }
      endShape(CLOSE);
    }
  }
  
  void displayB(int leftBorder, int rightBorder, int topBorder, int bottomBorder) {  
    if (startIndex + duration > startTime && startIndex < endTime) { 
      //Note bodies
      noFill();
      stroke(data.noteColor);
      strokeWeight(1);
      float xPoint;
      float yPoint;
  
      beginShape();
      //  Along the bottom 
      for (int i = startIndex; i < startIndex + duration; i++) {
        xPoint = map(i, startTime, endTime, leftBorder, rightBorder);
        yPoint = map(data.pitch[i], globalMinPitch, globalMaxPitch, bottomBorder, topBorder);
        if ( xPoint <= rightBorder && xPoint >= leftBorder) { vertex(xPoint, yPoint); }
      }
      endShape();
    }
  }
  
  void displayC(int leftBorder, int rightBorder, int topBorder, int bottomBorder) {  
    if (startIndex + duration > startTime && startIndex < endTime) {   
      //Note bodies
      fill(data.noteColor);
      noStroke();
      float xPoint;
      float yPoint;
  
      beginShape();
      //  Along the bottom 
      for (int i = startIndex; i < startIndex + duration+1; i++) {
        xPoint = map(i, startTime, endTime, leftBorder, rightBorder);
        yPoint = map(offset + data.rmsSmoothed[i] * data.rmsScalar, globalMinPitch, globalMaxPitch, bottomBorder, topBorder);
        if ( xPoint <= rightBorder && xPoint >= leftBorder) { vertex(xPoint, yPoint); }
      }
      // Back along the top
      for (int i = startIndex + duration; i > startIndex-1; i--) {
        xPoint = map(i, startTime, endTime, leftBorder, rightBorder);
        yPoint = map(offset - data.rmsSmoothed[i] * data.rmsScalar, globalMinPitch, globalMaxPitch, bottomBorder, topBorder);
        if ( xPoint <= rightBorder && xPoint >= leftBorder) { vertex(xPoint, yPoint); }
      }
      endShape(CLOSE);
    }
  }
}

