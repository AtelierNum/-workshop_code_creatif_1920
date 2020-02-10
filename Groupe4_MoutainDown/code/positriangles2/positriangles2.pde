/**
 * This is a simple example of how to use the Keystone library.
 *
 * To use this example in the real world, you need a projector
 * and a surface you want to project your Processing sketch onto.
 *
 * Simply drag the corners of the CornerPinSurface so that they
 * match the physical surface's corners. The result will be an
 * undistorted projection, regardless of projector position or 
 * orientation.
 *
 * You can also create more than one Surface object, and project
 * onto multiple flat surfaces using a single projector.
 *
 * This extra flexbility can comes at the sacrifice of more or 
 * less pixel resolution, depending on your projector and how
 * many surfaces you want to map. 
 */

// Gestion du son
import ddf.minim.*;
Minim minim;
AudioPlayer player;

// Gestion du mapping
import deadpixel.keystone.*;

// Gestion de la carte picoboard
import processing.serial.*;
PicoSensors pico;
Serial port;  // Create object from Serial class


//Création des différences surfaces
Keystone ks;
//GRANDES PYRAMIDES
CornerPinSurface surface1;
CornerPinSurface surface2;
CornerPinSurface surface3;
CornerPinSurface surface4;
CornerPinSurface surface5;
CornerPinSurface surface6;
//PYRAMIDES MOYENNES
CornerPinSurface surface7;
CornerPinSurface surface8;
CornerPinSurface surface9;
CornerPinSurface surface10;
CornerPinSurface surface11;
CornerPinSurface surface12;
CornerPinSurface surface13;
CornerPinSurface surface14;
CornerPinSurface surface15;
CornerPinSurface surface16;
//PETITES PYRAMIDES
CornerPinSurface surface17;
CornerPinSurface surface18;
CornerPinSurface surface19;
CornerPinSurface surface20;
CornerPinSurface surface21;
CornerPinSurface surface22;
CornerPinSurface surface23;
CornerPinSurface surface24;
CornerPinSurface surface25;
CornerPinSurface surface26;
CornerPinSurface surface27;
CornerPinSurface surface28;
CornerPinSurface surface29;
CornerPinSurface surface30;
//SURFACE ENTIÈRE
CornerPinSurface surface31;
//CARRÉS VIDES
CornerPinSurface surface32;
CornerPinSurface surface33;
CornerPinSurface surface34;
CornerPinSurface surface35;
CornerPinSurface surface36;
CornerPinSurface surface37;
CornerPinSurface surface38;
CornerPinSurface surface39;
CornerPinSurface surface40;
CornerPinSurface surface41;
CornerPinSurface surface42;
CornerPinSurface surface43;
CornerPinSurface surface44;
CornerPinSurface surface45;
CornerPinSurface surface46;
CornerPinSurface surface47;



//CRÉATION DES BUFFERS (ex : offscreen1 lié à surface 1)
PGraphics offscreen1;
PGraphics offscreen2;
PGraphics offscreen3;
PGraphics offscreen4;
PGraphics offscreen5;
PGraphics offscreen6;
PGraphics offscreen7;
PGraphics offscreen8;
PGraphics offscreen9;
PGraphics offscreen10;
PGraphics offscreen11;
PGraphics offscreen12;
PGraphics offscreen13;
PGraphics offscreen14;
PGraphics offscreen15;
PGraphics offscreen16;
PGraphics offscreen17;
PGraphics offscreen18;
PGraphics offscreen19;
PGraphics offscreen20;
PGraphics offscreen21;
PGraphics offscreen22;
PGraphics offscreen23;
PGraphics offscreen24;
PGraphics offscreen25;
PGraphics offscreen26;
PGraphics offscreen27;
PGraphics offscreen28;
PGraphics offscreen29;
PGraphics offscreen30;
PGraphics offscreen31;
PGraphics offscreen32;
PGraphics offscreen33;
PGraphics offscreen34;
PGraphics offscreen35;
PGraphics offscreen36;
PGraphics offscreen37;
PGraphics offscreen38;
PGraphics offscreen39;
PGraphics offscreen40;
PGraphics offscreen41;
PGraphics offscreen42;
PGraphics offscreen43;
PGraphics offscreen44;
PGraphics offscreen45;
PGraphics offscreen46;
PGraphics offscreen47;




int x =0;
int y=150;

//Variable pour modifier couleur
int aa = 0;

//Variable de couleur
int a = color(255, 20, 0);
int b = color(255, 220, 0);
int c = color(255, 110, 0);
float r, t, tt;

//Pour tourbillon
float boundary;
int p = 0;
int d = 0;
float e = -(width*0.05);

//Pour NEIGE
star neuerStern;
ArrayList<star> starArray = new ArrayList<star>();
float h2;//=height/2
float w2;//=width/2
float d2;//=diagonal/2
int numberOfStars = 2000;//nombre d'étoile
int newStars =50; 
float angle;

//ANIMATION FLEUR
float num, pathR, pathG, pathB;
boolean doOnce = true;  // valeur de vérité vrai/faux
float t1 = 0.0;
float d1 = 1.0;
float a1 = 0.0;


void settings() {
  size(825, 825, P3D);
}

//Pour Neige 
class star {
  float x, y, speed, d, age, sizeIncr;
  int wachsen;
  star() {
    x = random(width);
    y = random(height);
    speed = random(0.2, 5);
    wachsen= int(random(0, 2));
    if (wachsen==1)d = 0;
    else {
      d= random(0.2, 3);
    }
    age=0;
    sizeIncr= random(2, 5);
  }
  void render() {
    age++;
    if (age<200) {
      if (wachsen==1) {
        d+=sizeIncr;
        if (d>3||d<-3) d=3;
      } else {
        if (d>3||d<-3) d=3;
        d= d+0.2-0.6*noise(x, y, frameCount);
      }
    } else {
      if (d>3||d<-3) d=3;
    }

    ellipse(x, y, d*(map(noise(x, y, 0.001*frameCount), 0, 1, 6, 10)), d*(map(noise(x, y, 0.001*frameCount), 0, 1, 0.2, 1.5)));
    //taille des flocons 
  }

  void move() { // déplacement des flocons de neige 
    x =x-map(X, 0, width, -0.005*speed, 0.005*speed)*(w2-x); 
    y =y-map(Y, 0, height, -0.005*speed, 0.005*speed)*(h2-y);
  }
}


