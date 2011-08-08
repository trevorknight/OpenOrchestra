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
    offset = map(data.pitchOffset,0,1,data.maxPitch,data.minPitch);

    // Determine average pitch
    avgPitch = 0;
    for (int i = startIndex; i < (startIndex+duration); i++) {
      avgPitch += data.pitch[i];
    }
    avgPitch /= (duration);
  }

  void displayA(int leftBorder, int rightBorder int topBorder, int bottomBorder) {  
    if (startIndex + duration > start && startIndex < end) {
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
        xPoint = map(i, startTime, endTime, 0, width);
        yPoint = map(data.pitch[i] + data.rms[i] * data.rmsScalar, data.minPitch, data.maxPitch, height, 0);
        vertex(xPoint, yPoint);
      }
      // Back along the top
      for (int i = startIndex + duration - 1; i > startIndex-1; i--) {
        xPoint = map(i, startTime, endTime, 0, width);
        yPoint = map(data.pitch[i] - data.rms[i] * data.rmsScalar, data.minPitch, data.maxPitch, height, 0);
        vertex(xPoint, yPoint);
      }
      endShape(CLOSE);
      
      beginShape();
      //  Along the bottom 
      for (int i = startIndex; i < startIndex + duration; i++) {
        xPoint = map(i, startTime, endTime, leftBorder, rightBorder);
        yPoint = map(data.pitch[i] + data.rms[i] * data.rmsScalar, data.minPitch, data.maxPitch, bottomBorder, topBorder);
        vertex(xPoint, yPoint);
      }
      // Back along the top
      for (int i = startIndex + duration - 1; i > startIndex-1; i--) {
        xPoint = map(i, startTime, endTime, leftBorder, rightBorder);
        yPoint = map(data.pitch[i] - data.rms[i] * data.rmsScalar, data.minPitch, data.maxPitch, bottomBorder, topBorder);
        vertex(xPoint, yPoint);
      }
      endShape(CLOSE);
    }
  }
  
  void displayB(int start, int end) {  
    if (startIndex + duration > start && startIndex < end) { 
      //Note bodies
      noFill();
      stroke(data.noteColor);
      strokeWeight(2);
      float xPoint;
      float yPoint;
  
      beginShape();
      //  Along the bottom 
      for (int i = startIndex; i < startIndex + duration; i++) {
        xPoint = map(i, startTime, endTime, 0, width);
        yPoint = map(data.pitch[i], data.minPitch, data.maxPitch, height, 0);
        vertex(xPoint, yPoint);
      }
      endShape();
      
      beginShape();
      //  Along the bottom 
      for (int i = startIndex; i < startIndex + duration; i++) {
        xPoint = map(i, startTime, endTime, 0, width);
        yPoint = map(data.pitch[i], data.minPitch, data.maxPitch, height, 0);
        vertex(xPoint, yPoint);
      }
      endShape();
    }
  }
  
  void displayC(int start, int end) {  
    if (startIndex + duration > start && startIndex < end) {   
      //Note bodies
      fill(data.noteColor);
      noStroke();
      float xPoint;
      float yPoint;
  
      beginShape();
      //  Along the bottom 
      for (int i = startIndex; i < startIndex + duration; i++) {
        xPoint = map(i, startTime, endTime, 0, width);
        yPoint = map(offset + data.rms[i] * data.rmsScalar, data.minPitch, data.maxPitch, height, 0);
        vertex(xPoint, yPoint);
      }
      // Back along the top
      for (int i = startIndex + duration - 1; i > startIndex-1; i--) {
        xPoint = map(i, startTime, endTime, 0, width);
        yPoint = map(offset - data.rms[i] * data.rmsScalar, data.minPitch, data.maxPitch, height, 0);
        vertex(xPoint, yPoint);
      }
      endShape(CLOSE);
    }  
  }
}

