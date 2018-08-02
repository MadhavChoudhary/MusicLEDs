import g4p_controls.*;
import controlP5.*;

ControlP5 cp5;
PImage bg;

color [] colors = new color[7];

void setup(){
  
  size(1000,600);
  smooth();
  
  cp5 = new ControlP5(this);
  
  cp5.addButton("Play",1,(width/2)-30,height-50,60,20);
  cp5.addButton("Previous",1,(width/2)-90,height-50,60,20);
  cp5.addButton("Next",1,(width/2)+30,height-50,60,20);
  cp5.addSlider("Progress",0,255,0,10,height-20,width-20,10);
  bg = loadImage("background3.jpg");
}

void draw(){
  background(255);
  
  image(bg,0,0,width,height);
}
