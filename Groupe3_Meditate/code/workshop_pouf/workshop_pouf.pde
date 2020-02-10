

import processing.serial.*;  //importer librairie

PicoSensors pico;    //initialiser la picoboard
Serial port;  

import processing.sound.*;   //importer librairie

SoundFile sound1;    //initialiser les fonctions pour les sons
SoundFile sound2;



ArrayList<Particle> particles = new ArrayList<Particle>();    //classe des particules
int particleNum = 5000;     //choisir le nombres de particules




float magnetRadius = 100;
float rippleRadius = 0;
float equatorRadius = 4000;
float domeRadius = 450;              //initialisation de toutes les variables

float noiseOndulation =2000;
float noiseVariation = 1000;
float noiseInterval = 250;
float noiseResistance = 1000;
float opacity=100;

int maxTrembleTime = 20;
int particleSpiral = 0;

Boolean ripple = false;
Boolean vortex = false;
Boolean inverted = false;
Boolean falling = false;
Boolean rotating = false;
Boolean innerCircle = false;
Boolean outerCircle = false;
Boolean initializing = false;

ArrayList<PVector> emitters = new ArrayList<PVector>();


import oscP5.*;    //librairie
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;    //initialisation osc + ses variables en dessous

float ax, ay, az;
float axprev;
float atarget;
float acurrent;
boolean starting = false;

void setup() {
  //size(2000, 1000, P2D);
  fullScreen(P2D);      //mettre en pleine écran
  oscP5 = new OscP5(this,7400);
  sound1=new SoundFile(this,"fond.wav");    //mettre les sons dans les variables
    sound2=new SoundFile(this,"vent.wav");
    sound1.loop();    //répéter les sons
    sound2.loop();
 
  myRemoteLocation = new NetAddress("127.0.0.1",12000);   //adresse pour le osc
  
  println(Serial.list() );             //picoboard
  String picoPort = Serial.list()[0];
  port = new Serial(this, picoPort, 38400); 
  pico = new PicoSensors(port);


  for(int i=0; i<particleNum; i++) {
    particles.add(new Particle(domeRadius * cos(0) + width/2, domeRadius * sin(0) + height/2, random(0.5, 2), random(0.05, 0.1), i));
  }
  colorMode(HSB, 360, 100, 100);
  
  for (Particle p : particles) {
    falling = false;
    p.stopped = false;
    p.pos.x = random(width);
    p.pos.y = random(height);
  }
}


void draw() {
  sound1.amp(0.6);  //gérer l'amplitude du son
  
 
  if (starting==true){     //lorsque starting est vraie on lance l'onde de choc
    
    ripple = true;
    rippleRadius = 10;
  starting=false;      //starting redevient faux pour pouvoir être réactivé
  
  }
   if ( (ax>axprev*1.1) || (ax<axprev*0.9)  ) {   //si le téléphone (OSC) renvois une valeur trop grande ou trop petite par rapport a son ancien état = starting true
    if (frameCount>100) {
      println("valeurs différentes");
      starting =true;
    }
  }
  //ax = axtarget; 
  axprev = ax;
  
   pico.update();

  float mapzer = map(pico.getB(),1000,50,0,4000);   //les valeur d'ondulation du noise en fonction de la pression sur l'une des boules
  
println(mapzer);
noiseOndulation=mapzer;

println(particleNum);
if (mapzer<100){opacity=100;}else{opacity=map(mapzer,100,4000,40,-2);};  //les trainées en fonction de la même boules

 float amplitude = map(mapzer,100,4000,1,0);    //son du vent en fonction de la même boule  
  sound2.amp(amplitude);       
  /* --------Single particle-------- */
  //background(0);
  /* --------Tracing-------- */
  fill(0,opacity);
  noStroke();
  rect(0,0,width,height);
  
  for(PVector e : emitters) {
    particles.add(new Particle(e.x, e.y, random(2, 5), random(0.1, 0.5), frameCount));
  }
  
  for (Particle p : particles) {
    
    if(p.flowing) p.flow();
    
   
    
   
    
    if(millis()%((p.index*5)+1)==0 && !p.start) {
      p.start = true;
    }
    
    

   
    
    if(ripple) {
      p.ripple();
    } else {
      p.rippling = false;
      p.ripplingSize = 0;
    }
    
    
    
    if(initializing) {
      //p.emit();
      p.run();
      initializing = false;
    }
    p.run();
  }
  
  if(ripple) {
    rippleRadius += 5;
    if(rippleRadius > domeRadius) ripple = false;
  }
}




void keyPressed() {
 
  
  if(key == 'w' || key == 'W') {    //pour pouvoir travailler avec l'onde de choc sans l'osc
   ripple = true;
   rippleRadius = 10;
  } 
  
}

class Particle {    // créer les particules
  
  PVector pos;
  PVector vel;
  PVector acc;
  float size;
  float maxforce;   
  float maxspeed;
  float angle;
  float angleIncrement;
  
  Boolean flowing = true;
  Boolean repelling = false;
  Boolean attracting = false;
  Boolean stopped = false;
  Boolean rippling = false;
  
  Boolean start = false;
 
  
  float ripplingSize = 0;
  float distanceFromCenter = 0;
  float startDistance = domeRadius;
  int trembleTime = 0;
  int index;
  
