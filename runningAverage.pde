// Calculate the (2n+1)-point running average of an array
float[] runningAverage(float[] data, int n) {

  float[] b = new float[data.length];
  
  // First n points
  for (int i = 0; i < n; i++) {
    float sum = 0;
    float[] temp = subset(data, 0, n+i+1);
    for (int j = 0; j < temp.length; j++) {
       sum += temp[j];
    }
    b[i] = sum / (i+n+1);
  }
  
  // All the middle data
  for (int i = n; i < (b.length - n); i++) {
   float sum = 0;
   float temp[] = subset(data, i-n, 2*n+1);
   for (int j = 0; j < temp.length; j++) {
       sum += temp[j];
    }
    b[i] = sum / (2*n+1);
  }
  
  // Last n points
  for (int i = (b.length-n); i < b.length; i++) {
    float sum = 0;
    float temp[] = subset(data, i-n);
    for (int j = 0; j < temp.length; j++) {
       sum += temp[j];
    }
    b[i] = sum / (b.length - i + n);
  }
  
  return b;
}
