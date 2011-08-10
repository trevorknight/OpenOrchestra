void findMeasureStartIndices() {
  int currentIndex = 0;
  for (int i = 0; i < 163; i++) {
    measureStartTimes[i] = i*1222;
    for (int j = currentIndex; j < reference.time.length-1; j++) {
        if (abs(reference.time[j+1] - measureStartTimes[i]) > abs(reference.time[j] - measureStartTimes[i])) {
        measureStartIndices[i] = j;
        currentIndex = j;
        break;
      }
    }
//  println(measureStartTimes[i] + " " + measureStartIndices[i] + " " + reference.time[measureStartIndices[i]]);  
  }
}
