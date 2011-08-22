//Sets the target start/end based on what measure it
void setNewStartEnd() {
  targetStartTime = measureStartIndices[currentMeasure];
  if (currentMeasure == lastMeasure) targetEndTime = maxTime;
  else targetEndTime = measureStartIndices[currentMeasure+1];
  findTimesSetInsOuts();
}
