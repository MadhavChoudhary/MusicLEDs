import cc.arduino.*;
import org.firmata.*;
import ddf.minim.*;  
import ddf.minim.analysis.*;
import processing.serial.*;

Arduino arduino;

Minim minim;  
AudioPlayer song;
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

void setup() {
    size(800, 600);
    
    //arduino = new Arduino(this, "/dev/cu.usbmodem14201", 57600);
    //for (int i = 0; i <= 13; i++) arduino.pinMode(i, Arduino.OUTPUT);
    //for (int i = 0; i <= 13; i++) arduino.digitalWrite(i,arduino.HIGH);

    minim = new Minim(this);  
    song = minim.loadFile("song.mp3");
    song.play();
    fft = new FFT(song.bufferSize(), song.sampleRate());

}
 
void draw() {    
    background(#151515);

    fft.forward(song.mix);

    strokeWeight(1.3);
    stroke(#FFF700);

      // frequency
      pushMatrix();
      translate(250, 0);   
      //for(int i = 0; i < 0+fft.specSize(); i++) {
      //  line(i, height*4/5, i, height*4/5 - fft.getBand(i)*4); 
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
      //}  
    popMatrix();
    
    stroke(#FF0000);
  
    //waveform
    for(int i = 250; i < song.left.size() - 1; i++) {
      line(i, 50 + song.left.get(i)*50, i+1, 50 + song.left.get(i+1)*50);
      line(i, 150 + song.right.get(i)*50, i+1, 150 + song.right.get(i+1)*50);
      line(i, 250 + song.mix.get(i)*50, i+1, 250 + song.mix.get(i+1)*50);
    }
  
    noStroke();
    fill(#111111);
    rect(0, 0, 250, height);
  
    textSize(24);
    fill(#046700);
    text("left amplitude", 10, 50); 
    text("right amplitude", 10, 150); 
    text("mixed amplitude", 10, 250); 
    text("frequency", 10, height*4/5); 
}

void stop()
{
    for (int i = 0; i <= 13; i++) arduino.digitalWrite(i,arduino.HIGH);
    song.close();  
    minim.stop();
    super.stop();
}
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
