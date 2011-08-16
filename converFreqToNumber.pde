// Extracted pitch information in the FeatureList is in Hz 
// This converts it to a linear scale based that corresponds to MIDI note numbers
// (60 = middle C)

void convertFreqToNumber(FeatureList fl) {
  fl.multiplyBy(1.0/440.0);
  fl.takeLog();
  fl.multiplyBy(12.0 / log(2));
  fl.add(69.0);
}