  PVector previous = new PVector();
  PVector vortexCenter;
  float radius = random(50, 200);
  float dec = (200 - radius) * 0.000014;
  //float tilt = random(-60,60);
  float turnVelocity;
  

  Particle (float _x, float _y, float _maxspeed, float _maxforce, int _index) {
    pos = new PVector(_x, _y);
    vel = new PVector(0,0);
    acc = new PVector(0,0);
    size = 2;
    angle = 0;
    angleIncrement = random(0.005, 0.05);
    maxforce = _maxforce;
    maxspeed = _maxspeed;
    index = _index;
  }
  
  //calculer l'angle de noise
  float getNoiseAngle(float _x, float _y) {
    return map(noise(_x/noiseOndulation + noiseVariation, _y/noiseOndulation + noiseVariation, frameCount/noiseInterval + noiseVariation), 0, 1, 0, TWO_PI*2);
  }
  
   //accelération pour suivre le flow
  void flow() {
    float noiseAngle = getNoiseAngle(pos.x, pos.y);
    PVector desired = new PVector(cos(noiseAngle)*noiseResistance, sin(noiseAngle)*noiseResistance);
    desired.mult(maxspeed);
    PVector steer = PVector.sub(desired, vel);
    steer.limit(maxforce); 
    applyForce(steer);  
  }
 

   
  void ripple() {     //fonction onde de choc
    float distance = abs(dist(pos.x, pos.y, width/2, height/2) - rippleRadius);
    
    if (distance < 50) { 
      rippling = true;
      ripplingSize = map(distance, 50, 0, 0, 27);
      repelling = true;
      magnet(width/2, height/2, rippleRadius + 25, 10);
    } else {
      rippling = false;
      repelling = false;
    }   
  }

  //faire que les particules aillent dans la bonne direction
  void follow(PVector _desired) {
    _desired.normalize();
    _desired.mult(maxspeed);
    PVector steer = PVector.sub(_desired, vel);
    steer.limit(maxforce); 
    applyForce(steer);  
  }

      
  void magnet(float _x, float _y, float _radius, float _strength) {
    float magnetRadius = _radius;
    PVector target = new PVector(_x, _y);
    PVector force = PVector.sub(target, pos);
    float distance = force.mag();

    if(distance < magnetRadius) {
      flowing = false;
      distance = constrain(distance, 5.0, 25.0);
      force.normalize();
      float strength = 0.00;
      if(repelling) strength = (500 + _strength) / (distance * distance * -1);
      if(attracting) strength = (50 + _strength) / (distance * distance);
      force.mult(strength);        
      applyForce(force);
    } else {
      flowing = true;
    }
  }

 
  void applyForce(PVector _force) {
    acc.add(_force);
  }

  
  void update() {
    if(!stopped) {
      if(inverted) acc.mult(-1);
      vel.add(acc);
      vel.limit(maxspeed);
      pos.add(vel);
      acc.mult(0);  
    }
  }

  //affiche les particules sur l'écran 
  void display() {   
    /* --------Color fill-------- */
    //fill(map(pos.x, width/2 - domeRadius, width/2 + domeRadius, 250, 360), 100, 100);    
    /* --------White fill-------- */
    fill(255);
    float mapzer2 = map(pico.getA(),1000,50,10,-1);
    stroke(255);
    strokeWeight(1.5);
    ellipse(pos.x, pos.y, size+ripplingSize+mapzer2, size+ripplingSize+mapzer2);    
    
  }

 
  void position() {
    pos.x = width/2 - ((domeRadius - 15) * cos(random(TWO_PI)));
    pos.y = height/2 - ((domeRadius - 15) * sin(random(TWO_PI)));
    
    float distance = dist(pos.x, pos.y, width/2, height/2);
    if (distance > domeRadius) position();
  }

  
  void borders() {
    float distance = dist(pos.x, pos.y, width/2, height/2);    
    if (distance > domeRadius) {
      if(falling) {
        stopped = true;
      } else {
       
        float theta = atan2(pos.y - height/2, pos.x - width/2);
        pos.x = (width/2 + (domeRadius * cos(theta + PI)));
        pos.y = (height/2 + (domeRadius * sin(theta + PI)));       
      }
    }
  }
  
  
  void run() {
    update();
    borders();
    display();
  }
}
void oscEvent(OscMessage theOscMessage) { //récupère les valeurs du téléphone via osc
  
 
  if(theOscMessage.checkAddrPattern("/accelerometer/raw/x")==true) {
   
    if(theOscMessage.checkTypetag("f")) {

       ax = theOscMessage.get(0).floatValue();  
      println("### reçu une donnée X de l'accéléromètre : " + ax);
      return;
    }  
  } 
  
    if(theOscMessage.checkAddrPattern("/accelerometer/raw/y")==true) {
    
    if(theOscMessage.checkTypetag("f")) {
      
       ay = theOscMessage.get(0).floatValue();  
      println("### reçu une donnée Y de l'accéléromètre : " + ay);
      return;
    }  
  } 
  
    if(theOscMessage.checkAddrPattern("/accelerometer/raw/z")==true) {
  
    if(theOscMessage.checkTypetag("f")) {
      
       az = theOscMessage.get(0).floatValue();  
      println("### reçu une donnée Z de l'accéléromètre : " + az);
      return;
    }  
  } 
  

}