void setup() {

  noCursor();

  //NEIGE  //position 
  w2=width/2;
  h2= height/2;
  d2 = dist(0, 0, w2, h2);
  neuerStern= new star();
  frameRate(900);

  //Synchronisation son/animation avec le temps
  minim = new Minim(this);
  player = minim.loadFile("moonlight.mp3");

  ks = new Keystone(this);

  println(Serial.list() );
  String picoPort = Serial.list()[3];  //examine le pico
  port = new Serial(this, picoPort, 38400); 
  pico = new PicoSensors(port);

  //Taille de chaque surface
  surface1 = ks.createCornerPinSurface(225, 225, 20);
  surface2 = ks.createCornerPinSurface(225, 225, 20);
  surface3 = ks.createCornerPinSurface(225, 225, 20);
  surface4 = ks.createCornerPinSurface(225, 225, 20);
  surface5 = ks.createCornerPinSurface(225, 225, 20);
  surface6 = ks.createCornerPinSurface(225, 225, 20);
  surface7 = ks.createCornerPinSurface(150, 150, 20);
  surface8 = ks.createCornerPinSurface(150, 150, 20);
  surface9 = ks.createCornerPinSurface(150, 150, 20);
  surface10 = ks.createCornerPinSurface(150, 150, 20);
  surface11 = ks.createCornerPinSurface(150, 150, 20);
  surface12 = ks.createCornerPinSurface(150, 150, 20);
  surface13 = ks.createCornerPinSurface(150, 150, 20);
  surface14 = ks.createCornerPinSurface(150, 150, 20);
  surface15 = ks.createCornerPinSurface(150, 150, 20);
  surface16 = ks.createCornerPinSurface(75, 75, 20);
  surface17 = ks.createCornerPinSurface(75, 75, 20);
  surface18 = ks.createCornerPinSurface(75, 75, 20);
  surface19 = ks.createCornerPinSurface(75, 75, 20);
  surface20 = ks.createCornerPinSurface(75, 75, 20);
  surface21 = ks.createCornerPinSurface(75, 75, 20);
  surface22 = ks.createCornerPinSurface(75, 75, 20);
  surface23 = ks.createCornerPinSurface(75, 75, 20);
  surface24 = ks.createCornerPinSurface(75, 75, 20);
  surface25 = ks.createCornerPinSurface(75, 75, 20);
  surface26 = ks.createCornerPinSurface(75, 75, 20);
  surface27 = ks.createCornerPinSurface(75, 75, 20);
  surface28 = ks.createCornerPinSurface(75, 75, 20);
  surface29 = ks.createCornerPinSurface(75, 75, 20);
  surface30 = ks.createCornerPinSurface(75, 75, 20);
  surface31 = ks.createCornerPinSurface(825, 835, 20);
  surface32 = ks.createCornerPinSurface(75, 75, 20);
  surface33 = ks.createCornerPinSurface(75, 75, 20);
  surface34 = ks.createCornerPinSurface(75, 75, 20);
  surface35 = ks.createCornerPinSurface(75, 75, 20);
  surface36 = ks.createCornerPinSurface(75, 75, 20);
  surface37 = ks.createCornerPinSurface(75, 75, 20);
  surface38 = ks.createCornerPinSurface(75, 75, 20);
  surface39 = ks.createCornerPinSurface(75, 75, 20);
  surface40 = ks.createCornerPinSurface(75, 75, 20);
  surface41 = ks.createCornerPinSurface(75, 75, 20);
  surface42 = ks.createCornerPinSurface(75, 75, 20);
  surface43 = ks.createCornerPinSurface(75, 75, 20);
  surface44 = ks.createCornerPinSurface(75, 75, 20);
  surface45 = ks.createCornerPinSurface(75, 75, 20);
  surface46 = ks.createCornerPinSurface(75, 75, 20);
  surface47 = ks.createCornerPinSurface(75, 75, 20);

  //Taille de chaque calque (c'est la même taille que chaque surface)
  offscreen1 = createGraphics(225, 225, P3D);
  offscreen2 = createGraphics(225, 225, P3D);
  offscreen3 = createGraphics(225, 225, P3D);
  offscreen4 = createGraphics(225, 225, P3D);
  offscreen5 = createGraphics(225, 225, P3D);
  offscreen6 = createGraphics(225, 225, P3D);
  offscreen7 = createGraphics(150, 150, P3D);
  offscreen8 = createGraphics(150, 150, P3D);
  offscreen9 = createGraphics(150, 150, P3D);
  offscreen10 = createGraphics(150, 150, P3D);
  offscreen11 = createGraphics(150, 150, P3D);
  offscreen12 = createGraphics(150, 150, P3D);
  offscreen13 = createGraphics(150, 150, P3D);
  offscreen14 = createGraphics(150, 150, P3D);
  offscreen15 = createGraphics(150, 150, P3D);
  offscreen16 = createGraphics(75, 75, P3D);
  offscreen17 = createGraphics(75, 75, P3D);
  offscreen18 = createGraphics(75, 75, P3D);
  offscreen19 = createGraphics(75, 75, P3D);
  offscreen20 = createGraphics(75, 75, P3D);
  offscreen21 = createGraphics(75, 75, P3D);
  offscreen22 = createGraphics(75, 75, P3D);
  offscreen23 = createGraphics(75, 75, P3D);
  offscreen24 = createGraphics(75, 75, P3D);
  offscreen25 = createGraphics(75, 75, P3D);
  offscreen26 = createGraphics(75, 75, P3D);
  offscreen27 = createGraphics(75, 75, P3D);
  offscreen28 = createGraphics(75, 75, P3D);
  offscreen29 = createGraphics(75, 75, P3D);
  offscreen30 = createGraphics(75, 75, P3D);
  offscreen31 = createGraphics(825, 825, P3D);
  offscreen32 = createGraphics(75, 75, P3D);
  offscreen33 = createGraphics(75, 75, P3D);
  offscreen34 = createGraphics(75, 75, P3D);
  offscreen35 = createGraphics(75, 75, P3D);
  offscreen36 = createGraphics(75, 75, P3D);
  offscreen37 = createGraphics(75, 75, P3D);
  offscreen38 = createGraphics(75, 75, P3D);
  offscreen39 = createGraphics(75, 75, P3D);
  offscreen40 = createGraphics(75, 75, P3D);
  offscreen41 = createGraphics(75, 75, P3D);
  offscreen42 = createGraphics(75, 75, P3D);
  offscreen43 = createGraphics(75, 75, P3D);
  offscreen44 = createGraphics(75, 75, P3D);
  offscreen45 = createGraphics(75, 75, P3D);
  offscreen46 = createGraphics(75, 75, P3D);
  offscreen47 = createGraphics(75, 75, P3D);
}


void draw() {
  
  //t total = 1/10è musique
  t = map(player.position(), 0, 0.1*player.length(), 0, 1);

  //en fonction de la musique, variable d'hauteur
  r = map(player.position(), 0, player.length(), 0, width*10);
  
  //tt total = musique entière
  tt = map(player.position(), 0, player.length(), 0, 1);

  //Variable pour picoboard
  pico.update();
  aa = int(map(pico.getA(), 1023, 500, 0, 825));   // couleurs
  p = int(map(pico.getSlider(), 0, 6000, 0, 825));  // formes

  //1ère animation que l'on met sur telle ou telle surface (déclinaisons 1/2/3)
  animation11(offscreen1);
  animation11(offscreen2);
  animation12(offscreen3);
  animation12(offscreen4);
  animation13(offscreen5);
  animation13(offscreen6);
  animation11(offscreen7);
  animation12(offscreen8);
  animation11(offscreen9);
  animation13(offscreen10);
  animation11(offscreen11);
  animation12(offscreen12);
  animation13(offscreen13);
  animation11(offscreen14);
  animation12(offscreen15);
  animation12(offscreen16);
  animation11(offscreen17);
  animation13(offscreen18);
  animation13(offscreen19);
  animation11(offscreen20);
  animation11(offscreen21);
  animation13(offscreen22);
  animation12(offscreen23);
  animation11(offscreen24);
  animation11(offscreen25);
  animation12(offscreen26);
  animation13(offscreen27);
  animation12(offscreen28);
  animation11(offscreen29);
  animation11(offscreen30);

  //2ème animation que l'on met sur tell ou telle surface (déclinaisons 1/2/3)
  animation21(offscreen1);
  animation21(offscreen2);
  animation22(offscreen3);
  animation22(offscreen4);
  animation23(offscreen5);
  animation23(offscreen6);
  animation21(offscreen7);
  animation22(offscreen8);
  animation21(offscreen9);
  animation23(offscreen10);
  animation21(offscreen11);
  animation22(offscreen12);
  animation23(offscreen13);
  animation21(offscreen14);
  animation22(offscreen15);
  animation22(offscreen16);
  animation21(offscreen17);
  animation23(offscreen18);
  animation23(offscreen19);
  animation21(offscreen20);
  animation21(offscreen21);
  animation23(offscreen22);
  animation22(offscreen23);
  animation21(offscreen24);
  animation21(offscreen25);
  animation22(offscreen26);
  animation23(offscreen27);
  animation22(offscreen28);
  animation21(offscreen29);
  animation21(offscreen30);

  //animation carrés (déclinaisons 1/2/3)
  animation41(offscreen32);
  animation41(offscreen33);
  animation41(offscreen34);
  animation41(offscreen35);
  animation41(offscreen36);
  animation42(offscreen37);
  animation42(offscreen38);
  animation42(offscreen39);
  animation42(offscreen40);
  animation42(offscreen41);
  animation43(offscreen42);
  animation43(offscreen43);
  animation43(offscreen44);
  animation43(offscreen45);
  animation43(offscreen46);
  animation43(offscreen47);


  animation51(offscreen1);
  animation51(offscreen2);
  animation52(offscreen3);
  animation52(offscreen4);
  animation53(offscreen5);
  animation53(offscreen6);
  animation51(offscreen7);
  animation52(offscreen8);
  animation51(offscreen9);
  animation53(offscreen10);
  animation51(offscreen11);
  animation52(offscreen12);
  animation53(offscreen13);
  animation51(offscreen14);
  animation52(offscreen15);
  animation52(offscreen16);
  animation51(offscreen17);
  animation53(offscreen18);
  animation53(offscreen19);
  animation51(offscreen20);
  animation51(offscreen21);
  animation53(offscreen22);
  animation52(offscreen23);
  animation51(offscreen24);
  animation51(offscreen25);
  animation52(offscreen26);
  animation53(offscreen27);
  animation52(offscreen28);
  animation51(offscreen29);
  animation51(offscreen30);

  animation60(offscreen1);
  animation60(offscreen2);
  animation60(offscreen3);
  animation60(offscreen4);
  animation60(offscreen5);
  animation60(offscreen6);
  animation60(offscreen7);
  animation60(offscreen8);
  animation60(offscreen9);
  animation60(offscreen10);
  animation60(offscreen11);
  animation60(offscreen12);
  animation60(offscreen13);
  animation60(offscreen14);
  animation60(offscreen15);
  animation60(offscreen16);
  animation60(offscreen17);
  animation60(offscreen18);
  animation60(offscreen19);
  animation60(offscreen20);
  animation60(offscreen21);
  animation60(offscreen22);
  animation60(offscreen23);
  animation60(offscreen24);
  animation60(offscreen25);
  animation60(offscreen26);
  animation60(offscreen27);
  animation60(offscreen28);
  animation60(offscreen29);
  animation60(offscreen30);

  animation70(offscreen1);
  animation70(offscreen2);
  animation70(offscreen3);
  animation70(offscreen4);
  animation70(offscreen5);
  animation70(offscreen6);

  animation80(offscreen1);
  animation80(offscreen2);
  animation80(offscreen3);
  animation80(offscreen4);
  animation80(offscreen5);
  animation80(offscreen6);
  animation80(offscreen7);
  animation80(offscreen8);
  animation80(offscreen9);
  animation80(offscreen10);
  animation80(offscreen11);
  animation80(offscreen12);
  animation80(offscreen13);
  animation80(offscreen14);
  animation80(offscreen15);
  animation80(offscreen16);
  animation80(offscreen17);
  animation80(offscreen18);
  animation80(offscreen19);
  animation80(offscreen20);
  animation80(offscreen21);
  animation80(offscreen22);
  animation80(offscreen23);
  animation80(offscreen24);
  animation80(offscreen25);
  animation80(offscreen26);
  animation80(offscreen27);
  animation80(offscreen28);
  animation80(offscreen29);
  animation80(offscreen30);

  //animation traits
  animation90(offscreen31);


  background(0);

  // chaque offscreen lié à chaque surface
  surface1.render(offscreen1);
  surface2.render(offscreen2);
  surface3.render(offscreen3);
  surface4.render(offscreen4);
  surface5.render(offscreen5);
  surface6.render(offscreen6);
  surface7.render(offscreen7);
  surface8.render(offscreen8);
  surface9.render(offscreen9);
  surface10.render(offscreen10);
  surface11.render(offscreen11);
  surface12.render(offscreen12);
  surface13.render(offscreen13);
  surface14.render(offscreen14);
  surface15.render(offscreen15);
  surface16.render(offscreen16);
  surface17.render(offscreen17);
  surface18.render(offscreen18);
  surface19.render(offscreen19);
  surface20.render(offscreen20);
  surface21.render(offscreen21);
  surface22.render(offscreen22);
  surface23.render(offscreen23);
  surface24.render(offscreen24);
  surface25.render(offscreen25);
  surface26.render(offscreen26);
  surface27.render(offscreen27);
  surface28.render(offscreen28);
  surface29.render(offscreen29);
  surface30.render(offscreen30);
  surface31.render(offscreen31);
  surface32.render(offscreen32);
  surface33.render(offscreen33);
  surface34.render(offscreen34);
  surface35.render(offscreen35);
  surface36.render(offscreen36);
  surface37.render(offscreen37);
  surface38.render(offscreen38);
  surface39.render(offscreen39);
  surface40.render(offscreen40);
  surface41.render(offscreen41);
  surface42.render(offscreen42);
  surface43.render(offscreen43);
  surface44.render(offscreen44);
  surface45.render(offscreen45);
  surface46.render(offscreen46);
  surface47.render(offscreen47);


  x++;
  if (x >= 800) {
    x = 0 ;
  }
}


