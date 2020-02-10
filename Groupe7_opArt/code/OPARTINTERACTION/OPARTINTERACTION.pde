import de.voidplus.leapmotion.*;
import processing.sound.*;

ArrayList<Soft_line> slines = new ArrayList<Soft_line>() ;

float nlines = 100; //number of lines

LowPass lowPass;
SoundFile sound;

float amp=0.0;
float freq=5000;


LeapMotion leap;
Node leftNode ;
Node rightNode ;

void setup() {

  fullScreen(P3D);
  pixelDensity(1);
  leap = new LeapMotion(this);
  // smooth();
  noFill();

  for (int i = 0; i < nlines; i++) {
    float y = map(i, 0, nlines, 10, height*2);
    slines.add(new Soft_line(0, y, width*2, y, 100));
  }
  leftNode = new Node(width/2, height/2);
  rightNode = new Node(width/2, height/2);

  sound = new SoundFile(this, "fond.wav");
  sound.play(); //play
  sound.loop();
  // Create a noise generator and a bandpass filter

  lowPass = new LowPass(this);

  sound.play(0.5);
  lowPass.process(sound, 5000);
  lowPass.freq(freq);
}

void draw() {
  background(0);
  text("fps : " + frameRate, 25, 30);
  stroke(255);


  for (Hand hand : leap.getHands ()) {
    //hand.draw();
    println(hand.isLeft());
    println(hand.isRight());
    if (hand.isLeft()) {
      PVector p = hand.getPosition();
      leftNode.setLocation( p.x, p.y);
    }
    if (hand.isRight()) {
      PVector p = hand.getPosition();
      rightNode.setLocation( p.x, p.y);
    }
  }


  for (int i = 0; i < nlines; i++) {
    Soft_line l = slines.get(i);
    l.run();
    rightNode.attract(l.nodes);
    leftNode.attract(l.nodes);
  }
}

void keyPressed() {
  if (key == 'r') {
    println(key);
    slines = new ArrayList<Soft_line>() ;
    for (int i = 0; i < nlines; i++) {
      float y = map(i, 0, nlines, 10, height*2);
      slines.add(new Soft_line(0, y, width*2, y, 100));
    }
    leftNode = new Node(width/2, height/2);
    rightNode = new Node(width/2, height/2);
  }
}
