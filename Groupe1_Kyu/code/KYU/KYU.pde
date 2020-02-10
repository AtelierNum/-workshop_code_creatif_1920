/* KYU
 * Auteurs : Coralie Picard, Enora Jaffré, Martin Fourny, Maël Jallais
 * Date : 27-31 Janvier 2020
 * Réalisé pendant un projet workshop
 */

//variable sons
import processing.sound.*;

//variable de boule
PImage bg;
PShape s;
PImage texture;
float ry;

//variable telephone
import netP5.*;
import oscP5.*;
OscP5 oscP5;
NetAddress myRemoteLocation;


float lux=500; // Lumière 

// Pour secouer
float shake; 
float shakeMax; // Valeur Max
float shakeMin; // Valeur Minimum

float turn; // Pour tourner

float horiz; // Pour l'orientation

int etat_background = 0;
int p_etat=0; 
long declenchement_secoue = 0;


// Déclarer les objets contenant les sons
SoundFile file00, file0, file1, file2, file34, file5, file6;

public void setup() {
  //fullScreen(P3D); utilisé pour la présentation en grand écran avec l'image "univers_kyu.jpg"
  size(640,560,P3D);
  
  // CHARGEMENT DE LA BOULE
  bg = loadImage("fond_kyu.jpg");
  texture = loadImage("texture.jpg"); // chargement de la texture
  s = loadShape("untitled.obj");
  println( s.getChildCount());

  // OSC
  // Paramètres OSC pour la communication avec le téléphone
  oscP5 = new OscP5(this, 8012);
  myRemoteLocation = new NetAddress("192.168.1.68", 8012); // Mettre l'IP du téléphone

  // Chargement de tous les fichiers audio
  file00 = new SoundFile(this, "kyu.wav"); //Son en background
  file0 = new SoundFile(this, "active.wav");
  file1 = new SoundFile(this, "respiration.wav");
  file2 = new SoundFile(this, "teleportation-power.wav");
  file34 = new SoundFile(this, "roulade.wav");
  file5 = new SoundFile(this, "division.wav");
  file6 = new SoundFile(this, "tremblotte.wav");
  file00.loop();
}