//ANIMATION GLOBALE DECLINAISON 1 : carrés qui augmentent (rouge)
void animation11(PGraphics pg) {

  pg.beginDraw();
  pg.background(0);
  pg.push();
  pg.stroke(a+aa);
  pg.noFill();
  pg.strokeWeight(2);
  pg.rectMode(CENTER);
  pg.translate(pg.width*0.5, pg.height*0.5);
  if (t>0) {
    pg.rect(d, e, r*0.01, r*0.01, p, p, p, p);  //barre du bas
  }
  if (t>0.025) {
    pg.rect(d, e, r *0.025, r*0.025, p, p, p, p);  //barre du bas
  }  
  if (t>0.05) {
    pg.rect(d, e, r *0.05, r*0.05, p, p, p, p);  //barre du bas
  }
  if (t>0.075) {
    pg.rect(d, e, r *0.075, r*0.075, p, p, p, p);  //barre du bas
  }
  if (t>0.1) {
    pg.rect(d, e, r *0.1, r*0.1, p, p, p, p);  //barre du bas
  }
  if (t>0.125) {
    pg.rect(d, e, r *0.125, r*0.125, p, p, p, p);  //barre du bas
  }
  if (t>0.15) {
    pg.rect(d, e, r *0.15, r*0.15, p, p, p, p);  //barre du bas
  }
  if (t>0.175) {
    pg.rect(d, e, r *0.175, r*0.175, p, p, p, p);  //barre du bas
  }
  if (t>0.2) {
    pg.rect(d, e, r *0.2, r*0.2, p, p, p, p);  //barre du bas
  }
  if (t>0.225) {
    pg.rect(d, e, r *0.225, r*0.225, p, p, p, p);  //barre du bas
  }
  if (t>0.250) {
    pg.rect(d, e, r *0.250, r*0.250, p, p, p, p);  //barre du bas
  }
  if (t>0.275) {
    pg.rect(d, e, r *0.275, r*0.275, p, p, p, p);  //barre du bas
  }
  if (t>0.3) {
    pg.rect(d, e, r *0.3, r*0.3, p, p, p, p);  //barre du bas
  }
  if (t>0.325) {
    pg.rect(d, e, r *0.325, r*0.325, p, p, p, p);  //barre du bas
  }
  if (t>0.35) {
    pg.rect(d, e, r *0.35, r*0.35, p, p, p, p);  //barre du bas
  }
  if (t>0.375) {
    pg.rect(d, e, r *0.375, r*0.375, p, p, p, p);  //barre du bas
  }     
  if (t>0.4) {
    pg.rect(d, e, r *0.4, r*0.4, p, p, p, p);  //barre du bas
  }
  if (t>0.425) {
    pg.rect(d, e, r *0.425, r*0.425, p, p, p, p);  //barre du bas
  }
  if (t>0.45) {
    pg.rect(d, e, r *0.45, r*0.45, p, p, p, p);  //barre du bas
  }
  if (t>0.475) {
    pg.rect(d, e, r *0.475, r*0.475, p, p, p, p);  //barre du bas
  }    
  if (t>0.5) {
    pg.rect(d, e, r *0.5, r*0.5, p, p, p, p);  //barre du bas
  }
  if (t>0.525) {
    pg.rect(d, e, r *0.525, r*0.525, p, p, p, p);  //barre du bas
  }
  if (t>0.55) {
    pg.rect(d, e, r *0.55, r*0.55, p, p, p, p);  //barre du bas
  }
  if (t>0.575) {
    pg.rect(d, e, r *0.575, r*0.575, p, p, p, p);  //barre du bas
  }    
  if (t>0.6) {
    pg.rect(d, e, r *0.6, r*0.6, p, p, p, p);  //barre du bas
  }
  if (t>0.625) {
    pg.rect(d, e, r *0.625, r*0.625, p, p, p, p);  //barre du bas
  }
  if (t>0.65) {
    pg.rect(d, e, r *0.65, r*0.65, p, p, p, p);  //barre du bas
  }
  if (t>0.675) {
    pg.rect(d, e, r *0.675, r*0.675, p, p, p, p);  //barre du bas
  } 
  if (t>0.7) {
    pg.rect(d, e, r *0.7, r*0.7, p, p, p, p);  //barre du bas
  }
  if (t>0.725) {
    pg.rect(d, e, r *0.725, r*0.725, p, p, p, p);  //barre du bas
  }
  if (t>0.75) {
    pg.rect(d, e, r *0.75, r*0.75, p, p, p, p);  //barre du bas
  }
  if (t>0.775) {
    pg.rect(d, e, r *0.775, r*0.775, p, p, p, p);  //barre du bas
  }
  if (t>0.8) {
    pg.rect(d, e, r *0.8, r*0.8, p, p, p, p);  //barre du bas
  }
  if (t>0.825) {
    pg.rect(d, e, r *0.825, r*0.825, p, p, p, p);  //barre du bas
  }
  if (t>0.85) {
    pg.rect(d, e, r *0.85, r*0.85, p, p, p, p);  //barre du bas
  }
  if (t>0.875) {
    pg.rect(d, e, r *0.875, r*0.875, p, p, p, p);  //barre du bas
  } 
  if (t>0.9) {
    pg.rect(d, e, r *0.9, r*0.9, p, p, p, p);  //barre du bas
  }
  if (t>0.925) {
    pg.rect(d, e, r *0.925, r*0.925, p, p, p, p);  //barre du bas
  }
  if (t>0.95) {
    pg.rect(d, e, r *0.95, r*0.95, p, p, p, p);  //barre du bas
  }
  if (t>0.975) {
    pg.rect(d, e, r *0.975, r*0.975, p, p, p, p);  //barre du bas
  }          

  //  offscreen23.line(d,e, 225, 225);
  //  offscreen23.line(225, d,e, 225);
  pg.pop();
  pg.endDraw();
}


