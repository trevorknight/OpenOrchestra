void setNewStartEnd() {
  targetStartTime = measureStartIndices[currentMeasure];
  if (currentMeasure == lastMeasure) targetEndTime = maxTime;
  else targetEndTime = measureStartIndices[currentMeasure+1];
  findTimesSetInsOuts();
}
