// DEPENDENCIES
import jVamp.*;
PFont font;
import krister.Ess.*;

// VAMP
JVamp jvamp = new JVamp(this);

// DATA
String pathToRefAudioFile;
String refAudioFileName;
String pathToStuAudioFile;
String stuAudioFileName;

Data reference;
Data student;

int[] noteMatches;
int[] areasOfInterest;

// INTERFACE
int startTime;
int endTime;
int targetStartTime;
int targetEndTime;

ScrollButton leftButton;
ScrollButton rightButton;
VisualizationButton[] visualizationButtons = new VisualizationButton[3];
int[] visualizationButtonCorners = new int[4];
int[] visualizationButtonDimensions = new int[2];

// AUDIO
AudioChannel referenceChannel;
AudioChannel studentChannel;
PlayButton playReference;
PlayButton playStudent;
int startTimeMS;
int endTimeMS;

// =============================================
void setup() {
  size(1400,1000);
  font = loadFont("ArialUnicodeMS-20.vlw");
  textFont(font, 20);
  
  
  // DATA
  refAudioFileName = "SA-MB-09-002.wav";
  pathToRefAudioFile = dataPath(refAudioFileName);
  stuAudioFileName = "SA-XB-03-002.wav";
  pathToStuAudioFile = dataPath(stuAudioFileName);
  
  reference = new Data(color(0,30,255,120), 3.0/7.0, "Reference");
  student = new Data(color(100,100,100,180), 4.0/7.0, "You (1st Alto)");

  // VAMP/LOAD
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
  
  // INTERFACE
  startTime = 0;
  endTime = 300;
  targetStartTime = 0;
  targetEndTime = 300;

  leftButton = new ScrollButton(70,0.85*height,50,"left");
  rightButton = new ScrollButton(width-70, 0.85*height, 50, "right");
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
  
  // AUDIO
  Ess.start(this); // start up Ess
  referenceChannel = new AudioChannel("SA-MB-09-002.wav"); 
  studentChannel = new AudioChannel("SA-XB-03-002.wav"); 
  referenceChannel.bufferSize(referenceChannel.frames(500));
  studentChannel.bufferSize(studentChannel.frames(500));
  findTimesSetInsOuts();
  playReference = new PlayButton(60,height*0.35,35);
  playStudent = new PlayButton(60,height*0.65,35);
}

void draw() {
  smooth();
  background(255);
  fill(200);
  text("Basie-Straight Ahead :: Measure " + startTime/300, width-400, 50);
  
  int left = 0;
  int right = width;
  int top = 85;
  int bottom = height-85;
  for(Note n : reference.notes) {
    if (visualizationButtons[0].active) {n.displayA(left, right, top, bottom);}
    if (visualizationButtons[1].active) {n.displayB(left, right, top, bottom);}
    if (visualizationButtons[2].active) {n.displayC(left, right, top, bottom);}
  }
  for(Note n : student.notes) {
    if (visualizationButtons[0].active) {n.displayA(left, right, top, bottom);}
    if (visualizationButtons[1].active) {n.displayB(left, right, top, bottom);}
    if (visualizationButtons[2].active) {n.displayC(left, right, top, bottom);}
  }
  
  for(VisualizationButton v : visualizationButtons) {
    v.changeColor();
    v.display();
  }
  
  top = visualizationButtonCorners[3];
  bottom = visualizationButtonCorners[3]+visualizationButtonDimensions[1];
  for(Note n : reference.notes) {
    if (!visualizationButtons[0].active) {n.displayB(visualizationButtonCorners[1],visualizationButtonCorners[1]+visualizationButtonDimensions[0],top,bottom); n.displayC(visualizationButtonCorners[2],visualizationButtonCorners[2]+visualizationButtonDimensions[0],top,bottom);}
    if (!visualizationButtons[1].active) {n.displayA(visualizationButtonCorners[0],visualizationButtonCorners[0]+visualizationButtonDimensions[0],top,bottom); n.displayC(visualizationButtonCorners[2],visualizationButtonCorners[2]+visualizationButtonDimensions[0],top,bottom);}
    if (!visualizationButtons[2].active) {n.displayA(visualizationButtonCorners[0],visualizationButtonCorners[0]+visualizationButtonDimensions[0],top,bottom); n.displayB(visualizationButtonCorners[1],visualizationButtonCorners[1]+visualizationButtonDimensions[0],top,bottom);}
  }
  for(Note n : student.notes) {
    if (!visualizationButtons[0].active) {n.displayB(visualizationButtonCorners[1],visualizationButtonCorners[1]+visualizationButtonDimensions[0],visualizationButtonCorners[3],visualizationButtonCorners[3]+visualizationButtonDimensions[1]); n.displayC(visualizationButtonCorners[2],visualizationButtonCorners[2]+visualizationButtonDimensions[0],visualizationButtonCorners[3],visualizationButtonCorners[3]+visualizationButtonDimensions[1]);}
    if (!visualizationButtons[1].active) {n.displayA(visualizationButtonCorners[0],visualizationButtonCorners[0]+visualizationButtonDimensions[0],visualizationButtonCorners[3],visualizationButtonCorners[3]+visualizationButtonDimensions[1]); n.displayC(visualizationButtonCorners[2],visualizationButtonCorners[2]+visualizationButtonDimensions[0],visualizationButtonCorners[3],visualizationButtonCorners[3]+visualizationButtonDimensions[1]);}
    if (!visualizationButtons[2].active) {n.displayA(visualizationButtonCorners[0],visualizationButtonCorners[0]+visualizationButtonDimensions[0],visualizationButtonCorners[3],visualizationButtonCorners[3]+visualizationButtonDimensions[1]); n.displayB(visualizationButtonCorners[1],visualizationButtonCorners[1]+visualizationButtonDimensions[0],visualizationButtonCorners[3],visualizationButtonCorners[3]+visualizationButtonDimensions[1]);}
  }
  
  rightButton.display();
  leftButton.display();
  moveView();
  reference.showLegend(85,0.355*height);
  student.showLegend(85,0.655*height);
  
  // AUDIO
  
  if (referenceChannel.state==Ess.STOPPED) {
    playReference.displayStopped(mouseX,mouseY);
  }
  else {
    playReference.displayPlaying(mouseX,mouseY);
  }

  if (studentChannel.state==Ess.STOPPED) {
    playStudent.displayStopped(mouseX,mouseY);
  }
  else {
    playStudent.displayPlaying(mouseX,mouseY);
  }
}