//ANIMATION GLOBALE DECLINAISON 2 : carrés qui augmentent (orange)
void animation12(PGraphics pf) {

  pf.beginDraw();
  pf.background(0);
  pf.push();
  pf.stroke(b+aa);
  pf.noFill();
  pf.strokeWeight(2);
  pf.rectMode(CENTER);
  pf.translate(pf.width*0.5, pf.height*0.5);
  if (t>0) {
    pf.rect(d, e, r*0.01, r*0.01, p, p, p, p);  //barre du bas
  }
  if (t>0.025) {
    pf.rect(d, e, r *0.025, r*0.025, p, p, p, p);  //barre du bas
  }  
  if (t>0.05) {
    pf.rect(d, e, r *0.05, r*0.05, p, p, p, p);  //barre du bas
  }
  if (t>0.075) {
    pf.rect(d, e, r *0.075, r*0.075, p, p, p, p);  //barre du bas
  }
  if (t>0.1) {
    pf.rect(d, e, r *0.1, r*0.1, p, p, p, p);  //barre du bas
  }
  if (t>0.125) {
    pf.rect(d, e, r *0.125, r*0.125, p, p, p, p);  //barre du bas
  }
  if (t>0.15) {
    pf.rect(d, e, r *0.15, r*0.15, p, p, p, p);  //barre du bas
  }
  if (t>0.175) {
    pf.rect(d, e, r *0.175, r*0.175, p, p, p, p);  //barre du bas
  }
  if (t>0.2) {
    pf.rect(d, e, r *0.2, r*0.2, p, p, p, p);  //barre du bas
  }
  if (t>0.225) {
    pf.rect(d, e, r *0.225, r*0.225, p, p, p, p);  //barre du bas
  }
  if (t>0.250) {
    pf.rect(d, e, r *0.250, r*0.250, p, p, p, p);  //barre du bas
  }
  if (t>0.275) {
    pf.rect(d, e, r *0.275, r*0.275, p, p, p, p);  //barre du bas
  }
  if (t>0.3) {
    pf.rect(d, e, r *0.3, r*0.3, p, p, p, p);  //barre du bas
  }
  if (t>0.325) {
    pf.rect(d, e, r *0.325, r*0.325, p, p, p, p);  //barre du bas
  }
  if (t>0.35) {
    pf.rect(d, e, r *0.35, r*0.35, p, p, p, p);  //barre du bas
  }
  if (t>0.375) {
    pf.rect(d, e, r *0.375, r*0.375, p, p, p, p);  //barre du bas
  }     
  if (t>0.4) {
    pf.rect(d, e, r *0.4, r*0.4, p, p, p, p);  //barre du bas
  }
  if (t>0.425) {
    pf.rect(d, e, r *0.425, r*0.425, p, p, p, p);  //barre du bas
  }
  if (t>0.45) {
    pf.rect(d, e, r *0.45, r*0.45, p, p, p, p);  //barre du bas
  }
  if (t>0.475) {
    pf.rect(d, e, r *0.475, r*0.475, p, p, p, p);  //barre du bas
  }    
  if (t>0.5) {
    pf.rect(d, e, r *0.5, r*0.5, p, p, p, p);  //barre du bas
  }
  if (t>0.525) {
    pf.rect(d, e, r *0.525, r*0.525, p, p, p, p);  //barre du bas
  }
  if (t>0.55) {
    pf.rect(d, e, r *0.55, r*0.55, p, p, p, p);  //barre du bas
  }
  if (t>0.575) {
    pf.rect(d, e, r *0.575, r*0.575, p, p, p, p);  //barre du bas
  }    
  if (t>0.6) {
    pf.rect(d, e, r *0.6, r*0.6, p, p, p, p);  //barre du bas
  }
  if (t>0.625) {
    pf.rect(d, e, r *0.625, r*0.625, p, p, p, p);  //barre du bas
  }
  if (t>0.65) {
    pf.rect(d, e, r *0.65, r*0.65, p, p, p, p);  //barre du bas
  }
  if (t>0.675) {
    pf.rect(d, e, r *0.675, r*0.675, p, p, p, p);  //barre du bas
  } 
  if (t>0.7) {
    pf.rect(d, e, r *0.7, r*0.7, p, p, p, p);  //barre du bas
  }
  if (t>0.725) {
    pf.rect(d, e, r *0.725, r*0.725, p, p, p, p);  //barre du bas
  }
  if (t>0.75) {
    pf.rect(d, e, r *0.75, r*0.75, p, p, p, p);  //barre du bas
  }
  if (t>0.775) {
    pf.rect(d, e, r *0.775, r*0.775, p, p, p, p);  //barre du bas
  }
  if (t>0.8) {
    pf.rect(d, e, r *0.8, r*0.8, p, p, p, p);  //barre du bas
  }
  if (t>0.825) {
    pf.rect(d, e, r *0.825, r*0.825, p, p, p, p);  //barre du bas
  }
  if (t>0.85) {
    pf.rect(d, e, r *0.85, r*0.85, p, p, p, p);  //barre du bas
  }
  if (t>0.875) {
    pf.rect(d, e, r *0.875, r*0.875, p, p, p, p);  //barre du bas
  } 
  if (t>0.9) {
    pf.rect(d, e, r *0.9, r*0.9, p, p, p, p);  //barre du bas
  }
  if (t>0.925) {
    pf.rect(d, e, r *0.925, r*0.925, p, p, p, p);  //barre du bas
  }
  if (t>0.95) {
    pf.rect(d, e, r *0.95, r*0.95, p, p, p, p);  //barre du bas
  }
  if (t>0.975) {
    pf.rect(d, e, r *0.975, r*0.975, p, p, p, p);  //barre du bas
  }          

  //  offscreen23.line(d,e, 225, 225);
  //  offscreen23.line(225, d,e, 225);
  pf.pop();
  pf.endDraw();
}


