void loadData(String file, time, pitch, rms) {
  String[] lines = loadStrings(file);
  
  for (int i; i < lines.length; i++) {
    String[] pieces = split(lines[i], '\t');
    if (pieces.length == 3) {
      time[i] = float(pieces[0]);
      pitch[i] = float(pieces[1]);
      rms[i] = float(pieces[2]);
    }
  }
  
}
