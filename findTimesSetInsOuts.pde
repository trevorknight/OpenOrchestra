void findTimesSetInsOuts() {
  referenceChannel.stop();
  studentChannel.stop();  
  startTimeMS = int(student.time[targetStartTime]);
  endTimeMS = int(student.time[targetEndTime]);
  referenceChannel.in(referenceChannel.frames(startTimeMS));
  studentChannel.in(studentChannel.frames(startTimeMS));
  referenceChannel.out(referenceChannel.frames(endTimeMS));
  studentChannel.out(studentChannel.frames(endTimeMS));
  referenceChannel.cue(referenceChannel.frames(startTimeMS));
  studentChannel.cue(studentChannel.frames(startTimeMS));
}
