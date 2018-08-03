import g4p_controls.*;
import cc.arduino.*;
import org.firmata.*;
import ddf.minim.*;  
import ddf.minim.analysis.*;
import processing.serial.*;

//Gloabal Classes
PImage bg;
GSlider bar;
GSlider vol;
GImageToggleButton play,mute;
GImageToggleButton songs[];
GImageButton prev,next,add;
Minim minim;
AudioPlayer song;
FFT fft;
AudioMetaData meta;

//Global Variables
boolean songSet;
String [] filepath;
int length;
int num_songs=5;
int w=1000;
int h=600;
int barX=w/8;
int barRad=10;
int barHeight=barRad*3;
int barY=h-barRad*7;
int barWidth=3*w/4;

int volX=7*w/8;
int volRad=7;
int volHeight=volRad*3;
int volY=3*h/4-10;
int volWidth=w/8;
  
int playSize=48;
int playX=w/2-playSize/2;
int playY=barY-playSize;
int muteX=volX+volWidth/2-18;
int muteY=volY+volWidth/2+20;
int prevX=playX-50;
int prevY=playY+5;
int nextX=playX+50;

int num;

void visualfft(){
    stroke(100);
    strokeWeight(4);
    strokeJoin(ROUND);
    // frequency   
    for(int i = 0; i < 0+fft.specSize(); i++){    
      //drawing 
      line(i+width/4, height-140, i+width/4, height-140-fft.getBand(i)*2);
    }
}

void fileSelected(File selection){
  filepath[num] = selection.getAbsolutePath();
  songs[num]=new GImageToggleButton(this,barX+num*200,height-barY+200*(num)%4,"icons/album.png",2,1);
  println(filepath[num]);
  num++;
  
}
void setup(){
  
  size(1000,600);
  G4P.setCursor(CROSS);
  num=0;
  
  String[] files;
  filepath=new String[num_songs];
  songs=new GImageToggleButton[num_songs];
  minim=new Minim(this);
  
  bar=new GSlider(this,barX,barY,barWidth,barHeight,barRad);
  vol=new GSlider(this,volX,volY,volWidth,volHeight,volRad);
  vol.setRotation(4.72,GControlMode.CENTER);
  
  play=new GImageToggleButton(this,playX,playY,"icons/playpause.png",2,1);
  mute=new GImageToggleButton(this,muteX,muteY,"icons/mute.png",2,1);
  
  files = new String[] { 
    "icons/prev.png"
  };
  prev=new GImageButton(this,prevX,prevY,files);
  files = new String[] { 
    "icons/next.png"
  };
  next=new GImageButton(this,nextX,prevY,files);
  files = new String[] { 
    "icons/add.png"
  };
  add=new GImageButton(this,width/16-20,muteY,files);
  
  smooth();
  
  bg=loadImage("icons/background4.jpg");
  
}

void draw(){
  
  if(songSet){
    fft=new FFT(song.bufferSize(), song.sampleRate());
    fft.forward(song.mix);
  }
  background(255);
  image(bg,0,0,width,height);
  bar.setLocalColorScheme(1); //6-blue
  bar.setPrecision(5);
  if(songSet){
    bar.setValue(float(song.position())/meta.length());
    //song.setVolume(vol.getValueF());
    visualfft();
  }
}

void handleButtonEvents(GImageButton button, GEvent event) {
  if(button == add){
    selectInput("Select a file to process:", "fileSelected");
  }
  else if (button == prev)
    println("Prev");
  else if (button == next)
    println("Next");
    
}

public void handleSliderEvents(GValueControl slider, GEvent event) { 
  if (slider == bar){
    if(mouseX>barX && mouseX<barX+barWidth && mouseY>barY && mouseY<barY+barHeight) 
      song.cue(int(length*bar.getValueF()));
  }
}

public void handleToggleButtonEvents(GImageToggleButton button, GEvent event) { 
  if(button == play){
    if(button.getState()==0) song.pause();
    else song.play();
  }
  else if(button == mute){
    if(button.getState()==1) song.mute();
    else song.unmute();
  }
  for(int i=0;i<num;i++){
    if(button==songs[i] && button.getState()==1){
      if(songSet){
        button.setState(0);
      }
      else{
        song = minim.loadFile(filepath[i]);
        songSet=true;
        meta=song.getMetaData();
        length=meta.length();
      }
      break;
    }
  }
}

//void stop()
//{
//    for (int i = 0; i <= 13; i++) arduino.digitalWrite(i,arduino.HIGH);
//    song.close();  
//    minim.stop();
//    super.stop();
//}
//void setColor1(int red, int green, int blue)
//{
//  if(common_cathode==1) {
//    red = 255-red;
//    green = 255-green;
//    blue = 255-blue;
//  }
//  arduino.digitalWrite(redPin1, red);
//  arduino.digitalWrite(greenPin1, green);
//  arduino.digitalWrite(bluePin1, blue);  
//}
//void setColor2(int red, int green, int blue)
//{
//  if(common_cathode==1) {
//    red = 255-red;
//    green = 255-green;
//    blue = 255-blue;
//  }
//  arduino.digitalWrite(redPin2, red);
//  arduino.digitalWrite(greenPin2, green);
//  arduino.digitalWrite(bluePin2, blue);  
//}
//void setColor3(int red, int green, int blue)
//{
//  if(common_cathode==1) {
//    red = 255-red;
//    green = 255-green;
//    blue = 255-blue;
//  }
//  arduino.digitalWrite(redPin3, red);
//  arduino.digitalWrite(greenPin3, green);
//  arduino.digitalWrite(bluePin3, blue);  
//}
