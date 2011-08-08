//import java.util.ArrayList;
import jVamp.*;
PFont font;


JVamp jvamp = new JVamp(this);

String pathToRefAudioFile;
String refAudioFileName;
String pathToStuAudioFile;
String stuAudioFileName;

Data reference;
Data student;

int[] noteMatches;
int[] areasOfInterest;
int startTime;
int endTime;

ScrollButton leftButton;
ScrollButton rightButton;
VisualizationButton[] visualizationButtons = new VisualizationButton[3];
int[] visualizationButtonCorners = new int[4];
int[] visualizationButtonDimensions = new int[2];

void setup() {
  size(screen.width-100,screen.height-100);
  font = loadFont("ArialUnicodeMS-36.vlw");
  
  refAudioFileName = "SA-MB-09-002.wav";
  pathToRefAudioFile = dataPath(refAudioFileName);
  stuAudioFileName = "SA-XB-03-002.wav";
  pathToStuAudioFile = dataPath(stuAudioFileName);
  
  reference = new Data(color(0,30,255,120), 3.0/7.0);
  student = new Data(color(100,100,100,180), 3.0/7.0);

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
  
  areasOfInterest = findAreasOfInterest(student, reference);
  
  noteMatches = matchNotes(student, reference);
  
  startTime = 0;
  endTime = 300;
  
  leftButton = new ScrollButton(70,0.75*height,50,"left");
  rightButton = new ScrollButton(width-70, 0.75*height, 50, "right");
  visualizationButtonCorners[0] = width/2-180;
  visualizationButtonCorners[1] = width/2-30;
  visualizationButtonCorners[2] = width/2+120;
  visualizationButtonCorners[3] = height-85;
  visualizationButtonDimensions[0] = 120;
  visualizationButtonDimensions[1] = 70;
  visualizationButtons[0] = new VisualizationButton(visualizationButtonCorners[0],visualizationButtonCorners[3],visualizationButtonDimensions[0],visualizationButtonDimensions[1]);
  visualizationButtons[1] = new VisualizationButton(visualizationButtonCorners[1],visualizationButtonCorners[3],visualizationButtonDimensions[0],visualizationButtonDimensions[1]);
  visualizationButtons[2] = new VisualizationButton(visualizationButtonCorners[2],visualizationButtonCorners[3],visualizationButtonDimensions[0],visualizationButtonDimensions[1]);
  visualizationButtons[0].active = true;
}

void draw() {
  smooth();
  background(255);
  
  for(Note n : reference.notes) {
    if (visualizationButtons[0].active) {n.displayA(startTime, endTime);}
    if (visualizationButtons[1].active) {n.displayB(startTime, endTime);}
    if (visualizationButtons[2].active) {n.displayC(startTime, endTime);}
  }
  for(Note n : student.notes) {
    if (visualizationButtons[0].active) {n.displayA(startTime, endTime);}
    if (visualizationButtons[1].active) {n.displayB(startTime, endTime);}
    if (visualizationButtons[2].active) {n.displayC(startTime, endTime);}
  }
  
  for(VisualizationButton v : visualizationButtons) {
    v.changeColor();
    v.display();
  }
  
  for(Note n : reference.notes) {
    if (!visualizationButtons[0].active) {n.displayB(visualizationButtonCorners[1],visualizationButtonCorners[1]+visualizationButtonDimensions[0]); n.displayC(visualizationButtonCorners[2],visualizationButtonCorners[2]+visualizationButtonDimensions[0]);}
    if (!visualizationButtons[1].active) {n.displayA(visualizationButtonCorners[0],visualizationButtonCorners[0]+visualizationButtonDimensions[0]); n.displayC(visualizationButtonCorners[2],visualizationButtonCorners[2]+visualizationButtonDimensions[0]);}
    if (!visualizationButtons[2].active) {n.displayA(visualizationButtonCorners[0],visualizationButtonCorners[0]+visualizationButtonDimensions[0]); n.displayB(visualizationButtonCorners[1],visualizationButtonCorners[1]+visualizationButtonDimensions[0]);}
  }
  for(Note n : student.notes) {
    if (!visualizationButtons[0].active) {n.displayB(visualizationButtonCorners[1],visualizationButtonCorners[1]+visualizationButtonDimensions[0]); n.displayC(visualizationButtonCorners[2],visualizationButtonCorners[2]+visualizationButtonDimensions[0]);}
    if (!visualizationButtons[1].active) {n.displayA(visualizationButtonCorners[0],visualizationButtonCorners[0]+visualizationButtonDimensions[0]); n.displayC(visualizationButtonCorners[2],visualizationButtonCorners[2]+visualizationButtonDimensions[0]);}
    if (!visualizationButtons[2].active) {n.displayA(visualizationButtonCorners[0],visualizationButtonCorners[0]+visualizationButtonDimensions[0]); n.displayB(visualizationButtonCorners[1],visualizationButtonCorners[1]+visualizationButtonDimensions[0]);}
  }
  
  rightButton.display();
  leftButton.display();
}

void keyPressed() {
  if (keyCode >= 48 && keyCode <= 57) {
    startTime = areasOfInterest[keyCode-48];
    endTime = startTime + 300;
  }
  if (key == 'h') {
    startTime = 0;
    endTime = 20000;
  }
  if (keyCode == 37) {
    startTime = constrain(startTime-50,0,20000);
    endTime = constrain(endTime-50,0,20000);
  }
  if (keyCode == 39) {
    startTime = constrain(startTime+50,0,20000);
    endTime = constrain(endTime+50,0,20000);
  }
}

void mousePressed() {
  if (leftButton.pressed()){
    startTime = constrain(startTime-50,0,20000);
    endTime = constrain(endTime-50,0,20000);
  }
  if (rightButton.pressed()) {
    startTime = constrain(startTime+50,0,20000);
    endTime = constrain(endTime+50,0,20000);
  }
  println("1");
  for (int i = 0; i < visualizationButtons.length; i++) {
    if (visualizationButtons[i].pressed()) {
      println("2");
      for (int j = 0; j < visualizationButtons.length; j++) {
        visualizationButtons[j].active = false;
      }
      visualizationButtons[i].active = true;
    }
  }
}



