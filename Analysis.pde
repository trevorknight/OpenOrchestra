// DEPENDENCIES
//import jVamp.*;
PFont font;
import krister.Ess.*;

// VAMP
//JVamp jvamp = new JVamp(this);

// PERFORMANCES AND DATA
Performance[] performances = new Performance[2];
float[] offsets = {3.0/7.0, 4.0/7.0, 5.0/7.0};
color[] colors = {color(0,30,255,120), color(100,100,100,180), color(255,255,30,120)};
String[] names = {"Reference", "You (1st Alto)", "2nd Alto"};

String pathToRefAudioFile;
String refAudioFileName;
String pathToStuAudioFile;
String stuAudioFileName;

float globalMinPitch;
float globalMaxPitch;
int[] noteMatches;
int[] areasOfInterest;
int[] measureStartTimes;
int[] measureStartIndices;
int currentMeasure;
int lastMeasure;
float[] keySignature = {55, 58, 62, 65, 69};  //key for leger lines

// INTERFACE
int startTime;
int endTime;
int maxTime;
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
boolean justStartedReference;
int referenceStartTime;
float referencePlayPosition;
boolean justStartedStudent;
int studentStartTime;
float studentPlayPosition;
int currentTime;
float playbackDuration;

// =============================================
void setup() {
  size(1400,900);
  font = loadFont("HelveticaNeue-20.vlw");
  textFont(font, 20);
  
  
  // PERFORMANCES
//  performances = new Performance[2];
//  performances[0] = new Performance("Reference", "SA-MB-09-002.wav", color(0,30,255,120));
//  performances[1] = new Performance("You (1st Alto)", "SA-XB-03-002.wav", color(100,100,100,180));
  refAudioFileName = "SA-MB-09-002.wav";
  pathToRefAudioFile = dataPath(refAudioFileName);
  stuAudioFileName = "SA-XB-03-002.wav";
  pathToStuAudioFile = dataPath(stuAudioFileName);
  
  for (int i = 0; i < performances.length; i++) {
    performances[i] = new Performance(colors[i], offsets[i], names[i]);
  }
  
// VAMP/LOAD
//  try {
    for (Performance p : performances) {
      p.loadData();
    }
//  } catch (Exception e) {
//    reference.runVamp(pathToRefAudioFile);
//    reference.saveData("reference.dat");
//    student.runVamp(pathToStuAudioFile);
//    student.saveData("student.dat");
//  }
  
  measureStartTimes = new int[163];
  measureStartIndices = new int[163];
  findMeasureStartIndices();
  lastMeasure = 162;
  
  globalMinPitch = 100;
  globalMaxPitch = 5;
  maxTime = 10000000;
  for (Performance p : performances) {
    p.findMinMax();
    p.setRmsScalar();
    p.filterPitch();
    p.findOnsets();
    globalMinPitch = min(p.minPitch, globalMinPitch);
    globalMaxPitch = max(p.maxPitch, globalMaxPitch);  
    maxTime = min(maxTime, p.time.length)-1;
  }
  
  for (Performance p : performances) {
    p.formNotes();
  }

//  areasOfInterest = findAreasOfInterest(performances[0], performances[1]);
//  noteMatches = matchNotes(student, reference);

  
  // INTERFACE
  startTime = 0;
  endTime = 300;
  targetStartTime = 0;
  targetEndTime = 300;

  leftButton = new ScrollButton(70,height-50, 40,"left");
  rightButton = new ScrollButton(width-70, height-50, 40, "right");
  visualizationButtonCorners[0] = width/2-180;
  visualizationButtonCorners[1] = width/2-30;
  visualizationButtonCorners[2] = width/2+120;
  visualizationButtonCorners[3] = height-85;
  visualizationButtonDimensions[0] = 120;
  visualizationButtonDimensions[1] = 70;
  visualizationButtons[0] = new VisualizationButton("Intonation",visualizationButtonCorners[0],visualizationButtonCorners[3],visualizationButtonDimensions[0],visualizationButtonDimensions[1]);
  visualizationButtons[1] = new VisualizationButton("Articulation",visualizationButtonCorners[1],visualizationButtonCorners[3],visualizationButtonDimensions[0],visualizationButtonDimensions[1]);
  visualizationButtons[2] = new VisualizationButton("Dynamics",visualizationButtonCorners[2],visualizationButtonCorners[3],visualizationButtonDimensions[0],visualizationButtonDimensions[1]);
  visualizationButtons[0].active = true;
  
  // AUDIO
  Ess.start(this); // start up Ess
  referenceChannel = new AudioChannel("SA-MB-09-002.wav"); 
  studentChannel = new AudioChannel("SA-XB-03-002.wav"); 
  referenceChannel.bufferSize(referenceChannel.frames(500));
  studentChannel.bufferSize(studentChannel.frames(500));
  findTimesSetInsOuts();
  playReference = new PlayButton(60,height*0.075,35);
  playStudent = new PlayButton(60,height*0.125,35);
  justStartedReference = false;
  justStartedStudent = false;
  
  // START POINT
  currentMeasure = 12;
  setNewStartEnd();
}