//ANIMATION GLOBALE DECLINAISON 3 : carrés qui augmentent (jaune)
void animation13(PGraphics ph) {

  ph.beginDraw();
  ph.background(0);
  ph.push();
  ph.stroke(c+aa);
  ph.noFill();
  ph.strokeWeight(2);
  ph.rectMode(CENTER);
  ph.translate(ph.width*0.5, ph.height*0.5);
  if (t>0) {
    ph.rect(d, e, r*0.01, r*0.01, p, p, p, p);  //barre du bas
  }
  if (t>0.025) {
    ph.rect(d, e, r *0.025, r*0.025, p, p, p, p);  //barre du bas
  }  
  if (t>0.05) {
    ph.rect(d, e, r *0.05, r*0.05, p, p, p, p);  //barre du bas
  }
  if (t>0.075) {
    ph.rect(d, e, r *0.075, r*0.075, p, p, p, p);  //barre du bas
  }
  if (t>0.1) {
    ph.rect(d, e, r *0.1, r*0.1, p, p, p, p);  //barre du bas
  }
  if (t>0.125) {
    ph.rect(d, e, r *0.125, r*0.125, p, p, p, p);  //barre du bas
  }
  if (t>0.15) {
    ph.rect(d, e, r *0.15, r*0.15, p, p, p, p);  //barre du bas
  }
  if (t>0.175) {
    ph.rect(d, e, r *0.175, r*0.175, p, p, p, p);  //barre du bas
  }
  if (t>0.2) {
    ph.rect(d, e, r *0.2, r*0.2, p, p, p, p);  //barre du bas
  }
  if (t>0.225) {
    ph.rect(d, e, r *0.225, r*0.225, p, p, p, p);  //barre du bas
  }
  if (t>0.250) {
    ph.rect(d, e, r *0.250, r*0.250, p, p, p, p);  //barre du bas
  }
  if (t>0.275) {
    ph.rect(d, e, r *0.275, r*0.275, p, p, p, p);  //barre du bas
  }
  if (t>0.3) {
    ph.rect(d, e, r *0.3, r*0.3, p, p, p, p);  //barre du bas
  }
  if (t>0.325) {
    ph.rect(d, e, r *0.325, r*0.325, p, p, p, p);  //barre du bas
  }
  if (t>0.35) {
    ph.rect(d, e, r *0.35, r*0.35, p, p, p, p);  //barre du bas
  }
  if (t>0.375) {
    ph.rect(d, e, r *0.375, r*0.375, p, p, p, p);  //barre du bas
  }     
  if (t>0.4) {
    ph.rect(d, e, r *0.4, r*0.4, p, p, p, p);  //barre du bas
  }
  if (t>0.425) {
    ph.rect(d, e, r *0.425, r*0.425, p, p, p, p);  //barre du bas
  }
  if (t>0.45) {
    ph.rect(d, e, r *0.45, r*0.45, p, p, p, p);  //barre du bas
  }
  if (t>0.475) {
    ph.rect(d, e, r *0.475, r*0.475, p, p, p, p);  //barre du bas
  }    
  if (t>0.5) {
    ph.rect(d, e, r *0.5, r*0.5, p, p, p, p);  //barre du bas
  }
  if (t>0.525) {
    ph.rect(d, e, r *0.525, r*0.525, p, p, p, p);  //barre du bas
  }
  if (t>0.55) {
    ph.rect(d, e, r *0.55, r*0.55, p, p, p, p);  //barre du bas
  }
  if (t>0.575) {
    ph.rect(d, e, r *0.575, r*0.575, p, p, p, p);  //barre du bas
  }    
  if (t>0.6) {
    ph.rect(d, e, r *0.6, r*0.6, p, p, p, p);  //barre du bas
  }
  if (t>0.625) {
    ph.rect(d, e, r *0.625, r*0.625, p, p, p, p);  //barre du bas
  }
  if (t>0.65) {
    ph.rect(d, e, r *0.65, r*0.65, p, p, p, p);  //barre du bas
  }
  if (t>0.675) {
    ph.rect(d, e, r *0.675, r*0.675, p, p, p, p);  //barre du bas
  } 
  if (t>0.7) {
    ph.rect(d, e, r *0.7, r*0.7, p, p, p, p);  //barre du bas
  }
  if (t>0.725) {
    ph.rect(d, e, r *0.725, r*0.725, p, p, p, p);  //barre du bas
  }
  if (t>0.75) {
    ph.rect(d, e, r *0.75, r*0.75, p, p, p, p);  //barre du bas
  }
  if (t>0.775) {
    ph.rect(d, e, r *0.775, r*0.775, p, p, p, p);  //barre du bas
  }
  if (t>0.8) {
    ph.rect(d, e, r *0.8, r*0.8, p, p, p, p);  //barre du bas
  }
  if (t>0.825) {
    ph.rect(d, e, r *0.825, r*0.825, p, p, p, p);  //barre du bas
  }
  if (t>0.85) {
    ph.rect(d, e, r *0.85, r*0.85, p, p, p, p);  //barre du bas
  }
  if (t>0.875) {
    ph.rect(d, e, r *0.875, r*0.875, p, p, p, p);  //barre du bas
  } 
  if (t>0.9) {
    ph.rect(d, e, r *0.9, r*0.9, p, p, p, p);  //barre du bas
  }
  if (t>0.925) {
    ph.rect(d, e, r *0.925, r*0.925, p, p, p, p);  //barre du bas
  }
  if (t>0.95) {
    ph.rect(d, e, r *0.95, r*0.95, p, p, p, p);  //barre du bas
  }
  if (t>0.975) {
    ph.rect(d, e, r *0.975, r*0.975, p, p, p, p);  //barre du bas
  }          

  //  offscreen23.line(d,e, 225, 225);
  //  offscreen23.line(225, d,e, 225);
  ph.pop();
  ph.endDraw();
}

//ANIMATION 2 DÉCLINAISON 1 : triangle rythme de la musique (rouge)
void animation21(PGraphics qa) {

  qa.beginDraw();
  qa.push();
  qa.translate(qa.width*0.5, qa.height*0.5);
  qa.noStroke();
  if (tt> 0.078 && tt<= 0.081 ) {
    qa.fill(a+aa, 255);
    qa.triangle(d, e, width, -height, height, width);
  } 

  if (tt> 0.081 && tt<= 0.086 ) {
    qa.fill(a+aa, 236);
    qa.triangle(d, e, -width, -height, width, -height);
  }   

  if (tt> 0.086 && tt<= 0.089 ) {
    qa.fill(a+aa, 217);
    qa.triangle(d, e, -width, height, -width, -height);
  }

  if (tt> 0.089 && tt<= 0.094 ) {
    qa.fill(a+aa, 198);
    qa.triangle(d, e, -width, height, width, height);
  }
  if (tt> 0.094 && tt<= 0.097 ) {
    qa.fill(a+aa, 179);
    qa.triangle(d, e, width, -height, width, height);
  } 

  if (tt> 0.097 && tt<= 0.100 ) {
    qa.fill(a+aa, 160);
    qa.triangle(d, e, -width, -height, width, -height);
  }   

  if (tt> 0.100 && tt<= 0.103 ) {
    qa.fill(a+aa, 141);
    qa.triangle(d, e, -width, height, -width, -height);
  }

  if (tt> 0.103 && tt<= 0.106 ) {
    qa.fill(a+aa, 122);
    qa.triangle(d, e, -width, height, width, height);
  }

  if (tt> 0.106 && tt<= 0.109 ) {
    qa.fill(a+aa, 103);
    qa.triangle(d, e, width, -height, height, width);
  }
  if (tt> 0.109 && tt<= 0.111 ) {
    qa.fill(a+aa, 84);
    qa.triangle(d, e, -width, -height, width, -height);
  } 

  if (tt> 0.111 && tt<= 0.113 ) {
    qa.fill(a+aa, 65);
    qa.triangle(d, e, -width, height, -width, -height);
  }   

  if (tt> 0.113 && tt<= 0.115 ) {
    qa.fill(a+aa, 46);
    qa.triangle(d, e, -width, height, width, height);
  }

  if (tt> 0.115 && tt<= 0.117 ) {
    qa.fill(a+aa, 27);
    qa.triangle(d, e, width, -height, width, height);
  }

  if (tt> 0.117 && tt<= 0.119 ) {
    qa.fill(a+aa, 4);
    qa.triangle(d, e, -width, -height, width, -height);
  }
  qa.pop();
  qa.endDraw();
}


//ANIMATION 2 DÉCLINAISON 2 : triangle rythme de la musique (orange)
void animation22(PGraphics qb) {

  qb.beginDraw();
  qb.push();
  qb.translate(qb.width*0.5, qb.height*0.5);
  qb.noStroke();
  if (tt> 0.078 && tt<= 0.081 ) {
    qb.fill(b+aa, 255);
    qb.triangle(d, e, -width, height, width, height);
  } 

  if (tt> 0.081 && tt<= 0.086 ) {
    qb.fill(b+aa, 236);
    qb.triangle(d, e, width, -height, height, width);
  }   

  if (tt> 0.086 && tt<= 0.089 ) {
    qb.fill(b+aa, 217);
    qb.triangle(d, e, -width, -height, width, -height);
  }

  if (tt> 0.089 && tt<= 0.094 ) {
    qb.fill(b+aa, 198);
    qb.triangle(d, e, -width, height, -width, -height);
  }
  if (tt> 0.094 && tt<= 0.097 ) {
    qb.fill(b+aa, 179);
    qb.triangle(d, e, -width, height, width, height);
  } 

  if (tt> 0.097 && tt<= 0.100 ) {
    qb.fill(b+aa, 160);
    qb.triangle(d, e, width, -height, width, height);
  }   

  if (tt> 0.100 && tt<= 0.103 ) {
    qb.fill(b+aa, 141);
    qb.triangle(d, e, -width, -height, width, -height);
  }

  if (tt> 0.103 && tt<= 0.106 ) {
    qb.fill(b+aa, 122);
    qb.triangle(d, e, -width, height, -width, -height);
  }

  if (tt> 0.106 && tt<= 0.109 ) {
    qb.fill(b+aa, 103);
    qb.triangle(d, e, -width, height, width, height);
  }
  if (tt> 0.109 && tt<= 0.111 ) {
    qb.fill(b+aa, 84);
    qb.triangle(d, e, width, -height, width, height);
  } 

  if (tt> 0.111 && tt<= 0.113 ) {
    qb.fill(b+aa, 65);
    qb.triangle(d, e, -width, -height, width, -height);
  }   

  if (tt> 0.113 && tt<= 0.115 ) {
    qb.fill(b+aa, 46);
    qb.triangle(d, e, -width, height, -width, -height);
    qb.triangle(d, e, -width, height, width, height);
  }

  if (tt> 0.115 && tt<= 0.117 ) {
    qb.fill(b+aa, 27);
    qb.triangle(d, e, -width, height, width, height);
  }

  if (tt> 0.117 && tt<= 0.119 ) {
    qb.fill(b+aa, 4);
    qb.triangle(d, e, width, -height, width, height);
  }
  qb.pop();
  qb.endDraw();
}


