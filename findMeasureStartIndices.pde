void findMeasureStartIndices() {
  int currentIndex = 0;
  for (int i = 0; i < 163; i++) {
    measureStartTimes[i] = i*1222;
    for (int j = currentIndex; j < performances[0].time.length-1; j++) {
        if (abs(performances[0].time[j+1] - measureStartTimes[i]) > abs(performances[0].time[j] - measureStartTimes[i])) {
        measureStartIndices[i] = j;
        currentIndex = j;
        break;
      }
    }
  }
}