void keyPressed() {
  if (keyCode >= 48 && keyCode <= 57) {
    targetStartTime = areasOfInterest[keyCode-48];
    targetEndTime = targetStartTime + 300;
  }
  if (key == 'h') {
    targetStartTime = 0;
    targetEndTime = 20000;
  }
  if (keyCode == 37) {
    targetStartTime = constrain(startTime-50,0,20000);
    targetEndTime = constrain(endTime-50,0,20000);
  }
  if (keyCode == 39) {
    targetStartTime = constrain(startTime+50,0,20000);
    targetEndTime = constrain(endTime+50,0,20000);
  }
  findTimesSetInsOuts();
}

void moveView() {
  if ( (startTime != targetStartTime) || (endTime != targetEndTime) ) {
    
    startTime = ceil(lerp(float(startTime), float(targetStartTime), 0.1));
    endTime = ceil(lerp(float(endTime), float(targetEndTime), 0.1));
  }
}

void mousePressed() {
  if (leftButton.pressed()){
    targetStartTime = constrain(startTime-275,0,20000);
    targetEndTime = constrain(endTime-275,0,20000);
    findTimesSetInsOuts();
  }
  if (rightButton.pressed()) {
    targetStartTime = constrain(startTime+275,0,20000);
    targetEndTime = constrain(endTime+275,0,20000);
    findTimesSetInsOuts();
  }
  for (int i = 0; i < visualizationButtons.length; i++) {
    if (visualizationButtons[i].pressed()) {
      for (int j = 0; j < visualizationButtons.length; j++) {
        visualizationButtons[j].active = false;
      }
      visualizationButtons[i].active = true;
    }
  }
  
  if (playStudent.contains(mouseX,mouseY)) {
    if (studentChannel.state==Ess.STOPPED) {
      studentChannel.play(1);
    }
    else {
      studentChannel.stop();
      studentChannel.cue(studentChannel.frames(startTimeMS));
    }
  }
  
  if (playReference.contains(mouseX,mouseY)) {
    if (referenceChannel.state==Ess.STOPPED) {
      referenceChannel.play(1);
    }
    else {
      referenceChannel.stop();
      referenceChannel.cue(referenceChannel.frames(startTimeMS));
    }
  }
}

void findTimesSetInsOuts() {
  referenceChannel.stop();
  studentChannel.stop();  
  startTimeMS = int(student.time[targetStartTime]);
  println(startTimeMS);
  endTimeMS = int(student.time[targetEndTime]);
  println(endTimeMS);
  referenceChannel.in(referenceChannel.frames(startTimeMS));
  studentChannel.in(studentChannel.frames(startTimeMS));
  referenceChannel.out(referenceChannel.frames(endTimeMS));
  studentChannel.out(studentChannel.frames(endTimeMS));
  referenceChannel.cue(referenceChannel.frames(startTimeMS));
  studentChannel.cue(studentChannel.frames(startTimeMS));
}

public void stop() {
  Ess.stop();
  super.stop();
}