//ANIMATION 2 DÉCLINAISON 2 : triangle rythme de la musique (jaune)
void animation23(PGraphics qc) {

  qc.beginDraw();
  qc.push();
  qc.translate(qc.width*0.5, qc.height*0.5);
  qc.noStroke();
  if (tt> 0.078 && tt<= 0.081 ) {
    qc.fill(c+aa, 255);
    qc.triangle(d, e, -width, -height, width, -height);
  } 

  if (tt> 0.081 && tt<= 0.086 ) {
    qc.fill(c+aa, 236);
    qc.triangle(d, e, -width, height, -width, -height);
  }   

  if (tt> 0.086 && tt<= 0.089 ) {
    qc.fill(c+aa, 217);
    qc.triangle(d, e, -width, height, width, height);
  }

  if (tt> 0.089 && tt<= 0.094 ) {
    qc.fill(c+aa, 198);
    qc.triangle(d, e, width, -height, width, height);
  }
  if (tt> 0.094 && tt<= 0.097 ) {
    qc.fill(c+aa, 179);
    qc.triangle(d, e, -width, -height, width, -height);
  } 

  if (tt> 0.097 && tt<= 0.100 ) {
    qc.fill(c+aa, 160);
    qc.triangle(d, e, -width, height, -width, -height);
  }   

  if (tt> 0.100 && tt<= 0.103 ) {
    qc.fill(c+aa, 141);
    qc.triangle(d, e, -width, height, width, height);
  }

  if (tt> 0.103 && tt<= 0.106 ) {
    qc.fill(c+aa, 122);
    qc.triangle(d, e, width, -height, height, width);
  }

  if (tt> 0.106 && tt<= 0.109 ) {
    qc.fill(c+aa, 103);
    qc.triangle(d, e, -width, -height, width, -height);
  }
  if (tt> 0.109 && tt<= 0.111 ) {
    qc.fill(c+aa, 84);
    qc.triangle(d, e, -width, height, -width, -height);
  } 

  if (tt> 0.111 && tt<= 0.113 ) {
    qc.fill(c+aa, 65);
    qc.triangle(d, e, -width, height, width, height);
  }   

  if (tt> 0.113 && tt<= 0.115 ) {
    qc.fill(c+aa, 46);
    qc.triangle(d, e, width, -height, width, height);
  }

  if (tt> 0.115 && tt<= 0.117 ) {
    qc.fill(c+aa, 27);
    qc.triangle(d, e, -width, -height, width, -height);
  }

  if (tt> 0.117 && tt<= 0.119 ) {
    qc.fill(c+aa, 4);
    qc.triangle(d, e, -width, height, -height, -width);
  }
  qc.pop();
  qc.endDraw();
}

//ANIMATION 3 DÉCLINAISON 1 : carrés sur endroit sans pyramide (rouge)
void animation41(PGraphics ae) {
  ae.beginDraw();
  ae.push();
  ae.fill(a+aa);
  ae.background(0);
  if (tt>0.147 && tt<=0.149) {
    ae.background(a+aa, 255);
  }
  if (tt>0.153 && tt<=0.155) {
    ae.background(a+aa, 210);
  }
  if (tt>0.155 && tt<=0.159) {
    ae.background(a+aa, 195);
  }
  if (tt>0.161 && tt<=0.163) {
    ae.background(a+aa, 150);
  }
  if (tt>0.163 && tt<=0.165) {
    ae.background(a+aa, 135);
  }
  if (tt>0.169 && tt<=0.171) {
    ae.background(a+aa, 90);
  }
  if (tt>0.173 && tt<=0.175) {
    ae.background(a+aa, 60);
  }
  if (tt>0.177 && tt<=0.179) {
    ae.background(a+aa, 30);
  }
  if (tt>0.181 && tt<=0.183) {
    ae.background(a+aa, 60);
  }
  if (tt>0.183 && tt<=0.185) {
    ae.background(a+aa, 90);
  }
  if (tt>0.185 && tt<=0.189) {
    ae.background(a+aa, 135);
  }
  if (tt>0.191 && tt<=0.193) {
    ae.background(a+aa, 150);
  }
  if (tt>0.199 && tt<=0.201) {
    ae.background(a+aa, 195);
  }
  if (tt>0.203 && tt<=0.205) {
    ae.background(a+aa, 210);
  }
  if (tt>0.207 && tt<=0.209) {
    ae.background(a+aa, 255);
  }
  if (tt>0.209) {
    ae.clear();
  }

  ae.pop();
  ae.endDraw();
}

//ANIMATION 3 DÉCLINAISON 2 : carrés sur endroit sans pyramide (orange)
void animation42(PGraphics af) {
  af.beginDraw();
  af.push();
  af.fill(b+aa);
  af.background(0);
  if (tt>0.149 && tt<=0.151) {
    af.background(b+aa, 240);
  }
  if (tt>0.153 && tt<=0.155) {
    af.background(b+aa, 210);
  }
  if (tt>0.157 && tt<=0.159) {
    af.background(b+aa, 180);
  }
  if (tt>0.165 && tt<=0.167) {
    af.background(b+aa, 120);
  }
  if (tt>0.169 && tt<=0.171) {
    af.background(b+aa, 90);
  }
  if (tt>0.171 && tt<=0.173) {
    af.background(b+aa, 75);
  }
  if (tt>0.179 && tt<=0.181) {
    af.background(b+aa, 90);
  }
  if (tt>0.183 && tt<=0.185) {
    af.background(b+aa, 120);
  }
  if (tt>0.187 && tt<=0.189) {
    af.background(b+aa, 180);
  }
  if (tt>0.195 && tt<=0.197) {
    af.background(b+aa, 210);
  }
  if (tt>0.199 && tt<=0.201) {
    af.background(b+aa, 230);
  }
  if (tt>0.201 && tt<=0.203) {
    af.background(b+aa, 255);
  }

  if (tt>0.399 && tt<=0.404) {
    af.background(b+aa, 240);
  }
  if (tt>0.403 && tt<=0.405) {
    af.background(b+aa, 210);
  }
  if (tt>0.407 && tt<=0.409) {
    af.background(b+aa, 180);
  }
  if (tt>0.415 && tt<=0.417) {
    af.background(b+aa, 120);
  }
  if (tt>0.419 && tt<=0.421) {
    af.background(b+aa, 90);
  }
  if (tt>0.421 && tt<=0.423) {
    af.background(b+aa, 75);
  }
  if (tt>0.429 && tt<=0.431) {
    af.background(b+aa, 90);
  }
  if (tt>0.4319) {
    af.clear();
  }
  af.pop();
  af.endDraw();
}

//ANIMATION 3 DÉCLINAISON 3 : carrés sur endroit sans pyramide (jaune)
void animation43(PGraphics ag) {
  ag.beginDraw();
  ag.push();
  ag.fill(c+aa);
  ag.background(0);
  if (tt>0.151 && tt<=0.153) {
    ag.background(c+aa, 225);
  }
  if (tt>0.159 && tt<=0.161) {
    ag.background(c+aa, 165);
  }
  if (tt>0.163 && tt<=0.165) {
    ag.background(c+aa, 135);
  }
  if (tt>0.167 && tt<=0.169) {
    ag.background(c+aa, 105);
  }
  if (tt>0.173 && tt<=0.175) {
    ag.background(c+aa, 60);
  }
  if (tt>0.179 && tt<=0.181) {
    ag.background(c+aa, 15);
  }
  if (tt>0.181 && tt<=0.153) {
    ag.background(c+aa, 15);
  }
  if (tt>0.189 && tt<=0.191) {
    ag.background(c+aa, 60);
  }
  if (tt>0.193 && tt<=0.195) {
    ag.background(c+aa, 105);
  }
  if (tt>0.197 && tt<=0.199) {
    ag.background(c+aa, 135);
  }
  if (tt>0.203 && tt<=0.205) {
    ag.background(c+aa, 165);
  }
  if (tt>0.209 && tt<=0.211) {
    ag.background(c+aa, 225);
  }

  if (tt>0.351 && tt<=0.153) {
    ag.background(c+aa, 225);
  }
  if (tt>0.379 && tt<=0.381) {
    ag.background(c+aa, 165);
  }
  if (tt>0.383 && tt<=0.385) {
    ag.background(c+aa, 135);
  }
  if (tt>0.387 && tt<=0.389) {
    ag.background(c+aa, 105);
  }
  if (tt>0.393 && tt<=0.395) {
    ag.background(c+aa, 60);
  }
  if (tt>0.399 && tt<=0.401) {
    ag.background(c+aa, 15);
  }
  if (tt>0.401) {
    ag.clear();
  }

  ag.pop();
  ag.endDraw();
}

