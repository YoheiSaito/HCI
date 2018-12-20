
// import about audio
import ddf.minim.analysis.*;
import ddf.minim.*;

import gab.opencv.*;
import processing.video.*;
import java.awt.*;

AudioTool audiotool;



Capture video;
OpenCV opencv;

PImage hair, hige;
Rectangle[] faces;
float angle = 0;

void setup() {
  size(640, 480);
  video = new Capture(this, width/2, height/2);
  opencv = new OpenCV(this, width/2, height/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  hair = loadImage("hair.png");
  hige = loadImage("hige.png");
  video.start();
  audiotool = new AudioTool(this);
}

void draw() {


  scale(2);
  if (video.available()) video.read();
  opencv.loadImage(video);
  image(video, 0, 0 );

  faces = opencv.detect();
  imageMode(CENTER);
  int flg = audiotool.flag();
  if(flg == 1){
    drawHair();
  }
  if(flg == 2){
    drawHige();
  }
  imageMode(CORNER);
}

void drawHair() {

  for (int i = 0; i < faces.length; i++) {
    pushMatrix();
    translate(faces[i].x+faces[i].width/2, faces[i].y+faces[i].height/2);
    scale(1.8);
    image(hair, 0, 0, faces[i].width, faces[i].height);
    popMatrix();
  }
}

void drawHige() {
  for (int i = 0; i < faces.length; i++) {
    pushMatrix();
    translate(faces[i].x+faces[i].width/2, faces[i].y+faces[i].height/2);
    image(hige, 0, 0+faces[i].height/3, faces[i].width, faces[i].height/2);
    popMatrix();
  }
}


// AutdioTool class

class AudioTool {
  Minim minim;
  AudioInput audioIn;
  FFT fft;
  float averageVolume = 0.0;

  // ===== constructor =====
  AudioTool(PApplet that) {
    minim = new Minim(that);
    audioIn = minim.getLineIn(Minim.MONO, 1024, 44100);
    fft = new FFT(audioIn.bufferSize(), audioIn.sampleRate());
  }

  // ===== draw FFT =====

  int flag() {
    fft.forward(audioIn.left);
    for ( int x = 150; x < 1000; x++) {
      if (fft.getBand(x) > 0.5) {
        print(x*43);
        println("Hz");        
        return 1;
      }
      for (int y=50; y < 100; y++) {
        if (fft.getBand(y) > 0.5) {
          println(y*43);
          println("Hz");
          return 2;
        }
      }
    }
    return 0;
  }
}
//552522500
//  3772900
//   240600
