void runVamp(String pathToAudioFile, float[] pitch, float[] rms) {
  
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
  FeatureList PitchFL = pitchPlugin.run(pathToAudioFile);
  FeatureList RMSFL = RMSPlugin.run(pathToAudioFile);
  
  convertFreqtoNumber(PitchFL);

  // Initialize arrays
  pitch = new float[RMSFL.size()];
  rms = new float[RMSFL.size()];
  time = new float[RMSFL.size()];
  
  // Fill RMS array

  for(int i=0; i < RMSFL.size(); i++) {
    Feature f = RMSFL.get(i);
    println(time[i]);
    time[i] = f.getTimeMs();
    println(time[i]);
    rms[i] = f.values[0];
    FeatureList tempFL = PitchFL.getFeatures(time[i]-1, time[i]+1);
    Feature tempF = tempFL.get(0);
    pitch[i] = tempF.values[0]
  }
}


