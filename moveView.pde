// Just for moving the view smoothly. 
// The startTime/endTime is the actual drawing window and the targets are 
// where it wants to end up, so it gets there 10% at a time.
void moveView() {
  if (abs(startTime-targetStartTime) < 0.5 && abs(endTime-targetEndTime) < 0.5) {
    startTime = targetStartTime;
    endTime = targetEndTime;
  }
  startTime = lerp(startTime, float(targetStartTime), 0.1);
  endTime = lerp(endTime, float(targetEndTime), 0.1);
  playbackDuration = performances[0].time[targetEndTime] - performances[0].time[targetStartTime];
}

