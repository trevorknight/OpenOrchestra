// Class for holding extracted data from recordings

class Data {
  color noteColor;
  float[] pitch;
  float minPitch;
  float maxPitch;
  float[] rms;
  float[] time;
  int[] onsets;
  Note[] notes;

  Data(color _noteColor) {
    noteColor = _noteColor;
    pitch = new float[0];
    rms = new float[0];
    time = new float[0];
    onsets = new int[0];
    notes = new Note[0];
  }

  void runVamp(String pathToAudioFile) {

    // Pitch plugin setup
    Plugin pitchPlugin = jvamp.getPlugin("aubiopitch");
    pitchPlugin.setParameter("pitchtype",4.0f);
    pitchPlugin.setParameter("minfreq", 60);
    pitchPlugin.setParameter("maxfreq", 1200);
    pitchPlugin.setParameter("wraprange", 0.0f);
    pitchPlugin.setParameter("silencethreshold", -60.0f);

    // RMS plugin setup
    Plugin RMSPlugin = jvamp.getPlugin("rms_amplitude");

    // Run
    FeatureList PitchFL = pitchPlugin.run(pathToAudioFile, "Fundamental Frequency");
    FeatureList RMSFL = RMSPlugin.run(pathToAudioFile, "RMS Amplitude");

    convertFreqToNumber(PitchFL);

    // Initialize arrays

    pitch = expand(pitch, RMSFL.size());
    rms = expand(rms, RMSFL.size());
    time = expand(time, RMSFL.size());

    // Fill arrays

    for(int i=0; i < RMSFL.size(); i++) {
      Feature f = RMSFL.get(i);
      time[i] = f.getTimeMs();
      rms[i] = f.values[0];
      FeatureList tempFL = PitchFL.getFeatures(time[i]-1, time[i]+1);
      if (tempFL.size() == 1) {
        Feature tempF = tempFL.get(0);
        pitch[i] = tempF.values[0];
      } 
      else if (tempFL.size() > 1) {
        println("more than one!");
      }
    }
  }

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
  }

  void findMinMax() {
    minPitch = 100;
    for (float p : pitch) {
      if (p > 10) {
        minPitch = min(minPitch, p);
      }
    }
    println(minPitch);
    maxPitch = max(pitch);
    println(maxPitch);
  }
}

