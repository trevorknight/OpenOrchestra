void formNotes(Data data) {
  int d;
  int endIndex;
  
  for (int i = 0; i < data.onsets.length; i++) {
    d = 0;
    
    //To make sure the last note gets processed
    if ( i < data.onsets.length - 1 ) {
      endIndex = data.onsets[i+1];      
    } else {
      endIndex = data.time.length;
    }
    
    // Start at the onset, keep adding to the duration until there is silence (or next onset)
    for (int j = data.onsets[i]; j < endIndex; j++) {
      if ( data.pitch[j] < 10 ) {
        break;
      } 
      else {
        d++;
      }
    }
    
    //println(data.onsets[i] +" "+ d);
    Note tempNote = new Note(data.onsets[i], d, data);
    data.notes = (Note[])append(data.notes, tempNote);
  }
}


