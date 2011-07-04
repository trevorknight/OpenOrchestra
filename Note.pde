// Class for each note in recordings

class Note {
  
  // Variables
  int duration;
  int startIndex;
  color c;
  
  // Contructor
  Note(int _startIndex, int _duration, color noteColor) {
    startIndex = _startIndex;
    duration = _duration;
    c = noteColor;
  }
  
}
