# MusicLEDs
LED lights glow with respect to the Audio File Input (Frequency based)

![Music Player](https://raw.githubusercontent.com/RISC-IITBBS/MusicLEDs/master/Data/out.gif)

## REQUIREMENTS

[Processing](https://processing.org/download/)<br />
```
brew cask install processing    #sudo apt-get install processing
```
[Arduino](https://www.arduino.cc/en/Main/Software)<br />
```
brew cask install arduino       #sudo apt-get install arduino
```

## STEPS

Connect Arduino and set the COM Port in Arduino IDE.<br />
Upload the code `Firmata->StandardFirmata` available in the examples of the Arduino IDE.<br />
Install tools `minim`, `g4p`, `firmata` from processing libraries.<br />
See the port of your arduino, and set the line accordingly in 32 with baud rate.<br />
Put the audio file in this folder and name it "song.mp3".<br />
Open the file in Processing IDE and run it.<br />


## TO BE DONE

Make GUI independant of Processing.
