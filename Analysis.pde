import java.util.ArrayList;
import jVamp.*;

JVamp jvamp = new JVamp(this);

String pathToRefAudioFile;
String refAudioFileName;
String pathToStuAudioFile;
String stuAudioFileName;

Data reference;
Data student;

int[] noteMatches;

int startTime = 1300;
int endTime = 1800;

void setup() {
  size(screen.width-100,screen.height-100);
  
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
  
  reference.findMinMax();
  student.findMinMax();
  
  reference.setRmsScalar();
  student.setRmsScalar();
 
  filterPitch(reference);
  filterPitch(student);

  findOnsets(reference);
  findOnsets(student);
  
  formNotes(reference);
  formNotes(student);
  
  findAreasOfInterest(student, reference);
  
  noteMatches = matchNotes(student, reference);
}

void draw() {
  smooth();
  background(255);
  for(Note n : reference.notes) {
    n.display();
  }
  for(Note n : student.notes) {
    n.display();
  }
}






