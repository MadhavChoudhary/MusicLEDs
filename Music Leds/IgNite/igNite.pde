boolean fileLoaded = false;

color blue = #335755;
color white = #EDDDBB;
color grey = #3D3B38;
color black = #0C0A0B;

PFont Arial;
PImage bckgrd;

float  songProgress;
float  volume = 0.5;
float volumeSliderX;

int playButtonAlpha = 150;
int loadFileAlpha = 150;
int progressBarAlpha = 150; // bar
int soundVisionAlpha = 50;  // visual;

String state = "PLAY";
String title = "";

import cc.arduino.*;
import org.firmata.*;
import ddf.minim.*;  
import ddf.minim.analysis.*;
import processing.serial.*;

Arduino arduino;

AudioMetaData meta;
Minim minim;
AudioPlayer player;
FFT fft;

int redPin1 = 12;
int greenPin1 = 11;
int bluePin1 = 10;

int redPin2 = 9;
int greenPin2 = 8;
int bluePin2 = 7;

int redPin3 = 6;
int greenPin3 = 5;
int bluePin3 = 4;

int color_id = 0;

int common_cathode = 1;

PImage fai_iconi;
PGraphics fai_icong;
String fai_filename;

void setup() {
  
  size(600, 200);
    
  arduino = new Arduino(this, "COM5", 57600);
  for (int i = 0; i <= 13; i++) arduino.pinMode(i, Arduino.OUTPUT);
  for (int i = 0; i <= 13; i++) arduino.digitalWrite(i,arduino.HIGH);
    
  Arial = loadFont("data/Arial.vlw");
  bckgrd = loadImage("background.png");
  
  volumeSliderX = width-30;

  minim = new Minim(this);

}

void draw() {
  background(white);
  smooth(28);
  
  for (int i = 0; i<900; i+=200) {
    image(bckgrd, i, 0);              //Stamps background Image.
  }

  
  if (fileLoaded) {
    soundVision();                  //Calls visualizer function
    player.setGain(volume);
    
    fill(0, 0, 0, 255);
    textSize(21);    //Prints title out
    textAlign(CENTER);
    text(title, width/2, 30);
  }
  buttons();                        //controls other smaller functions.



}

void mouseReleased() {
  if (fileLoaded && player.position()>=player.length()) {          
    state = "PLAY";                                        //Resets song when it finishes.
  }
  if (mouseX>0 && mouseX<80 && mouseY < 40) {
    if (state == "PLAY" && fileLoaded) {                              
      state = "PAUSE";                                  //Plays song.
      player.play();
      player.setVolume(volume); //~~~~~~~~~~~~~~~~~~Volume?------------------\\
    } else if (state == "PAUSE") {
      state = "PLAY";                                  //Pauses song.
      player.pause();
    }
  }

  if (mouseX>width-110 && mouseX<width && mouseY < 40) {
    selectInput("Select a file to process:", "fileSelected");    //Calls selectInput if button pressed.
  }
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    String filepath = selection.getAbsolutePath();
    println("User selected " + filepath);
    // load file here
    player = minim.loadFile(filepath);
    fft = new FFT( player.bufferSize(), player.sampleRate());
    meta = player.getMetaData();
    fileLoaded = true;
    title = meta.title();
  }
}


void soundVision() {
  fft.forward( player.mix );

  fill(#45ADA8, soundVisionAlpha);
  stroke(grey);
  strokeWeight(1);


  if (progressBarAlpha<200 && soundVisionAlpha<255) {
    soundVisionAlpha+=3;
  } else if (soundVisionAlpha>50) {
    soundVisionAlpha-=5;
  }

  for (int i = 0; i < fft.specSize (); i+=5) {

    // draw the line for frequency band i, scaling it up a bit so we can see it
    colorMode(HSB);
    //stroke(i, 255, 255);

    //line( i, height, i, height - fft.getBand(i)*8 );



    rect(i+width/2, height - fft.getBand(i)*8, 10, height);
    //ellipse(i+width/2,height + 10 - fft.getBand(i)*5, 10,10);
  }

  for (int i = 0; i < fft.specSize (); i+=5) {

    // draw the line for frequency band i, scaling it up a bit so we can see it
    colorMode(HSB);
    //stroke(i, 255, 255);

    // strokeWeight(10);
    // stroke(#45ADA8,50);
    //fill(#45ADA8,20);
    //line( i+width/2, height, i+width/2, height - fft.getBand(i)*8 );


    rect(i, height - fft.getBand(i)*8, 10, height);
    //ellipse(i,height + 10 - fft.getBand(i)*5, 10,10);
  }
  
  //translate(250, 0);   
      for(int i = 0; i < 0+fft.specSize(); i++) {
        //line(i, height*4/5, i, height*4/5 - fft.getBand(i)*4); 
        //if(i%100==0) text(fft.getBand(i), i, height*4/5+20);
        if(i==200) {
          if(fft.getBand(i)>2) {
            setColor1(0,255,255);
            setColor3(0,255,255);
          }
          else if(fft.getBand(i)>1) {
            setColor1(255,0,255);
            setColor3(255,0,255);
          } else {
            setColor1(255,255,255);
            setColor3(255,255,255);
          }
        }
        if(i==50) {
          if(fft.getBand(i)>5) {
            color_id = (color_id+1)%4;
          } else if(fft.getBand(i)>3) {
            if(color_id==0) setColor2(255,255,0);
            else if(color_id==1) setColor2(0,255,0);
            else if(color_id==2) setColor2(255,0,0);
            else setColor2(0,255,255);
          } 
          else {
            setColor2(255,255,255);
          }
        } 
      }  
  
}

void stop()
{
    for (int i = 0; i <= 13; i++) arduino.digitalWrite(i,arduino.HIGH);
    player.close();  
    minim.stop();
    super.stop();
}
void setColor1(int red, int green, int blue)
{
  if(common_cathode==1) {
    red = 255-red;
    green = 255-green;
    blue = 255-blue;
  }
  arduino.digitalWrite(redPin1, red);
  arduino.digitalWrite(greenPin1, green);
  arduino.digitalWrite(bluePin1, blue);  
}
void setColor2(int red, int green, int blue)
{
  if(common_cathode==1) {
    red = 255-red;
    green = 255-green;
    blue = 255-blue;
  }
  arduino.digitalWrite(redPin2, red);
  arduino.digitalWrite(greenPin2, green);
  arduino.digitalWrite(bluePin2, blue);  
}
void setColor3(int red, int green, int blue)
{
  if(common_cathode==1) {
    red = 255-red;
    green = 255-green;
    blue = 255-blue;
  }
  arduino.digitalWrite(redPin3, red);
  arduino.digitalWrite(greenPin3, green);
  arduino.digitalWrite(bluePin3, blue);  
}