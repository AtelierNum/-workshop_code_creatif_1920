import org.openkinect.processing.*;
import blobDetection.*; // blobs
import toxi.geom.*; // toxiclibs shapes and vectors
import toxi.processing.*; // toxiclibs display
import shiffman.box2d.*; // shiffman's jbox2d helper library
import org.jbox2d.collision.shapes.*; // jbox2d,
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.common.*; // jbox2d
import org.jbox2d.dynamics.*; // jbox2d
import processing.sound.*;
import processing.video.*;
import jp.nyatla.nyar4psg.*;

Capture cam;
MultiMarker nya;

Kinect kinect;
int kinectWidth = 640;
int kinectHeight = 480;
PImage k = createImage(640, 480, RGB);
int minThresh = 900;
int maxThresh = 975;
// pour recadrer la taille de la caméra de la kinect
float reScale;

color c;        //variable gérant la couleur du background
int smiley;     //variable gérant le changement de smileys


//Importation des sons et création de booléans pour que les sons ne se répètent pas
SoundFile jauneSon;
boolean jauneHasPlayed = false;  
SoundFile vertSon;
boolean vertHasPlayed = false;
SoundFile orangeSon;
boolean orangeHasPlayed = false;
SoundFile rougeSon;
boolean rougeHasPlayed = false;
SoundFile colereSon;
boolean colereHasPlayed = false;
SoundFile meufSon;
boolean meufHasPlayed = false;
SoundFile tropSon;
boolean tropHasPlayed = false;



// déclaration du blob (contour virtuel de la personne détectée par la kinect)
BlobDetection theBlobDetection;
ToxiclibsSupport gfx;
PolygonBlob poly;
PImage blobs;

//Physique du smiley
Box2DProcessing box2d;
ArrayList <CustomShape> shapes;


void setup() {
  //size(1280, 800); 
  //size(1920, 1080);
  fullScreen();
  pixelDensity(1);
  //colorMode(RGB, 100);
  kinect = new Kinect(this);
  kinect.enableMirror(true);    //Retourner l'image
  kinect.initDepth();           //La kinect détecte la profondeur
  kinect.initVideo();
  gfx = new ToxiclibsSupport(this);
  // création d'un blob plus petit pour des questions de performances
  blobs = createImage(kinectWidth/3, kinectHeight/3, RGB);
  // initialisation du blob
  theBlobDetection = new BlobDetection(blobs.width, blobs.height);
  theBlobDetection.setThreshold(0.3);

  reScale = (float) width / kinectWidth;

  //Création du monde gérant les principes physique avec la librairie Box2D
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, 0);

  shapes =  new ArrayList<CustomShape>();
  shapes.add(new CustomShape());

  jauneSon = new SoundFile(this, "jaune.wav");
  vertSon = new SoundFile(this, "vert.wav");
  orangeSon = new SoundFile(this, "orange.wav");
  rougeSon = new SoundFile(this, "rouge.wav");
  colereSon = new SoundFile(this, "aie.wav");
  meufSon = new SoundFile(this, "meuf.wav");
  tropSon = new SoundFile(this, "bcp.wav");

  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(i + " " + cameras[i]);
    }
  } 

  cam = new Capture(this, cameras[0]);

  cam.start();
}

