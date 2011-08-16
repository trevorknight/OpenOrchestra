void findTimesSetInsOuts() {
  referenceChannel.stop();
  studentChannel.stop();  
  startTimeMS = int(performances[0].time[targetStartTime]);
  endTimeMS = int(performances[0].time[targetEndTime]);
  referenceChannel.in(referenceChannel.frames(startTimeMS));
  studentChannel.in(studentChannel.frames(startTimeMS));
  referenceChannel.out(referenceChannel.frames(endTimeMS));
  studentChannel.out(studentChannel.frames(endTimeMS));
  referenceChannel.cue(referenceChannel.frames(startTimeMS));
  studentChannel.cue(studentChannel.frames(startTimeMS));
}
