import oscP5.*;
import controlP5.*;
import java.util.*;

OscP5 oscp5;
ControlP5 cp5;
Client myClient; 

float currentAttention;
float currentMeditation;
boolean teleKr = false;
boolean autovol = false;
boolean camfeed = false;
boolean facelock = false;
boolean autobright = false;

String inString;
long loop_time;
long base_time;
int col = color(255);
int loop_count=0;
static int b_factor = 50;

PFont f;

void setup() {
  size(640, 480);
  smooth();
  f = createFont("SourceCodePro-Regular.ttf", 24);
  textFont(f);
  oscp5 = new OscP5(this, 7771);

  cp5 = new ControlP5(this);

  cp5.addToggle("teleKr")
    .setLabel("teleKr")
    .setPosition(40, 100)
    .setSize(50, 20)
    .setValue(false)
    .setMode(ControlP5.SWITCH)
    ;

  cp5.addToggle("autovol")
    .setLabel("Adaptive Volume")
    .setPosition(40, 300)
    .setSize(50, 20)
    .setValue(false)
    .setMode(ControlP5.SWITCH)
    ;

  cp5.addToggle("camfeed")
    .setLabel("Camera Feed")
    .setPosition(250, 400)
    .setSize(50, 20)
    .setValue(false)
    .setMode(ControlP5.SWITCH)
    .setColorActive(#FF8000)
    ;

  cp5.addToggle("GBM")
    .setLabel("GBM")
    .setPosition(40, 200)
    .setSize(50, 20)
    .setValue(false)
    .setMode(ControlP5.SWITCH)
    ;

  cp5.addSlider("gbmMT")
    .setLabel("Meditation Threshhold")
    .setPosition(100, 200)
    .setSize(200, 20)
    .setRange(0, 100)
    .setValue(75)
    ;   
  cp5.getController("gbmMT").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("gbmMT").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);   

  cp5.addToggle("autokey")
    .setLabel("Autokey")
    .setPosition(40, 250)
    .setSize(50, 20)
    .setValue(false)
    .setMode(ControlP5.SWITCH)
    ;

  cp5.addSlider("autokeyAT")
    .setLabel("Attention Threshhold")
    .setPosition(100, 250)
    .setSize(200, 20)
    .setRange(0, 100)
    .setValue(75)
    ;   
  cp5.getController("autokeyAT").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("autokeyAT").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0); 

  java.util.List<String> l = Arrays.asList("q", "w", "a", "s", "d", "z", "x", "c");
  /* add a ScrollableList, by default it behaves like a DropdownList */
  cp5.addScrollableList("akey")
    .setLabel("Key")
    .setPosition(305, 250)
    .setSize(50, 100)
    .setBarHeight(20)
    .setItemHeight(20)
    .addItems(l)
    .setValue(3)
    .setOpen(false) 
    ;

  cp5.addToggle("autobright")
    .setLabel("Adaptive Brightness")
    .setPosition(40, 350)
    .setSize(50, 20)
    .setValue(false)
    .setMode(ControlP5.SWITCH)
    ;


  cp5.addToggle("facelock")
    .setLabel("Paranoid Face Lock")
    .setPosition(40, 400)
    .setSize(50, 20)
    .setValue(false)
    .setMode(ControlP5.SWITCH)
    .setColorActive(#FF8000)
    ;

  oscp5 = new OscP5(this, 7771);

  base_time = System.currentTimeMillis();
  loop_time = System.currentTimeMillis();

  keybot_init();

  video = new Capture(this, width/scl, height/scl);
  opencv = new OpenCV(this, width/scl, height/scl);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  faceList = new ArrayList<Face>();
}