boolean camStarted = false;
void camRead() {
  if (cam.available() !=true) {
    return;
  } else {
    if (camStarted == false) {
      nya=new MultiMarker(this, width, height, "camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
      nya.addARMarker("patt.hiro", 80);//id=0    Image détectée par la deuxième caméra (AR detection)
      nya.addARMarker("patt.kanji", 80);//id=1
    }
    camStarted = true;

    cam.read();
    nya.detect(cam);

    if (nya.isExist(0)) {
      markerDetected = true;
      //println(markerDetected);
      //delay(2000);

      //  println(markerDetected);
    } else {
      markerDetected = false;
    }
  }
}

boolean markerDetected = false;

void draw() {
  background(c);
  k.loadPixels();    //On va travailler avec les pixels afficher à l'écran



  // thread("camRead");
  camRead();

  // println(nya.isExist(1));

  int black = 0;                        //variable contenant le nombre de pixels noirs afficher à l'écran
  float rand1 = random(100);
  float rand2 = random(100);
  float noise1 = map(noise(rand1), 0, 1, -30, 30);
  float noise2 = map(noise(rand2), 0, 1, -30, 30);

  // Detecte la profondeur et en ressort une image en noir et blanc
  int[] depth = kinect.getRawDepth();
  for (int x = 0; x < kinect.width; x++) {
    for (int y = 0; y < kinect.height; y++) {
      int offset = x + y * kinect.width;
      int d = depth[offset];

      if (d > minThresh && d < maxThresh) {
        k.pixels[offset] = color(255);    //Affiche le blob en noir
        black += 1 ;
      } else {
        k.pixels[offset] = color(0);  //Background en blanc pour l'instant
      }
    }
  }

  CustomShape s = shapes.get(0);

//Quand le marqueur est détecté, lance le son et le changement de smiley et de couleur
  if (markerDetected && black > 11000 && meufHasPlayed == false) {
    meufSon.play();
    meufHasPlayed = true;
    c = color(237, 152, 218);
    smiley = 6;
    jauneHasPlayed = false;
    vertHasPlayed = false;
    orangeHasPlayed = false;
    rougeHasPlayed = false;
    colereHasPlayed = false;
    tropHasPlayed = false;
  }

//Détecte quand le smiley se rapproche des bords et fait les changements en conséquence
  else if (dist(s.posScreen.x, s.posScreen.y, width*0.165, height*0.175) > 230 || s.posScreen.y < 60 || s.posScreen.y > 340 ) {

    if (colereHasPlayed == false && black > 11000) {
      c = color(100, 0, 0);
      smiley = 5;
      colereSon.play();
      jauneHasPlayed = false;
      vertHasPlayed = false;
      orangeHasPlayed = false;
      rougeHasPlayed = false;
      colereHasPlayed = true;
      meufHasPlayed = false;
      tropHasPlayed = false;
    }
    //Lorsque qu'il n'y a personne à l'écran Gibili est jaune et content
    //Tous les changements à partir de maintenant se font uniquement en fonction de la surface noire (black)
  } else  if (black < 11000 && jauneHasPlayed == false) {
    c = color(242, 227, 32); 
    smiley = 1;
    jauneSon.play();
    jauneHasPlayed = true;
    vertHasPlayed = false;
    orangeHasPlayed = false;
    rougeHasPlayed = false;
    colereHasPlayed = false;
    meufHasPlayed = false;
    tropHasPlayed = false;
  } else if (!markerDetected && black > 11001 && black < 40000 && vertHasPlayed == false) {
    c = color(75, 182, 21);  
    smiley = 2;
    vertSon.play();
    jauneHasPlayed = false;
    vertHasPlayed = true;
    orangeHasPlayed = false;
    rougeHasPlayed = false;
    colereHasPlayed = false;
    meufHasPlayed = false;
    tropHasPlayed = false;
  } else if (!markerDetected && black > 50000 && black < 80000 && orangeHasPlayed == false) {
    c = color(255, 111, 21);
    smiley = 3;
    orangeSon.play();
    jauneHasPlayed = true;
    vertHasPlayed = false;
    orangeHasPlayed = true;
    rougeHasPlayed = false;
    colereHasPlayed = false;
    meufHasPlayed = false;
    tropHasPlayed = false;
  } else if (!markerDetected && black > 80001 && black < 100000 && rougeHasPlayed == false) {
    c = color(235, 38, 13);
    smiley = 4;
    rougeSon.play();
    jauneHasPlayed = true;
    vertHasPlayed = false;
    orangeHasPlayed = false;
    rougeHasPlayed = true;
    colereHasPlayed = false;
    meufHasPlayed = false;
    tropHasPlayed = false;
  } else if (!markerDetected && black > 100001 && tropHasPlayed == false) {
    tropSon.play();
    tropSon.amp(1.0);
    jauneHasPlayed = false;
    vertHasPlayed = false;
    orangeHasPlayed = false;
    rougeHasPlayed = true;
    colereHasPlayed = false;
    meufHasPlayed = false;
    tropHasPlayed = true;
  }









  k.updatePixels(); //On arrête de travailler avec les pixels
  
  //Copie l'image dans un blob plus petit
  blobs.copy(k, 0, 0, k.width, k.height, 0, 0, blobs.width, blobs.height);
  //On floute l'image pour donner un aspect plus "Barbapapa" au blob.
  //C'est plus sympa et améliore les performances
  blobs.filter(BLUR, 7);
  // Détecte le blob
  theBlobDetection.computeBlobs(blobs.pixels);




  poly = new PolygonBlob();
  // Créer la forme du blob
  poly.createPolygon();
  //Applique les physiques de box2d au blob
  poly.createBody();
  // actualise et dessine le tout
  updateAndDrawBox2D();

//Affiche et applique la physique au smiley
  for (int i = 0; i < shapes.size(); i++) {
    s = shapes.get(i);
    //s.setup1();
    s.display();
    s.update();
    s.attract(width*0.165 + noise1, height*0.185 + noise2);
  }
  
  //Initialise la physique du monde
  box2d.step();

  //Détruit le blob (car recréer juste après)
  poly.destroyBody();
}

//Fonction qui dessine le tout
void updateAndDrawBox2D() {

  //Recentre la vidéo kinect
  translate(0, (height-kinectHeight*reScale)/2);
  scale(reScale);

  // Affiche la forme du blob
  noStroke();
  fill(0);
  gfx.polygon2D(poly);
}