void draw() {
  background(bg);
  s.setTexture(texture); //La sphère charge la texture depuis texture.jpg
  s.setStroke(false); //Masquer les lignes de la sphère
 
  //LUMIERE
  lights();
  spotLight(120, 120, 120, width/2, height/2, 400, 0, 0, -1, PI/4, 2);
  
  
  // On défini les valeurs  min et max quand on secoue le téléphone
  etat_background = 0; // état active
  if (shake>0.2) {
    shake= shakeMax;
  }

  if (shake<-0.3) {
    shake= shakeMin;
  }

  // Tester les différents cas qui définissent l'état du background
  if ((shakeMax-shakeMin)>8== true) { //Téléphone secoué
    etat_background = 5;
    declenchement_secoue = millis();
  } else if (horiz<-9) {
    etat_background = 6;
  }//Téléphone horizontal écran bas
  else if (turn<-8) { 
    etat_background = 3;
  } //Tourner à droite
  else if (turn>8) {
    etat_background = 4;
  } //Tourner à gauche
  else if (lux<1 == true) { //Luminosité
    etat_background = 2;
  } else if (horiz>9) etat_background = 1; //Téléphone horizontal écran haut

  // resetter l'état de la kyu
  if (p_etat != etat_background) {
    s = loadShape("untitled.obj");
  }

  // DECLENCHEMENTS SONORES
  if (p_etat != etat_background) {
    if (file0.isPlaying()) file0.stop();
    if (file1.isPlaying()) file1.stop();
    if (file2.isPlaying()) file2.stop();
    if (file34.isPlaying()) file34.stop();
    if (file5.isPlaying()) file5.stop();
    if (file6.isPlaying()) file6.stop();
    switch(etat_background) {
    case 0: 
      if (!file0.isPlaying()) file0.play(); 
      file0.loop();
      break;
      
    // Déclaration des sons en fonction des différentes actions avec le téléphone
    case 1: 
      if (!file1.isPlaying()) file1.play();
      file1.loop();
      break;
    case 2: 
      file2.play(); 
      file2.loop();
      break;
    case 3: 
      file34.play();
      file34.loop();
      break;
    case 4: 
      file34.play();
      file34.loop();
      break;
    case 5: 
      file5.play(); 
      break;
    case 6: 
      file6.play(); 
      break;
    }
  }

  // Appliquer la couleur de fond et détermine les interactions
  switch(etat_background) { // Variable si la boule est active 
  
  case 0: //VERTICALE
    {
      for (int j = 0; j < s.getChildCount(); j++) {
        PShape child =  s.getChild(j);

        // Déformation de la boule
        for (int i = 0; i < child.getVertexCount(); i++) {
          float deformation1 = sin (frameCount/6+j)/1.5;
          float deformation2 = sin (frameCount/2+j)/1.5;
          float deformation3 = sin (frameCount/7+j)/1.5;
          PVector v = child.getVertex(i);
          v.x += deformation1 ;
          v.y += deformation2;
          v.z += deformation3 ;
          child.setVertex(i, v);
        }
      }

      translate(width/2, height/2 + 50, -200);
      rotateZ(PI);
      shape(s);

      ry += 0.02;
    }
    break;

  case 1 : //HORIZONTAL HAUT

    for (int j = 0; j < s.getChildCount(); j++) { // Etat de la boule transformé
      PShape child =  s.getChild(j);

      // Déformation de la boule
      for (int i = 0; i < child.getVertexCount(); i++) {
        float deformation1 = sin (frameCount*15.+j)/2.5;
        float deformation2 = sin (frameCount/20.+j )/2.5;
        float deformation3 = sin (frameCount/40.+j )/2.5;
        PVector v = child.getVertex(i);
        v.x += deformation1 ;
        v.y += deformation2;
        v.z += deformation3 ;
        child.setVertex(i, v);
      }
    }

    translate(width/2, height/2 + 50, -200); // Position de la boule
    rotateZ(PI);
    shape(s); //Chargement de la sphère
    ry += 0.02; 
    break;


  case 2: //LUMINOSITE

    for (int j = 0; j < s.getChildCount(); j++) { // Etat de la boule transformé
      PShape child =  s.getChild(j);
      
      // DEFORMATION DE LA BOULE
      for (int i = 0; i < child.getVertexCount(); i++) {
        float deformation1 = sin (frameCount+j);
        float deformation2 =  0.15/(sin(frameCount+j) + 0.0001);
        float deformation3 = sin (frameCount+j);
        PVector v = child.getVertex(i);
        v.x += deformation1 ;
        v.y += deformation2;
        v.z += deformation3 ;
        child.setVertex(i, v);
      }
    }
    translate(width/2, height/2 + 50, -200);
    rotateZ(PI);
    shape(s); //Chargement de la sphère
    ry += 0.02;
  break;

  case 3: //TOURNE VERS LA DROITE

    float xoffset = cos(radians(frameCount)) * -400; //Déplacement de l'objet à la rotation du device
    translate(width/2+ xoffset, height/2 + 50, -200); //Positionnement de l'obj

    rotateZ(xoffset/100.); //Vitesse de déplacement de l'objet
    shape(s); //Chargement de la sphère
  break;


  case 4 : //BOULE VERS LA GAUCHE
  
    float xoffset2 = cos(radians(frameCount)) * 400; //Déplacement de l'objet à la rotation du device
    translate(width/2 + xoffset2, height/2 + 50, -200);//Positionnement de l'obj
    noStroke();
    rotateZ(xoffset2/100.); //Vitesse de déplacement de l'objet
    shape(s); //Chargement de la sphère
  break;

  case 6 : //HORIZONTAL BAS

    for (int j = 0; j < s.getChildCount(); j++) { // Etat de la boule transformé
      PShape child =  s.getChild(j);
      
     // Déformation de la boule
      for (int i = 0; i < child.getVertexCount(); i++) {
        float deformation1 = sin(frameCount)*2;
        float deformation2 = sin(frameCount);
        float deformation3 = (frameCount)/-80;
        PVector v = child.getVertex(i);
        v.x += deformation1 ;
        v.y += deformation2;
        v.z += deformation3 ;
        
        child.setVertex(i, v);
      }
    }

    translate(width/2, height/2+50, -200);
    rotateZ(PI);
    shape(s); //Chargement de la sphère

  break;
  default: // On remet par défaut l'état de la boule
  break;
  }

  // SECOUER
  if (millis() - declenchement_secoue < 2000) {//SECOUE
    for (int j = 0; j < s.getChildCount(); j++) {
      PShape child =  s.getChild(j);

      // Deformation de la créature
      for (int i = 0; i < child.getVertexCount(); i++) {
        float deformation1 = sin (frameCount/15.+j)*2 ;
        float deformation2 = sin (frameCount/20.+j )*2;
        float deformation3 = sin (frameCount/10.+j )*2;
        PVector v = child.getVertex(i);
        v.x += deformation1 ;  //déplacement x horizontal
        v.y += deformation2;  //déplacement y vertical
        v.z += deformation3 ;  //déplacement Z profondeur
        child.setVertex(i, v);
      }
    }

    translate(width/2, height/2 + 50, -200);
    rotateZ(PI);
    ry += 0.01;
    shape(s);
    
  }
  p_etat = etat_background; // L'animation revient à l'état d'origine
} 


void oscEvent(OscMessage theOscMessage) { //check if theOscMessage has the address pattern we are looking for. 
 
  // LIGHT SENSOR   
  // Communication avec Light Sensor et OSC 
  if (theOscMessage.checkAddrPattern("/light")==true) {
    /* check if the typetag is the right one. */
    if (theOscMessage.checkTypetag("f")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      lux = theOscMessage.get(0).floatValue();  
      println("### reçu /light " + lux);
      return;
    }
  }

  //SECOUER
  if (theOscMessage.checkAddrPattern("/accelerometer/linear/x")==true) {
    /* check if the typetag is the right one. */
    if (theOscMessage.checkTypetag("f")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      shakeMax = theOscMessage.get(0).floatValue();  
      println("### reçu /accelerometer/linear/x " + shakeMax);
      return;
    }
  }

  //TOURNER COTES
  if (theOscMessage.checkAddrPattern("/accelerometer/raw/x")==true) {
    /* check if the typetag is the right one. */
    if (theOscMessage.checkTypetag("f")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      turn = theOscMessage.get(0).floatValue();  
      println("### reçu /accelerometer/raw/x " + turn);
      return;
    }
  } 

  //METTRE A L'HORIZONTALE
  if (theOscMessage.checkAddrPattern("/accelerometer/raw/z")==true) {
    /* check if the typetag is the right one. */
    if (theOscMessage.checkTypetag("f")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      horiz = theOscMessage.get(0).floatValue();  
      println("### reçu /accelerometer/raw/z " + horiz);
      return;
    }
  }
}
