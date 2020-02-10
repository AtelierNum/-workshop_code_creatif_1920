// LIBRAIRIES
import oscP5.*;
import netP5.*;
import processing.sound.*;
import java.util.Calendar;

OscP5 oscP5;
NetAddress myRemoteLocation;

//LES SOUND
SoundFile file;
SoundFile file2;
SoundFile file3;
SoundFile file4;
SoundFile file5;


// Var CONSTEL
int nombre_balles = 20;
int nouveau_balles = 20;
ArrayList <Ball> b;
int k = 50;
float L;

// VAR VAGUES
int xspacing = 16;   // espace entre les différents points
int w;              // largeur de la vague
int spacing = 20;

float l;
float theta = 0.0;  // débute a l'angle 0
float amplitude = 75.0;  // hauteur de la vague
float period = 500.0;  // combien il y a de pixel avant quelle se repete
float dx;  // Value for incrementing X, a function of period and xspacing
float[] yvalues;  // Using an array to store height values for the wave

//VAR FLEUR

float LL;
float oX, oY, d; //cible et distance de la cible
float[] posX; //position des partciules
float[] posY; //position des partciules
color[] c; //couleurs des particules
float[] r; //rayon des particules sur le cercle trigonométrique
float[] angle; //angle des particules sur le cercle trigonométrique
float[] vr; //vitesse des particules
float colorRatio; //plage de couleur

boolean etat = false;//animation on/off
int nbParticules;//notre de point

float angleGlobal; //angle de rotation de notre skecth
float vAngle; //sens de la rotation

float count; //notre décompte. Toute les 500 frame nous effacerons notre fleur pour en dessiner une nouvelle.


//VAR MAGNET

boolean recordPDF = false;
int NORTH = 0;
int NORTHEAST = 1; 
int EAST = 2;
int SOUTHEAST = 3;
int SOUTH = 4;
int SOUTHWEST = 5;
int WEST = 6;
int NORTHWEST= 7;

float stepSize = 10;
float diameter = 1;

int direction;
float posXX, posYY;

// ORGANIC
// ------ agents ------
Agent[] agents = new Agent[100000]; // create more ... to fit max slider agentsCount
int agentsCount = 2000;
float noiseScale = 100, noiseStrength = 10, noiseZRange = 0.4;
float overlayAlpha = 10, agentsAlpha = 90, strokeWidth = 0.3;
int drawMode =1;

// VAR PICKER
float picker = -1;
boolean new_picker = false;

void setup() {

  // TAILLE DU TOUT
  fullScreen();
  // CONNECTION OSC
  oscP5 = new OscP5(this, 12345);

  noCursor();

  // CONSTEL
  file = new SoundFile (this, "nidra_in_the_sky_with_ayler.mp3");
  b = new ArrayList<Ball>();
  for (int s=0; s < nombre_balles; s++) {
    b.add (new Ball (random(50, width), random(50, height), random(4, 7), random(2, 4)));
  }

  // VAGUES
  w = width+16;
  dx = (TWO_PI / period) * xspacing;
  yvalues = new float[w/xspacing];
  file2 = new SoundFile (this, "after_all.mp3");



  //ORGANIC
  file5 = new SoundFile (this, "fluidscape.mp3");
  for (int i=0; i<agents.length; i++) agents[i] = new Agent();

  //FLEUR
  file3 = new SoundFile (this, "juicy.mp3");
  update();

  //MAGNET
  file4 = new SoundFile (this, "a_slow_dream.mp3");
  posXX = width/2;
  posYY = height/2;
}


