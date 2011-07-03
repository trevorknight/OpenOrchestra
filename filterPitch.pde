void filterPitch(Data data) {
  for(int i = 2; i < data.pitch.length-1; i++) {
    if( abs(data.pitch[i] - data.pitch[i-1]) > 1 && abs(data.pitch[i] - data.pitch[i+1]) > 1) {
      println(i);
      println(data.pitch[i-1]);
      println(data.pitch[i]);
      println(data.pitch[i+1]);
      data.pitch[i] = 0;
    }
  }
}

