void moveView() {
  if ( (startTime != targetStartTime) || (endTime != targetEndTime) ) {
    
    startTime = ceil(lerp(float(startTime), float(targetStartTime), 0.1));
    endTime = ceil(lerp(float(endTime), float(targetEndTime), 0.1));
  }
  playbackDuration = performances[0].time[endTime] - performances[0].time[startTime];
}