void draw () {

  //CONSTEL
  if (picker == 0) {

    background(0, 100);

    // Mettre à jour le nombre de balles (ajouter, enlever)

    if (nouveau_balles != nombre_balles) {
      int difference = abs(nouveau_balles - nombre_balles);
      if (nouveau_balles > nombre_balles) { // Ajouter de nouvelles balles
        for (int s=0; s < difference; s++) {
          b.add (new Ball (random(50, width), random(50, height), random(4, 7), random(2, 4)));
        }
      } else { // Supprimer des balles existantes
        for (int s=0; s < difference; s++) {
          b.remove(0);
        }
      }
      nombre_balles = nouveau_balles;
    }


    plexus(); // Appliquer le mouvement, tracer les balles et les lignes
    fill(80);
  }



  //VAGUES
  if (picker == 1) {


    background(0);
    calcWave();
    renderWave();
  }

  //FLEUR
  if (picker == 2) {

    if (new_picker == true) {
      fill(0, 0, 0, 255);
      rect(0, 0, width, height);
      new_picker = false;
    }

    pushMatrix();

    /*rotation de la fleur*/
    if (etat == false) //si nous activons la rotation de la fleur
    {

      angleGlobal += vAngle;
    } else if (etat == true) //sinon la fleur reste droite
    {
      angleGlobal = angleGlobal;
    }
    translate(oX, oY);
    rotate(radians(angleGlobal));

    /*calcul des nouvelles positions de notre fleur*/
    for (int i=1; i<nbParticules; i++) { 
      r[i] += vr[i]; // reduction du rayon

      if (r[i]>400 || r[i]<0) //limite de la fleur. Si une des particules atteint le centre alors nous re initinalisons un cycle à l'aide de la fonction update();
      {
        update();
      }
      //position des partciules
      posX[i] = cos(angle[i])*r[i];
      posY[i] = sin(angle[i])*r[i];
      stroke(c[i], 5);
      noFill();
      //dessin de la fleur
      if (i != nbParticules-1)
      {
        line(posX[i], posY[i], posX[i+1], posY[i+1]);
      } else
      {
        line(posX[i], posY[i], posX[1], posY[1]);
      }
    }
    popMatrix();
    //decompte
    count++;
    if (count >= 3000)
    {
      count = 0;
    }
  }

  //MAGNET
  if (picker == 3) {

    if (new_picker == true) {
      fill(0, 0, 0, 255);
      rect(0, 0, width, height);
      new_picker = false;
    }

    {
      direction = (int) random(0, 4);

      if (direction == NORTH) {  
        posYY -= stepSize;
      } else if (direction == NORTHEAST) {
        posXX += stepSize;
        posYY -= stepSize;
      } else if (direction == EAST) {
        posXX += stepSize;
      } else if (direction == SOUTHEAST) {
        posXX += stepSize;
        posYY += stepSize;
      } else if (direction == SOUTH) {
        posYY += stepSize;
      } else if (direction == SOUTHWEST) {
        posXX -= stepSize;
        posYY += stepSize;
      } else if (direction == WEST) {
        posXX -= stepSize;
      } else if (direction == NORTHWEST) {
        posXX -= stepSize;
        posYY -= stepSize;
      }

      if (posXX > width) posXX = 0;
      if (posXX < 0) posXX = width;
      if (posYY < 0) posYY = height;
      if (posYY > height) posYY = 0;

      fill(random (0, 255), 100);
      ellipse(posXX+stepSize/2, posYY+stepSize/2, diameter, diameter);
    }
  }
  //ORGANIC
  if (picker == 4) {

    background (0);
    fill(255, overlayAlpha);
    noStroke();
    rect(0, 0, width, height);

    stroke(255, agentsAlpha);
    //draw agents
    if (drawMode == 1) {
      for (int i=0; i<agentsCount; i++) agents[i].update1();
    } else {
      for (int i=0; i<agentsCount; i++) agents[i].update2();
    }
  }
}


//CONSTEL
void plexus() {
  for (int i = 0; i< b.size(); i++) {
    Ball b1 = b.get(i);
    b1.BallMoved();
    for (int j=0; j<b.size(); j++) {
      Ball b2 = b.get(j);
      float d = dist(b1.x, b1.y, b2.x, b2.y); // distance entre les centres des deux balles
      if (d < k) { // Si la distance est inférieure à k
        stroke(random(0, 255), 150);
        line(b1.x, b1.y, b2.x, b2.y);
      }
    }
  }
}

//VAGUES
void calcWave() {
  // Increment theta (try different values for 'angular velocity' here
  theta += 0.02;

  // For every x value, calculate a y value with sine function
  float x = theta;
  for (int i = 0; i < yvalues.length; i++) {
    yvalues[i] = sin(x)*amplitude;
    x+=dx;
  }
}

void renderWave() {
  noStroke();
  fill(255);
  
  // A simple way to draw the wave with an ellipse at each location
  for (int j = 0; j < height; j = j +spacing) {
    for (int x = 0; x < yvalues.length; x++) {
      ellipse(x*xspacing, j+yvalues[x], 3, 3);
    }
  }
}


//FLEUR
void update() {

  vAngle = random(-0.1, 0.1); //définition du sens de rotation du sketch 
  nbParticules = 100; 
  oX = width/2;
  oY = height/2;
  posX = new float[nbParticules];
  posY = new float[nbParticules];
  r = new float[nbParticules];
  angle = new float[nbParticules];
  vr = new float[nbParticules];  
  c = new color[nbParticules];

  for (int i=1; i<nbParticules; i++) { 
    angle[i] = ((2*PI)/nbParticules)*i; //Ici nous divisons le cercle 2PI par le nombre de particule multiplier par i pour obtenir l'angle de chaque particule et les placer à équidistance les une des autres
    vr[i] = random(-0.5, -0.1); 
    r[i] = 400; //ici nos particules ont un rayon de départ identique pour former notre cercle mais nous pouvons aussi le définir en random et obtenir un autre visuel random(150, 200);
    posX[i] = oX+cos(angle[i])*r[i]; //position x sur le cercle x = cos(angle)*rayon
    posY[i] = oY+sin(angle[i])*r[i]; //position y sur le cercle y = cos(angle)*rayon
    d = dist(posX[i], posY[i], oX, oY); //distance entre les particules et la cible
    c[i] = color(255); //définissions de la couleur
  }
}

