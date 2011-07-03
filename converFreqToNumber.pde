void convertFreqToNumber(FeatureList fl) {
  fl.multiplyBy(1.0/440.0);
  fl.takeLog();
  fl.multiplyBy(12.0 / log(2));
  fl.add(69.0);
}
