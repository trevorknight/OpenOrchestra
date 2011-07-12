// Class for each note in recordings

class Note {

  // Variables
  int noteNumber;
  int startIndex;
  int duration;
  Data data;
  float avgPitch;

  // Contructor
  Note(int _noteNumber, int _startIndex, int _duration, Data _dataInstance) {
    noteNumber = _noteNumber;
    startIndex = _startIndex;
    duration = _duration;
    data = _dataInstance;

    // Determine average pitch
    avgPitch = 0;
    for (int i = startIndex; i < (startIndex+duration); i++) {
      avgPitch += data.pitch[i];
    }
    avgPitch /= (duration);
  }

  void display() {  //Standard, one stave
     
    //Note bodies
    fill(data.noteColor);
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
  }
}

