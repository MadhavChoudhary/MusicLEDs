
import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioPlayer jingle;
AudioInput input;
FFT fft;
int[][] colo=new int[300][3];
//AudioIn in;

void setup()
{
  size(480, 320);
   //fullScreen();
  noCursor();
 
 
  minim = new Minim(this);
  

  input = minim.getLineIn();

  fft = new FFT(input.bufferSize(), input.sampleRate());
  
 // textFont(createFont("Arial", 16));
  
 // windowName = "None";
}

void draw()
{
  background(0);
  stroke(255);

  fft.forward(input.mix);
//512 values below --> this loop is called 25 times per second
//try getting the highest value and making a shape based on that value
//maybe change color based on the size of the value?
  for(int i = 0; i < fft.specSize(); i++)
  {
    
   
     ellipse(i, 200, 7, fft.getBand(i) *10);
    // fft.getBand(i); //this is float which is very much like a double
      
   
  }
 
  // keep us informed about the window being used
 // text("The window being used is: " + windowName, 5, 20);
}