void draw() {

  loop_count++;
  background(0);
  textSize(30);
  fill(255);
  text("Adaptive Desktop Environment", 70, 50);
  textSize(12);
  text("Listening to OSC port 7771 on localhost", 300, 110);
  text("Configure VLC Server on port 32323", 320, 125);
  if (teleKr == true) {
    textSize(12);
    fill(255);
    text("Current Attention: ", 40, 155); 
    text("Current Meditation: ", 40, 180);
    text(currentAttention, 175, 155);
    text(currentMeditation, 175, 180);
  }

  if (autovol == true) {
    if (teleKr == true)
      autovolume();
    else
      cp5.get(Toggle.class, "autovol").setValue(false);
  }

  if (GBM == true) {
    if (teleKr == true)
      gbm();
    else
      cp5.get(Toggle.class, "GBM").setValue(false);
  }
  if (autokey == true) {
    if (teleKr == true) {
      float n= cp5.get(ScrollableList.class, "akey").getValue();
      keybot(n);
    } else
      cp5.get(Toggle.class, "autokey").setValue(false);
  }
  //loop_time = System.currentTimeMillis();
  //if (loop_time >= (base_time + 5*1000)) { 
  //byte ch='0';
  //byte[] inBuffer = new byte[1];
  //while (myPort.available() > 0) {
  // inBuffer = myPort.readBytesUntil(ch);
  //// myPort.readBytesUntil(ch, inBuffer);
  // if (inBuffer != null) {
  //   String myString = new String(inBuffer);
  //   println(myString);
  //   float sensor_data = Float.valueOf(myString);

  //    println(sensor_data);
  //   //set_brightness(b_factor);
  // }
  //}
  if (autobright == true && myPort == null) {
    com_select();
    if (myPort == null){
        cp5.get(Toggle.class, "autobright").setValue(false);
    }
  }
  if (autobright == true) {  

    if (myPort.available() > 0) {
      char inByte = '1';
      StringBuffer outputBuffer = new StringBuffer();
      while (inByte!='.') {
        inByte = myPort.readChar();
        if (inByte != '.')
          outputBuffer.append(inByte);
      }
      myPort.readChar(); 
      String op = outputBuffer.toString();
      //println(op);

      b_factor = Integer.parseInt(op);
    }
    println(b_factor);
    if (b_factor > 100)
      b_factor = 100;
    set_brightness();

    //base_time = loop_time;
    //}
  }

  if (facelock == true) {
    if (!video.available())
      video.start();
    opencv.loadImage(video);
    detectFaces();

    if (camfeed == true) {
      image(video, 400, 280, 200, 150);
      noFill();
      strokeWeight(5);
      stroke(255, 128, 0);

      rect(397, 277, 202, 152);
      //Draw all the faces
      //for (int i = 0; i < faces.length; i++) {
      //  noFill();
      //  strokeWeight(5);
      //  stroke(255, 0, 0);
      //  //rect(faces[i].x*scl,faces[i].y*scl,faces[i].width*scl,faces[i].height*scl);
      //  rect(faces[i].x + 350, faces[i].y + 235, faces[i].width - 30, faces[i].height - 25);
      //}
      for (Face f : faceList) {
        strokeWeight(2);
        f.display();
      }
    }
  } else if (video.available() && facelock == false)
    video.stop();

  if (facelock == false )
    cp5.get(Toggle.class, "camfeed").setValue(false);
}




void oscEvent(OscMessage theMessage) {

  if (theMessage.checkAddrPattern("/attention")==true) {
    currentAttention = theMessage.get(0).floatValue();
    //println("Your attention is at: " + currentAttention);
  }
  if (theMessage.checkAddrPattern("/meditation")==true) {
    currentMeditation = theMessage.get(0).floatValue();
    //println("Your meditation is at: " + currentMeditation);
  } 
  //print the address and typetag of thr message to the console
  //println("OSC Meggage received! The address pattern is: " + theMessage.addrPattern() + "\n The typetag is: " +theMessage.typetag());
}

//void serialEvent(Serial p) { 
//  println("serial_event");
//  char ch = p.readChar();
//  if(ch != '.'){
//    inString+= ch;
//  }else {
//    b_factor = Integer.parseInt(inString);
//  }
//  //char inByte = '1';
//  //String outputBuffer = null;
//  //while (inByte!='.') {
//  // inByte = p.readChar();
//  // if (inByte != '.')
//  //   outputBuffer+= inByte;
//  //}
//  //p.readChar(); 
//  println(inString);

//  //b_factor = Integer.parseInt(outputBuffer);
//} 