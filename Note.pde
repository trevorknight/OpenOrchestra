// Class for each note in recordings

class Note {

  // Variables
  int duration;
  int startIndex;
  Data data;
  float avgPitch;

  // Contructor
  Note(int _startIndex, int _duration, Data _dataInstance) {
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
    //  Along the bottom
    float xPoint;
    float yPoint;

    beginShape();
    for (int i = startIndex; i < startIndex + duration; i++) {
      xPoint = map(i, startTime, endTime, 0, width);
      yPoint = map(data.pitch[i], data.minPitch, data.maxPitch, height, 0);
      vertex(xPoint, yPoint + data.rms[i] * 10);
    }
    for (int i = startIndex + duration - 1; i > startIndex-1; i--) {
      xPoint = map(i, startTime, endTime, 0, width);
      yPoint = map(data.pitch[i], data.minPitch, data.maxPitch, height, 0);
      vertex(xPoint, yPoint - data.rms[i] * 10);
    }
    endShape(CLOSE);
  }
}

