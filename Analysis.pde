// DEPENDENCIES
import jVamp.*;
PFont font;
import krister.Ess.*;

// VAMP
JVamp jvamp = new JVamp(this);

// PERFORMANCES
Performance[] performances = new Performance[2];
//  if (performances.length == 3) offsets = {3.0/7.0, 4.0/7.0};
//  if (performances.length == 3) offsets = {2.5/7.0, 3.5/7.0, 4.5/7.0};
//  if (performances.length == 4) offsets = {2.0/7.0, 3.0/7.0, 4.0/7.0, 5.0/7.0};
float[] offsets = {2.5/7.0, 3.5/7.0, 4.5/7.0};
color[] colors = {color(0,30,255,120), color(100,100,100,180), color(255,30,0,140), color(0,255,30,120)};
String[] names = {"Reference", "You (1st Alto)", "You (1st Alto, 2nd take)"};
String[] files = {"SA-MB-09-002.wav", "SA-XB-03-002.wav", "SA-XB-03-001.wav"};

float globalMinPitch;
float globalMaxPitch;
int[] noteMatches;
int[] measuresOfInterest;

// PIECE-SPECIFIC INFO
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
int startTimeMS;
int endTimeMS;
int currentTime;
float playbackDuration;

// =============================================
void setup() {
  size(1400,900);
  font = loadFont("HelveticaNeue-20.vlw");
  textFont(font, 20);
  
  
  // PERFORMANCES

  for (int i = 0; i < performances.length; i++) {
    performances[i] = new Performance(files[i], colors[i], offsets[i], names[i]);
  }
  
// VAMP/LOAD
 for (Performance p : performances) {
   try { 
     p.loadData();
   } catch (Exception e) {
     p.runVamp();
     p.saveData();
  }
 }
  
  measureStartTimes = new int[163];
  measureStartIndices = new int[163];
  findMeasureStartIndices();
  lastMeasure = 162;
  
  
  // SETUP PERFORMANCE DATA
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
  
  for (Performance p : performances) { //Requires global max/min pitch so must be run afterwards
    p.formNotes();
  }
  println("measures: " + measureStartIndices);
  measuresOfInterest = findMeasuresOfInterest(performances[0], performances[1]);
  println("measures: " + measureStartIndices);
  println(measuresOfInterest);
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
  for (Performance p : performances) {
    p.audioChannel = new AudioChannel(p.audioFileName);
    p.audioChannel.bufferSize(p.audioChannel.frames(300));
  }
  findTimesSetInsOuts();
  for (int i = 0; i < performances.length; i++) {
    performances[i].playButton = new PlayButton(60,75+45*i,35);
    performances[i].justStarted = false;
  }

  // START POINT
  currentMeasure = 12;
  setNewStartEnd();
}

void draw() {
  smooth();
  background(255);
  drawHighlightingSquare();
  fill(200);
  textAlign(LEFT);
  text("Basie-Straight Ahead :: Measure " + (currentMeasure+1) + " of " + (lastMeasure+1), width-400, 50);
  for (int i = 0; i < performances.length; i++) {
    performances[i].showLegend(85, 82+45*i);
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
  
  //SCROLLING
  rightButton.display();
  leftButton.display();
  moveView();

  
  // AUDIO
  
  for (Performance p : performances) {
    if (p.audioChannel.state == Ess.STOPPED) {
      p.playButton.displayStopped(mouseX,mouseY);
      if (p.justStarted) p.justStarted = false;
    }
    else {
      if (!p.justStarted) {
        p.justStarted = true;
        p.playStartTime = millis();
      }
      currentTime = millis();
      p.playPosition = lerp(0,width,float(currentTime-p.playStartTime)/playbackDuration);
      strokeWeight(1);
      stroke(p.noteColor);
      line(p.playPosition,0,p.playPosition,height);
      p.playButton.displayPlaying(mouseX,mouseY);
    }
  }
}

// KEY AND BUTTON PRESSES
void keyPressed() {
  if (keyCode >= 48 && keyCode <= 57) {
    println(keyCode);
    println(measuresOfInterest[keyCode-48]);
    currentMeasure = measuresOfInterest[keyCode-48];
    setNewStartEnd();
  }
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
  
  for (Performance p : performances) {
    if (p.playButton.contains(mouseX,mouseY)) {
      if (p.audioChannel.state==Ess.STOPPED) {
        p.audioChannel.play(1);
      }
      else {
        p.audioChannel.stop();
        p.audioChannel.cue(p.audioChannel.frames(startTimeMS));
      }
    }
  }
}

void audioChannelDone(AudioChannel ch) {
  ch.cue(performances[0].audioChannel.frames(startTimeMS));
}

public void stop() {
  Ess.stop();
  super.stop();
}



