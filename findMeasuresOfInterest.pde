//This code compares two sets of data and finds measures of most difference.

int[] findMeasuresOfInterest(Performance student, Performance reference) {
  
  int numberOfMOIs = 5; // The number of measures for each category (time and pitch) is set here.
  timeMOIs = new int[numberOfMOIs];
  pitchMOIs = new int[numberOfMOIs];
  float[] timeMOIValues =  new float[numberOfMOIs];
  float[] pitchMOIValues = new float[numberOfMOIs];
  measureStartIndices = append(measureStartIndices, maxTime);
  
  for (int i = 0; i < numberOfMOIs; i++) {
    timeMOIs[i] = 0;
    pitchMOIs[i] = 0;
    timeMOIValues[i] = 0;
    pitchMOIValues[i] = 0;
  }

  int timeDiscrepancy = 0;
  float pitchDiscrepancy = 0;

  int measure = 0;

  for (int i = 0; i < maxTime; i++ ) {
    if (i == measureStartIndices[measure+1] || i == student.time.length-1) {
      println(i);
      println(measure);
      println(measureStartIndices[measure]);
      println(pitchDiscrepancy);
      println(timeDiscrepancy);

      if ( pitchDiscrepancy > min(pitchMOIValues) ) {
        for (int j = 0; j < pitchMOIs.length; j++) {
          if ( pitchMOIValues[j] == min(pitchMOIValues) ) {
            pitchMOIValues[j] = pitchDiscrepancy;
            pitchMOIs[j] = measure;
            break;
          }
        }
      }
      
      if ( timeDiscrepancy > min(timeMOIValues) ) {
        for (int j = 0; j < timeMOIs.length; j++) {
          if ( timeMOIValues[j] == min(timeMOIValues) ) {
            timeMOIValues[j] = timeDiscrepancy;
            timeMOIs[j] = measure;
            break;
          }
        }
      }
      
      measure++;
      pitchDiscrepancy = 0;
      timeDiscrepancy = 0;
    }

    if ( (student.pitch[i] < 5) && (reference.pitch[i] > 5) || ((student.pitch[i] > 5) && (reference.pitch[i] < 5))) {
      timeDiscrepancy++;
    }

    if ( student.pitch[i] > 5 && reference.pitch[i] > 5 ) {
      pitchDiscrepancy += abs(student.pitch[i] - reference.pitch[i]);
    }
  }
 
  return concat(timeMOIs,pitchMOIs);
}

