// When a new window is selected for the visualizations, this bit of code takes indices and finds the time (in milliseconds) and sets the playback ins/outs

void findTimesSetInsOuts() {
  for (Performance p : performances) {
    p.audioChannel.stop();
  }
  startTimeMS = int(performances[0].time[int(targetStartTime)]);
  endTimeMS = int(performances[0].time[int(targetEndTime)]);
  for (Performance p : performances) {
    p.audioChannel.in(p.audioChannel.frames(startTimeMS));
    p.audioChannel.out(p.audioChannel.frames(endTimeMS));
    p.audioChannel.cue(p.audioChannel.frames(startTimeMS));
  }

}
