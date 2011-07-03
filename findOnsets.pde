void findOnsets(Data data) {
  boolean pitchDiscontinuityBefore;
  boolean noPitchDiscontinuityAfter;
  boolean atLeastThreePoints;
  boolean noOnsetBefore;

  for (int i = 0; i < data.pitch.length-5; i++ ) {
    pitchDiscontinuityBefore = abs(data.pitch[i+1] - data.pitch[i]) > 0.5; 
    noPitchDiscontinuityAfter = abs(data.pitch[i+1] - data.pitch[i+2]) < 0.5;
    atLeastThreePoints = (data.pitch[i+1] > 10) && (data.pitch[i+2] > 10) && (data.pitch[i+3] > 10);
    //    noOnsetBefore = data.onsets[data.onsets.length] != i;
    if (pitchDiscontinuityBefore && noPitchDiscontinuityAfter && atLeastThreePoints) {
      data.onsets = append(data.onsets, i+1);
    }
  }
}
