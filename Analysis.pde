import java.util.ArrayList;
import jVamp.*;

JVamp jvamp = new JVamp(this);

String pathToRefAudioFile;
String refAudioFileName;
String pathToStuAudioFile;
String stuAudioFileName;

float[] time;
float[] refPitch;
float[] stuPitch;
float[] refRMS;
float[] stuRMS;


void setup() {
  refAudioFileName = "SA-MB-09-002.wav";
  pathToRefAudioFile = dataPath(refAudioFileName);
  stuAudioFileName = "SA-XB-03-002.wav";
  pathToStuAudioFile = dataPath(stuAudioFileName);
  
  try {
    loadData("reference.dat", time, refPitch, refRMS);
    loadData("student.dat", time, stuPitch, stuRMS);
  } catch (Exception e) {
    runVamp(pathToRefAudioFile, refPitch, refRMS);
    runVamp(pathToStuAudioFile, stuPitch, stuRMS);
  }  

  
}