void draw() {
  smooth();
  background(255);
  fill(200);
  textAlign(LEFT);
  text("Basie-Straight Ahead :: Measure " + (currentMeasure+1) + " of " + (lastMeasure+1), width-400, 50);
  for (int i = 0; i < performances.length; i++) {
    performances[i].showLegend(85, 75+45*i);
  }

  // MAIN VISUALIZATION
  int left = 0;
  int right = width;
  int top = 85;
  int bottom = height-85;
  for (Performance p : performances) {
    for(Note n : p.notes) {
      if (visualizationButtons[0].active) n.displayA(left, right, top, bottom);
      if (visualizationButtons[1].active) n.displayB(left, right, top, bottom);
      if (visualizationButtons[2].active) n.displayC(left, right, top, bottom);
    }
  }
//  for(Note n : student.notes) {
//    if (visualizationButtons[0].active) n.displayA(left, right, top, bottom);
//    if (visualizationButtons[1].active) n.displayB(left, right, top, bottom);
//    if (visualizationButtons[2].active) n.displayC(left, right, top, bottom);
//  }
  
  if (visualizationButtons[0].active) {
    stroke(200);
    strokeWeight(1);
    for (float f : keySignature) {
      float ksPoint = map(f,globalMinPitch,globalMaxPitch,bottom,top);
      line(0,ksPoint,width,ksPoint);
    }
  }
  
  if (visualizationButtons[2].active) {
    float yPoint;
    strokeWeight(5);
    noFill();
    for (Performance p : performances) {
      yPoint = map(p.pitchOffset, 0, 1, top, bottom)+2.5;
      stroke(p.noteColor);
      line(0,yPoint,width,yPoint);
    }
  }
  
  // VISUALIZATION BUTTONS
  for(VisualizationButton v : visualizationButtons) {
    v.display();
  }
  
  top = visualizationButtonCorners[3];
  bottom = visualizationButtonCorners[3]+visualizationButtonDimensions[1];
  for (Performance p : performances) {
    for(Note n : p.notes) {
      n.displayA(visualizationButtonCorners[0],visualizationButtonCorners[0]+visualizationButtonDimensions[0],top,bottom);
      n.displayB(visualizationButtonCorners[1],visualizationButtonCorners[1]+visualizationButtonDimensions[0],top,bottom); 
      n.displayC(visualizationButtonCorners[2],visualizationButtonCorners[2]+visualizationButtonDimensions[0],top,bottom);
    }
  }
//  for(Note n : student.notes) {
//    n.displayA(visualizationButtonCorners[0],visualizationButtonCorners[0]+visualizationButtonDimensions[0],top,bottom);
//    n.displayB(visualizationButtonCorners[1],visualizationButtonCorners[1]+visualizationButtonDimensions[0],top,bottom); 
//    n.displayC(visualizationButtonCorners[2],visualizationButtonCorners[2]+visualizationButtonDimensions[0],top,bottom);
//  }
  

  
  
  //SCROLLING
  rightButton.display();
  leftButton.display();
  moveView();

  
  // AUDIO
  
  if (referenceChannel.state==Ess.STOPPED) {
    playReference.displayStopped(mouseX,mouseY);
    if (justStartedReference) justStartedReference = false;
  }
  else {
    if (!justStartedReference) {
      justStartedReference = true;
      referenceStartTime = millis();
    }
    currentTime = millis();
    referencePlayPosition = lerp(0,width,float(currentTime-referenceStartTime)/playbackDuration);
    strokeWeight(1);
    stroke(colors[0]);
    line(referencePlayPosition,0,referencePlayPosition,height);
    playReference.displayPlaying(mouseX,mouseY);
  }

  if (studentChannel.state==Ess.STOPPED) {
    playStudent.displayStopped(mouseX,mouseY);
    if (justStartedStudent) justStartedStudent = false;
  }
  else {
    if (!justStartedStudent) {
      justStartedStudent = true;
      studentStartTime = millis();
    }
    currentTime = millis();
    studentPlayPosition = lerp(0,width,float(currentTime-studentStartTime)/playbackDuration);
    strokeWeight(1);
    stroke(colors[1]);
    line(studentPlayPosition,0,studentPlayPosition,height);
    playStudent.displayPlaying(mouseX,mouseY);
  }
}


// KEY AND BUTTON PRESSES
void keyPressed() {
  if (keyCode >= 48 && keyCode <= 57) {
    targetStartTime = areasOfInterest[keyCode-48];
    targetEndTime = targetStartTime + 300;
  }
  if (key == 'h') {
    targetStartTime = 0;
    targetEndTime = maxTime;
  }
  findTimesSetInsOuts();
}

void mousePressed() {
  if (leftButton.pressed()){
    if (currentMeasure != 0) currentMeasure -= 1;
    setNewStartEnd();
  }
  if (rightButton.pressed()) {
    if (currentMeasure != lastMeasure) currentMeasure += 1;
    setNewStartEnd();
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

void audioChannelDone(AudioChannel ch) {
  ch.cue(referenceChannel.frames(startTimeMS));
}

public void stop() {
  Ess.stop();
  super.stop();
}



