// Class for everything related to one recording

class Performance {
  String name;
  String audioFileName;
  String pathToAudioFile;
  Data data;
  color noteColor;
  AudioChannel audioChannel;
  PlayButton playButton;
  boolean justStarted;
  int playStartTime;
  float playPosition;
  
  Performance(String _name, String _audioFileName, color _noteColor) {
    name = _name;
    audioFileName = _audioFileName;
    pathToAudioFile = dataPath(audioFileName);
    noteColor = _noteColor;
  }  
  
}
