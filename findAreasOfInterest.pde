int[] findAreasOfInterest(Data student, Data reference) {

  //Break piece into ~3 second chunks (300 data points), sum up
  int cSize = 300; //Chunk size (how many points are grouped together)

  int numberOfAOIs = 5;
  int[] timeAOIs = new int[numberOfAOIs];
  int[] pitchAOIs = new int[numberOfAOIs];
  float[] timeAOIValues =  new float[numberOfAOIs];
  float[] pitchAOIValues = new float[numberOfAOIs];

  for (int i = 0; i < numberOfAOIs; i++) {
    timeAOIs[i] = 0;
    pitchAOIs[i] = 0;
    timeAOIValues[i] = 0;
    pitchAOIValues[i] = 0;
  }

  int timeDiscrepancy = 0;
  float pitchDiscrepancy = 0;

  int chunk = 0;

  for (int i = 0; i < student.time.length; i++ ) {
    if (i%cSize == 0 || i == student.time.length-1) {
      chunk++;
           
      if ( pitchDiscrepancy > min(pitchAOIValues) ) {
        for (int j = 0; j < pitchAOIs.length; j++) {
          if ( pitchAOIValues[j] == min(pitchAOIValues) ) {
            pitchAOIValues[j] = pitchDiscrepancy;
            pitchAOIs[j] = i;
            break;
          }
        }
      }
      
      if ( timeDiscrepancy > min(timeAOIValues) ) {
        for (int j = 0; j < timeAOIs.length; j++) {
          if ( timeAOIValues[j] == min(timeAOIValues) ) {
            timeAOIValues[j] = timeDiscrepancy;
            timeAOIs[j] = i;
            break;
          }
        }
      }

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
 
  return concat(timeAOIs,pitchAOIs);
}

