// Class for holding extracted data from recordings

class Data {
  String name;
  color noteColor;
  float[] pitch;
  float minPitch;
  float maxPitch;
  float pitchOffset;
  float[] rms;
  float maxRms;
  float[] rmsSmoothed;
  float rmsScalar;
  float[] time;
  int[] onsets;
  Note[] notes;

  Data(color _noteColor, float _pitchOffset, String _name) {
    name = _name;
    noteColor = _noteColor;
    pitch = new float[0];
    pitchOffset = _pitchOffset;
    rms = new float[0];
    rmsSmoothed = new float[0];
    time = new float[0];
    onsets = new int[0];
    notes = new Note[0];

  }
  
  void showLegend(float x, float y) {
    fill(noteColor);
    text(name, x, y);
  }

//  void runVamp(String pathToAudioFile) {
//
//    // Pitch plugin setup
//    Plugin pitchPlugin = jvamp.getPlugin("aubiopitch");
//    pitchPlugin.setParameter("pitchtype",4.0f);
//    pitchPlugin.setParameter("minfreq", 60);
//    pitchPlugin.setParameter("maxfreq", 1200);
//    pitchPlugin.setParameter("wraprange", 0.0f);
//    pitchPlugin.setParameter("silencethreshold", -60.0f);
//
//    // RMS plugin setup
//    Plugin RMSPlugin = jvamp.getPlugin("rms_amplitude");
//
//    // Run
//    FeatureList PitchFL = pitchPlugin.run(pathToAudioFile, "Fundamental Frequency");
//    FeatureList RMSFL = RMSPlugin.run(pathToAudioFile, "RMS Amplitude");
//
//    convertFreqToNumber(PitchFL);
//
//    // Initialize arrays
//
//    pitch = expand(pitch, RMSFL.size());
//    rms = expand(rms, RMSFL.size());
//    time = expand(time, RMSFL.size());
//
//    // Fill arrays
//
//    for(int i=0; i < RMSFL.size(); i++) {
//      Feature f = RMSFL.get(i);
//      time[i] = f.getTimeMs();
//      rms[i] = f.values[0];
//      FeatureList tempFL = PitchFL.getFeatures(time[i]-1, time[i]+1);
//      if (tempFL.size() == 1) {
//        Feature tempF = tempFL.get(0);
//        pitch[i] = tempF.values[0];
//      } 
//      else if (tempFL.size() > 1) {
//        println("more than one!");
//      }
//    }
//  }

  // Save data for faster running in the future
  void saveData(String filename) {

    String[] temp = new String[time.length];

    for(int i=0; i < time.length; i++) {
      temp[i] = time[i] + "\t" + pitch[i] + "\t" + rms[i];
    } 
    saveStrings(filename,temp);
  }

  // Load data
  void loadData(String file) {
    String[] lines = loadStrings(file);
    int tempL= lines.length;
    time = expand(time, tempL);
    pitch = expand(pitch, tempL);
    rms = expand(rms, tempL);    

    for (int i = 0; i < lines.length; i++) {
      String[] pieces = split(lines[i], '\t');
      if (pieces.length == 3) {
        time[i] = float(pieces[0]);
        pitch[i] = float(pieces[1]);
        rms[i] = float(pieces[2]);
      }
    }
    
    rmsSmoothed = runningAverage(rms, 3);
  }
  
  // Removes a point of pitch information if it's farther than one semitone from its neighbours.
  void filterPitch() {
    for(int i = 2; i < pitch.length-1; i++) {
      if( abs(pitch[i] - pitch[i-1]) > 1 && abs(pitch[i] - pitch[i+1]) > 1) {
        pitch[i] = 0;
      }
    }
  }
  
  //Adds an onset if it meets the criteria.
  void findOnsets() {
    boolean pitchDiscontinuityBefore;
    boolean noPitchDiscontinuityAfter;
    boolean atLeastThreePoints;
  
    for (int i = 0; i < pitch.length-5; i++ ) {
      pitchDiscontinuityBefore = abs(pitch[i+1] - pitch[i]) > 0.5; 
      noPitchDiscontinuityAfter = abs(pitch[i+1] - pitch[i+2]) < 0.5;
      atLeastThreePoints = (pitch[i+1] > 10) && (pitch[i+2] > 10) && (pitch[i+3] > 10);
      if (pitchDiscontinuityBefore && noPitchDiscontinuityAfter && atLeastThreePoints) {
        onsets = append(onsets, i+1);
      }
    }
  }
  
  // Creates an array of note objects for each data
  void formNotes() {
    int d;
    int endIndex;
    
    for (int i = 0; i < onsets.length; i++) {
      d = 0;
      
      //To make sure the last note gets processed
      if ( i < onsets.length - 1 ) {
        endIndex = onsets[i+1];      
      } else {
        endIndex = time.length;
      }
      
      // Start at the onset, keep adding to the duration until there is silence (or next onset)
      for (int j = onsets[i]; j < endIndex; j++) {
        if ( pitch[j] < 10 ) {
          break;
        } 
        else {
          d++;
        }
      }
      
      //println(data.onsets[i] +" "+ d);
      Note tempNote = new Note(i, onsets[i], d, this);
      notes = (Note[])append(notes, tempNote);
    }
  }

  void findMinMax() {
    minPitch = 100;
    for (float p : pitch) {
      if (p > 10) {
        minPitch = min(minPitch, p);
      }
    }
    maxPitch = max(pitch);
    maxRms = max(rms);
  }
  
  void setRmsScalar() {
    rmsScalar = (3.3/max(rms));
  }
}

