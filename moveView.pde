// Just for moving the view smoothly. 
// The startTime/endTime is the actual drawing window and the targets are 
// where it wants to end up, so it gets there 10% at a time.
void moveView() {
  if ( (startTime != targetStartTime) || (endTime != targetEndTime) ) {
    
    startTime = ceil(lerp(float(startTime), float(targetStartTime), 0.1));
    endTime = ceil(lerp(float(endTime), float(targetEndTime), 0.1));
  }
  playbackDuration = performances[0].time[endTime] - performances[0].time[startTime];
}