void oscEvent(OscMessage theOscMessage) {

  // Changement D'animation
  if (theOscMessage.checkAddrPattern("/clean__nuance__picker")==true) {  
    int g = theOscMessage.get(0).intValue();
    picker = g;
    new_picker = true;
    println("valeur du picker : " + g);

    // CHANGEMENT DE SONG
    if (picker == 0) {
      file.loop();
      file2.pause();
      file3.pause();
      file4.pause();
      file5.pause();

      //
    } else if (picker == 1) {
      file2.loop();
      file.pause();
      file3.pause();
      file4.pause();
      file5.pause();
    } else if (picker == 2) {
      file3.loop();
      file.pause();
      file2.pause();
      file4.pause();
      file5.pause();
    } else if (picker == 3) {
      file4.loop();
      file.pause();
      file2.pause();
      file3.pause();
      file5.pause();
    } else if (picker == 4) {
      file5.loop();
      file.pause();
      file2.pause();
      file3.pause();
      file4.pause();
    }
  }

  // Personnalisation Anim

  // Personnalisation CONSTEL
  if (theOscMessage.checkAddrPattern("/clean__nuance__3")==true) {  // Taille Trait Constel
    float g = theOscMessage.get(0).floatValue();
    k = int(g * 200);
    println("valeur du 3 : " + g);
  }
  if (theOscMessage.checkAddrPattern("/clean__nuance__2")==true) { // Quantité Balle Constel
    float g = theOscMessage.get(0).floatValue();
    nouveau_balles = int(g * 75) + 1;
    println("valeur du 2 : " + g);
    println("nouveau nombre de balles souhaitées : " + nouveau_balles);
  }
  if (theOscMessage.checkAddrPattern("/clean__nuance__1")==true) { // Vitesse Balles Constel
    float g = theOscMessage.get(0).floatValue();
    println("valeur du 1 : " + g);
    for (int s=0; s<b.size(); s++) {
      Ball b1 = b.get(s);
      b1.friction = (g * 2) + 0.1;
    }
  }

  //ANIMATION VAGUES
  if (theOscMessage.checkAddrPattern("/clean__nuance__2")==true) {  // Quantité Vague
    float g = theOscMessage.get(0).floatValue();

    amplitude = int(g*500)+100;
  }
  if (theOscMessage.checkAddrPattern("/clean__nuance__3")==true) { // Taille Vague
    float g = theOscMessage.get(0).floatValue();

    spacing = int(g * 95 + 5);
  }

  // ANIMATION FLEUR
  if (theOscMessage.checkAddrPattern("/clean__nuance__3")==true) { // Taille Fleur
    float g = theOscMessage.get(0).floatValue();

    for (int i=1; i<nbParticules; i++) { 
      r[i] = int(g*300);
    }
    println("valeur du slider 1 : " + g);
  }

  if (theOscMessage.checkAddrPattern("/clean__nuance__1")==true) { // Vitesse Fleur
    float g = theOscMessage.get(0).floatValue();

    for (int i=1; i<nbParticules; i++) {
      vr[i] = int(g-1);
    }
    println("valeur du slider 1 : " + g);
  }
  //ANIMATION MAGNET

  if (theOscMessage.checkAddrPattern("/clean__nuance__3")==true) { // Taille Magnet
    float g = theOscMessage.get(0).floatValue();

    diameter = int(g*100)+1;
    println("valeur du slider 1 : " + g);
  }

  if (theOscMessage.checkAddrPattern("/clean__nuance__1")==true) { // Vitesse Magnet
    float g = theOscMessage.get(0).floatValue();

    stepSize = int(g*10)+1;
    println("valeur du slider 1 : " + g);
  }

  // ANIMATION ORGANIC

  if (theOscMessage.checkAddrPattern("/clean__nuance__2")==true) { //Quantité
    float g = theOscMessage.get(0).floatValue();
    agentsCount = int(g * 12000)+1000;
    println("valeur du slider 1 : " + g);
  }

  if (theOscMessage.checkAddrPattern("/clean__nuance__1")==true) { //Vitesse
    float g = theOscMessage.get(0).floatValue();
    drawMode = int(g *2)+1;
    println("valeur du slider 1 : " + g);
  }

  if (theOscMessage.checkAddrPattern("/clean__nuance__3")==true) { // Sens
    float g = theOscMessage.get(0).floatValue();
    noiseScale = int(g *10)+100;
    println("valeur du slider 1 : " + g);
  }
  if (theOscMessage.checkAddrPattern("/clean__nuance__3")==true) { //Sens
    float g = theOscMessage.get(0).floatValue();
    noiseStrength = int(g *10)+10;
    println("valeur du slider 1 : " + g);
  }

  if (theOscMessage.checkAddrPattern("/clean__nuance__3")==true) { //Sens
    float g = theOscMessage.get(0).floatValue();
    noiseZRange = int(g *10)+0.4;
    println("valeur du slider 1 : " + g);
  }
}

// TEST DEPUIS L'ORDI
void keyPressed() {
  new_picker = true;
  if (key == '0') picker = 0;
  if (key == '1') picker = 1;
  if (key == '2') picker = 2;
  if (key == '3') picker = 3;
  if (key == '4') picker = 4;
}