//ANIMATION 4 : neige (1ère appariton)
void animation51(PGraphics be) {
  be.beginDraw();
  be.push();
  be.fill(c+aa);
  be.translate(0, -0.5*height);
  be.rectMode(CENTER);

  if (tt>0.622 && tt<0.747) {
    be.background(0);
    be.translate(0, -0.5*height);
    be.fill(0, map(dist(X, Y, w2, h2), 0, d2, 255, -10));
    be.rect(12, 8, width, height);
    be.fill(255);
    be.translate(0.01*width, 1*height);
    be.fill(0, map(dist(X, Y, w2, h2), 0, d2, 255, -10));
    be.rect(12, 8, width, height);
    be.fill(255);

    neuerStern.render();
    for (int i = 0; i<newStars; i++) {   // star init
      starArray.add(new star());
    }


    for (int i = 0; i<starArray.size(); i++) {
      if (starArray.get(i).x<0||starArray.get(i).x>width||starArray.get(i).y<0||starArray.get(i).y>height) starArray.remove(i);
      starArray.get(i).move();
      starArray.get(i).render();
    }
    if (starArray.size()>numberOfStars) {
      for (int i = 0; i<newStars; i++) {
        starArray.remove(i);
      }
    }
  }  
  be.pop();
  be.endDraw();
}

//ANIMATION 4 : neige (2ème appariton)
void animation52(PGraphics bf) {
  bf.beginDraw();
  bf.push();
  bf.fill(c+aa);
  bf.translate(0, -0.5*height);
  bf.rectMode(CENTER);

  if (tt>0.664 && tt<0.747) {
    bf.background(0);
    bf.translate(0, -0.5*height);
    bf.fill(0, map(dist(X, Y, w2, h2), 0, d2, 255, -10));
    bf.rect(12, 8, width, height);
    bf.fill(255);
    bf.translate(0.01*width, 1*height);
    bf.fill(0, map(dist(X, Y, w2, h2), 0, d2, 255, -10));
    bf.rect(12, 8, width, height);
    bf.fill(255);

    neuerStern.render();
    for (int i = 0; i<newStars; i++) {   // star init
      starArray.add(new star());
    }


    for (int i = 0; i<starArray.size(); i++) {
      if (starArray.get(i).x<0||starArray.get(i).x>width||starArray.get(i).y<0||starArray.get(i).y>height) starArray.remove(i);
      starArray.get(i).move();
      starArray.get(i).render();
    }
    if (starArray.size()>numberOfStars) {
      for (int i = 0; i<newStars; i++) {
        starArray.remove(i);
      }
    }
  }  
  bf.pop();
  bf.endDraw();
}

//ANIMATION 4 : neige (3ème appariton)
void animation53(PGraphics bg) {
  bg.beginDraw();
  bg.push();
  bg.fill(c+aa);
  bg.translate(0, -0.5*height);
  bg.rectMode(CENTER);

  if (tt>0.690 && tt<0.747) {
    bg.background(0);
    bg.translate(0, -0.5*height);
    bg.fill(0, map(dist(X, Y, w2, h2), 0, d2, 255, -10));
    bg.rect(12, 8, width, height);
    bg.fill(255);
    bg.translate(0.01*width, 1*height);
    bg.fill(0, map(dist(X, Y, w2, h2), 0, d2, 255, -10));
    bg.rect(12, 8, width, height);
    bg.fill(255);

    neuerStern.render();
    for (int i = 0; i<newStars; i++) {   // star init
      starArray.add(new star());
    }


    for (int i = 0; i<starArray.size(); i++) {
      if (starArray.get(i).x<0||starArray.get(i).x>width||starArray.get(i).y<0||starArray.get(i).y>height) starArray.remove(i);
      starArray.get(i).move();
      starArray.get(i).render();
    }
    if (starArray.size()>numberOfStars) {
      for (int i = 0; i<newStars; i++) {
        starArray.remove(i);
      }
    }
  }  
  bg.pop();
  bg.endDraw();
}

//ANIMATION LIGNE SUR TOUTE LA SURFACE
void animation30(PGraphics za) {

  za.beginDraw();
  za.push();
  za.fill(a);
  za.strokeWeight(3);
  za.stroke(a);
  za.background(0);
  if (tt> 0.3 && tt < 0.385) { //en fonction du temps 
    za.line(0, 0.05 * height, width, 0.05*height); //hauteur changée à chaque fois
  }
  if (tt> 0.3025 && tt <= 0.385) {
    za.line(0, 0.1 * height, width, 0.1*height);
  }
  if (tt> 0.3050 && tt <= 0.38) {
    za.line(0, 0.15 * height, width, 0.15*height);
  }
  if (tt> 0.3075 && tt <= 0.38) {
    za.line(0, 0.2 * height, width, 0.2*height);
  }
  if (tt> 0.31 && tt <= 0.375) {
    za.line(0, 0.25 * height, width, 0.25*height);
  }
  if (tt> 0.3125 && tt <= 0.3875) {
    za.line(0, 0.3 * height, width, 0.3*height);
  }
  if (tt> 0.3150 && tt <= 0.385) {
    za.line(0, 0.35 * height, width, 0.35*height);
  }
  if (tt> 0.3175 && tt <= 0.3825) {
    za.line(0, 0.4* height, width, 0.4*height);
  }
  if (tt> 0.3250 && tt <= 0.38) {
    za.line(0, 0.45 * height, width, 0.45*height);
  }
  if (tt> 0.3275 && tt <= 0.375) {
    za.line(0, 0.5 * height, width, 0.5*height);
  }
  if (tt> 0.3300 && tt <= 0.3725) {
    za.line(0, 0.55 * height, width, 0.55*height);
  }
  if (tt> 0.3325 && tt <= 0.37) {
    za.line(0, 0.6 * height, width, 0.6*height);
  }
  if (tt> 0.3350 && tt <= 0.3675) {
    za.line(0, 0.65 * height, width, 0.65*height);
  }
  if (tt> 0.3375 && tt <= 0.365) {
    za.line(0, 0.7 * height, width, 0.7*height);
  }
  if (tt> 0.34 && tt <= 0.3625) {
    za.line(0, 0.75 * height, width, 0.75*height);
  }
  if (tt> 0.3425 && tt <= 0.36) {
    za.line(0, 0.8 * height, width, 0.8*height);
  }
  if (tt> 0.3450 && tt <= 0.3575) {
    za.line(0, 0.85 * height, width, 0.85*height);
  }
  if (tt> 0.3475 && tt <= 0.3550) {
    za.line(0, 0.9* height, width, 0.9*height);
  }
  if (tt> 0.350 && tt <= 0.3525) {
    za.line(0, 0.95 * height, width, 0.95*height);
  }
  za.pop();
  za.endDraw();
}

//DERNIERE ANIMATION : 3x3 triangles, 3premiers rouges, puis orange puis jaune
void animation60(PGraphics zr) {
  zr.beginDraw();
  zr.push();
  //  zr.background(0);
  zr.strokeWeight(3);
  zr.noFill();
  zr.stroke(a+aa);
  zr.strokeWeight(3);
  zr.translate(zr.width/2, zr.height/2);
  if (tt>0.805 && tt < 0.870) {
    zr.background(0);// entre 1min 28 et 1min 40
    zr.rotate(frameCount / 200.0);
    polygon(0, 0, zr.width*0.2, 3, zr);  // Triangle
  }

  if (tt>0.810&& tt < 0.873) {
    // zr.pushMatrix(); 
    zr.rotate(frameCount / 200.0);
    zr.rotate(PI/4);
    polygon(0, 0, zr.width*0.2, 3, zr);  // Triangle
    //zr.popMatrix();
  }

  if (tt>0.815&& tt < 0.876) {
    //zr.pushMatrix();
    zr.rotate(2*PI/4);
    zr.rotate(frameCount / 200.0);
    polygon(0, 0, zr.width*0.2, 3, zr);  // Triangle
    //zr.popMatrix();
  }

  zr.stroke(b+aa);
  if (tt>0.821&& tt < 0.879) {
    //zr.pushMatrix();
    zr.rotate(frameCount / 200.0);
    polygon(0, 0, zr.width*0.4, 3, zr);  // Triangle
    //zr.popMatrix();
  }

  if (tt>0.827&& tt < 0.882) {
    //zr.pushMatrix();
    zr.rotate(PI/4);
    zr.rotate(frameCount / 200.0);
    polygon(0, 0, zr.width*0.4, 3, zr);  // Triangle
    // zr.popMatrix();
  }

  if (tt>0.833&& tt < 0.885) {
    // zr.pushMatrix();
    zr.rotate(2*PI/4);
    zr.rotate(frameCount / 200.0);
    polygon(0, 0, zr.width*0.4, 3, zr);  // Triangle
    //zr.popMatrix();
  }


  zr.stroke(c+aa);
  if (tt>0.839&& tt < 0.888) {
    // zr.pushMatrix();
    zr.rotate(frameCount / 200.0);
    polygon(0, 0, zr.width*0.60, 3, zr);  // Triangle
    // zr.popMatrix();
  }
  if (tt>0.845&& tt < 0.891) {
    //zr.pushMatrix();
    zr.rotate(PI/4);
    zr.rotate(frameCount / 200.0);
    polygon(0, 0, zr.width*0.6, 3, zr);  // Triangle
    //zr.popMatrix();
  }

  if (tt>0.851 && tt> 0.861) { 
    //zr.pushMatrix();
    zr.rotate(2*PI/4);
    zr.rotate(frameCount / 200.0);
    polygon(0, 0, zr.width*0.6, 3, zr);  // Triangle
    // zr.popMatrix();
  }
  zr.pop();
  zr.endDraw();
}


