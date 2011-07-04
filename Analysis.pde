// ---------
// Variables
// ---------
import java.util.ArrayList;
import jVamp.*;

JVamp jvamp = new JVamp(this);

String pathToRefAudioFile;
String refAudioFileName;
String pathToStuAudioFile;
String stuAudioFileName;

Data reference;
Data student;

// ---------
//
// ---------

void setup() {
  refAudioFileName = "SA-MB-09-002.wav";
  pathToRefAudioFile = dataPath(refAudioFileName);
  stuAudioFileName = "SA-XB-03-002.wav";
  pathToStuAudioFile = dataPath(stuAudioFileName);
  
  reference = new Data(color(0,30,255,120));
  student = new Data(color(100,100,100,180));

  try {
    reference.loadData("reference.dat");
    student.loadData("student.dat");
  } catch (Exception e) {
    reference.runVamp(pathToRefAudioFile);
    reference.saveData("reference.dat");
    student.runVamp(pathToStuAudioFile);
    student.saveData("student.dat");
  }
  
  filterPitch(reference);
  filterPitch(student);
  
  findOnsets(reference);
  findOnsets(student);
  
  formNotes(reference);
  formNotes(student);
  
  
}





