void findTimesSetInsOuts() {
  for (Performance p : performances) {
    p.audioChannel.stop();
  }
  startTimeMS = int(performances[0].time[targetStartTime]);
  endTimeMS = int(performances[0].time[targetEndTime]);
  for (Performance p : performances) {
    p.audioChannel.in(p.audioChannel.frames(startTimeMS));
    p.audioChannel.out(p.audioChannel.frames(endTimeMS));
    p.audioChannel.cue(p.audioChannel.frames(startTimeMS));
  }

}
