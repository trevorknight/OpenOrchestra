void formNotes(Data data) {
  int d;
  println("start of formNotes");
  
  for (int i = 0; i < data.onsets.length-1; i++) {
    d = 0;

    for (int j = data.onsets[i]; j < data.onsets[i+1]; j++) {
      if ( data.pitch[j] < 10 ) {
        break;
      } 
      else {
        d++;
      }
    }
    println(data.onsets[i] + " " + d + " ");
    Note tempNote = new Note(data.onsets[i], d, data.noteColor);
    data.notes = (Note[])append(data.notes, tempNote);
  }
  
}
