// This method takes two lists of notes and matches them up.
// It uses difference in onset times, difference in average pitch, and difference in durations to do this.

int[] matchNotes(Performance student, Performance reference) {
  
  // Relative weightings for the difference
  float onsetWeight = 10.0;
  float pitchWeight = 1.0;
  float durationWeight = 0.05;
  
  float onsetTimeDiff;
  float pitchDiff;
  float durationDiff;
  
  float noteFit;
  int noteIndex;
  
  int[] noteMatches = new int[student.notes.length];
  
  for (Note s : student.notes) {
    noteFit = 1000000;
    noteIndex = 0;
    for (Note r : reference.notes) {
      if (abs(r.performance.time[r.startIndex] - s.performance.time[s.startIndex]) < 3000) {
        onsetTimeDiff = onsetWeight * abs(s.performance.time[s.startIndex] - r.performance.time[r.startIndex]);
        pitchDiff = pitchWeight * abs(s.avgPitch - r.avgPitch);
        durationDiff = durationWeight * abs(s.duration - r.duration); 
        if ( onsetTimeDiff + pitchDiff + durationDiff < noteFit ) {
          noteFit = onsetTimeDiff + pitchDiff + durationDiff;
          noteIndex = r.noteNumber;
        }
      }
    }
    noteMatches[s.noteNumber] = noteIndex;
  }
  //println(noteMatches);
  
  // Assign classes
  // Multiple student match one reference = extra notes
  // No student matches a reference = skipped note
  // 
  
  
  return noteMatches;
}