//ANIMATION FLEUR
void animation70(PGraphics zf) { //zf direction nulle 
  zf.beginDraw();
  zf.push();
  zf.translate(0, 0);

  if (tt>0.3795638 && tt<0.46922907) {
    zf.background(0);
    zf.fill(255, 0, 0, 20);
    zf.rect(0, 0, zf.width*0.5, zf.height*0.5);
    zf.translate(zf.width/2, zf.height/2);
    for (int i = 0; i < 360; i+=2) {
      float angle = sin(i+num)*50;
      float x = sin(radians(i))*(150+angle);
      float y = cos(radians(i))*(150+angle);
      float x2 = sin(radians(i))*(100+angle);
      float y2 = cos(radians(i))*(100+angle);

      zf.stroke(a);
      zf.noFill();

      zf.ellipse(x, y, angle/5, angle/5);
      zf.ellipse(y2, x2, 5, 5);
      zf.line(x, y, x2, y2);
    }
    num+=0.01;
  }
  zf.pop();
  zf.endDraw();
}

//ANIMATION TOURBILLON
void animation80(PGraphics zm) {
  boundary = sqrt(2) * zm.width;
  zm.beginDraw();
  zm.pushMatrix();
  zm.translate(zm.width*0.5, zm.height*0.5);

  if (tt>0.27568874 && tt < 0.33275938) {
    zm.background(0);
    //zm.pushMatrix();
    float thisAngle = a1;
    float thisTime = t1;  

    zm.beginShape(TRIANGLE_STRIP);
    float side = -1;

    while (d1 < boundary * 0.5) {
      float x = sin(thisAngle);
      float y = cos(thisAngle);
      PVector p = new PVector(x, y);
      p.mult(d1 + d1 * sin(thisTime * PI / 2.0) * 0.125);

      float x2 = sin(thisAngle + PI / 3.0);
      float y2 = cos(thisAngle + PI / 3.0);
      PVector p2 = new PVector(x2, y2);
      p2.mult(map(d, 0, boundary, 1, 80));
      p2.add(p);

      zm.fill(+aa, 255);  
      zm.strokeWeight(5);
      zm.stroke(c+aa, 255);   

      zm.vertex(p.x, p.y);
      zm.vertex(p2.x, p2.y);

      thisAngle += map(d1, 0, boundary, PI / 20, PI / 220);
      d1 *= 1.008;

      thisTime += 0.15 + d1 * 0.0006;
    }
    zm.endShape();
    //zm.popMatrix();
    a1 += PI / 64.0;
    d1 = 1;
    t1 += 1 / 8.0;
  }
  zm.popMatrix();
  zm.endDraw();
}



void keyPressed() {
  if ( player.isPlaying() )
  {
    player.pause();
  }
  // if the player is at the end of the file,
  // we have to rewind it before telling it to play again
  else if ( player.position() == player.length() )
  {
    player.rewind();
    player.play();
  } else
  {
    player.play();
  }
  switch(key) {
  case 'c':
    // enter/leave calibration mode, where surfaces can be warped 
    // and moved
    ks.toggleCalibration();
    break;

  case 'l':
    // loads the saved layout
    ks.load();
    break;

  case 's':
    // saves the layout
    ks.save();
    break;
  }
}

void animation90(PGraphics qa) {

  qa.beginDraw();
  qa.noFill();
  qa.strokeWeight(5);
  qa.stroke(c);
  if (tt>0.437 && tt<0.522) {
    qa.background(0);
    qa.line(0, 0.05*qa.height, qa.width, 0.05*qa.height);  //barre du bas
  }  
  if (tt>0.442 && tt<0.447) {
    qa.line(0, 0.2*qa.height, qa.width, 0.2*qa.height);
    qa.line(0, 0.9*qa.height, qa.width, 0.9*qa.height);//barre du bas
  }    
  if (tt>0.447 && tt<0.51) {
    qa.line(0, 0.15*qa.height, qa.width, 0.15*qa.height);
    qa.line(0, 0.65*qa.height, qa.width, 0.65*qa.height);//barre du bas
  }  
  if (tt>0.452 && tt<0.471) {
    qa.line(0, 0.4*qa.height, qa.width, 0.40*qa.height);  //barre du bas
  }   
  if (tt>0.482 && tt<0.495) {
    qa.line(0, 0.4*qa.height, qa.width, 0.40*qa.height);  //barre du bas
  }   
  if (tt>0.453 && tt<0.457) {
    qa.line(0, 0.2*qa.height, qa.width, 0.2*qa.height);
    qa.line(0, 0.7*qa.height, qa.width, 0.7*qa.height);  //barre du bas
  }  

  if (tt>0.457 && tt<0.48) {
    qa.line(0, 0.95*qa.height, qa.width, 0.95*qa.height);  //barre du bas
  }  
  if (tt>0.462 && tt<0.471) {
    qa.line(0, 0.3*qa.height, qa.width, 0.3*qa.height);  //barre du bas
  }    
  if (tt>0.467 && tt<0.491) {
    qa.line(0, 0.35*qa.height, qa.width, 0.35*qa.height);  //barre du bas
  }  
  if (tt>0.472 && tt<0.4791) {
    qa.line(0, 0.1*qa.height, qa.width, 0.1*qa.height);  //barre du bas
  }    
  if (tt>0.437 && tt<0.51) {
    qa.line(0, 0.45*qa.height, qa.width, 0.45*qa.height);  //barre du bas
  }  
  if (tt>0.477 && tt<0.51) {
    qa.line(0, 0.75*qa.height, qa.width, 0.75*qa.height);
    qa.line(0, 0.9*qa.height, qa.width, 0.9*qa.height);  //barre du bas;  //barre du bas
  }    
  if (tt>0.482 && tt<0.51) {
    qa.line(0, 0.55*qa.height, qa.width, 0.55*height);  //barre du bas
    qa.line(0, 0.6*qa.height, qa.width, 0.6*qa.height);
    qa.line(0, 0.1*qa.height, qa.width, 0.1*qa.height);//barre du bas
    qa.line(0, 0.5*qa.height, qa.width, 0.5*qa.height);  //barre du bas
  }  
  if (tt>0.485 && tt<0.53) {
    qa.line(0, 0.75*qa.height, qa.width, 0.75*qa.height);
    qa.line(0, 0.95*qa.height, qa.width, 0.95*qa.height);  //barre du bas//barre du bas
  }    
  if (tt>0.495 && tt<0.53) {
    qa.line(0, 0.5*qa.height, qa.width, 0.5*qa.height);
    qa.line(0, 0.15*qa.height, qa.width, 0.15*qa.height);
    qa.line(0, 0.7*qa.height, qa.width, 0.7*qa.height);
    qa.line(0, 0.6*qa.height, qa.width, 0.6*qa.height);//barre du bas
  }  
  if (tt>0.500 && tt<0.53) {
    qa.line(0, 0.8*qa.height, qa.width, 0.8*qa.height);
    qa.line(0, 0.4*qa.height, qa.width, 0.40*qa.height);
    qa.line(0, 0.1*qa.height, qa.width, 0.1*qa.height);//barre du bas
  }  
  if (tt>0.505 && tt<0.53) {
    qa.line(0, 0.85*qa.height, qa.width, 0.85*qa.height);
    qa.line(0, 0.45*qa.height, qa.width, 0.45*qa.height);
    qa.line(0, 0.3*qa.height, qa.width, 0.3*qa.height);
    qa.line(0, 0.2*qa.height, qa.width, 0.2*qa.height);//barre du bas
  }  
  if (tt>0.507 && tt<0.53) {
    qa.line(0, 0.9*qa.height, qa.width, 0.9*qa.height);
    qa.line(0, 0.35*qa.height, qa.width, 0.35*qa.height);
    qa.line(0, 0.25*qa.height, qa.width, 0.25*qa.height);
    qa.line(0, 0.55*qa.height, qa.width, 0.55*qa.height);
    qa.line(0, 0.65*qa.height, qa.width, 0.65*qa.height);//barre du bas
  }    
  if (tt>0.53 && tt<0.545) {
    //barre du bas
    qa.clear();
  }  

  qa.endDraw();
}



void polygon(float x, float y, float radius, int npoints, PGraphics pg) {
  angle = TWO_PI / npoints;
  pg.beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    pg.vertex(sx, sy);
  }
  pg.endShape(CLOSE);
}


void push() {
  pushStyle();
  pushMatrix();
}


void pop() {
  popStyle();
  popMatrix();
}

void mouseMoved() {
  loop();
}
