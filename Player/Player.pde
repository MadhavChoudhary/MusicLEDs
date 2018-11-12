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
GLabel labels[];
GImageButton prev,next,add;
Minim minim;
AudioPlayer song;
FFT fft;
AudioMetaData meta;

//Global Variables
int songSet;
String [] filepath;
int length;
int num_songs=10;
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
boolean flag;

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
Arduino arduino;

void visualfft(){
    stroke(100);
    strokeWeight(4);
    strokeJoin(ROUND);
    // frequency   
    for(int i = 0; i < 0+fft.specSize(); i++){    
      //drawing 
      line(i+width/4, height-140, i+width/4, height-140-fft.getBand(i)*2);
      
      //processing
    //  if(i%100==0) text(fft.getBand(i), i, height*4/5+20);
    //  if(i==200) {
    //    if(fft.getBand(i)>2) {
    //      setColor1(0,255,255);
    //      setColor3(0,255,255);
    //    }
    //    else if(fft.getBand(i)>1) {
    //      setColor1(255,0,255);
    //      setColor3(255,0,255);
    //    } else {
    //      setColor1(255,255,255);
    //      setColor3(255,255,255);
    //    }
    //  }
    //  if(i==50) {
    //    if(fft.getBand(i)>5) {
    //      color_id = (color_id+1)%4;
    //    } else if(fft.getBand(i)>3) {
    //      if(color_id==0) setColor2(255,255,0);
    //      else if(color_id==1) setColor2(0,255,0);
    //      else if(color_id==2) setColor2(255,0,0);
    //      else setColor2(0,255,255);
    //    } 
    //    else {
    //      setColor2(255,255,255);
    //    }
    //  } 
    }
}

void fileSelected(File selection){
  filepath[num] = selection.getAbsolutePath();
  songs[num]=new GImageToggleButton(this,barX+25+num*150-750*floor(num/5),height-barY+150*(num)%4+150*floor(num/5),"icons/album.png",2,1);
  num++;
  
}
void setup(){
  
  size(1000,600);
  G4P.setCursor(CROSS);
  num=0;
  
 // arduino = new Arduino(this, "/dev/cu.usbmodem14101", 57600);
  //for (int i = 0; i <= 13; i++) arduino.pinMode(i, Arduino.OUTPUT);
  //for (int i = 0; i <= 13; i++) arduino.digitalWrite(i,arduino.HIGH);
  
  String[] files;
  filepath=new String[num_songs];
  songs=new GImageToggleButton[num_songs];
  labels=new GLabel[num_songs];
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
  songSet=-1;
  
}

void draw(){
  background(255);
  image(bg,0,0,width,height);
  bar.setLocalColorScheme(1); //6-blue
  bar.setPrecision(5);
  
  if(songSet!=-1){
    fft=new FFT(song.bufferSize(), song.sampleRate());
    fft.forward(song.mix);
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
  else{
    flag=false;
    for(int i=0;i<num;i++){
      if(button==songs[i] && button.getState()==1){
        println(i);
        println(button.getState());
        if(songSet!=-1 && songSet!=i){
          play.setState(0);
          song.close();
          songs[songSet].setState(0);
          songSet=-1;
        }
        song = minim.loadFile(filepath[i]);
        songSet=i;
        flag=true;
        meta=song.getMetaData();
        length=meta.length();
  
        //println(barX+i*150);
        labels[i]=new GLabel(this,barX+25+i*150-750*floor(i/5),height+80-barY+150*(i)%4+150*floor(i/5),100,100);
        labels[i].setText(meta.title()+"\n"+meta.album());
        break;
      }
    }
    if(!flag){
      song.close();
      songSet=-1;
    }
  }
}

void stop()
{
    for (int i = 0; i <= 13; i++) arduino.digitalWrite(i,arduino.HIGH);
    song.close();  
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
