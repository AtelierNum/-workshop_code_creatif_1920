//Importer librairies
import de.voidplus.leapmotion.*;
import ddf.minim.*;

import processing.video.*;

Movie movie;



//jouer audios
AudioPlayer sibal1;
AudioPlayer sibal2;
AudioPlayer sibal3;
AudioPlayer sibal4;
AudioPlayer sibal5;


//ronds 
Bell bell1;
Bell bell2;
Bell bell3;
Bell bell4;
Bell bell5;

Minim minim;

LeapMotion leap;

int pageSelected = 0;

float handX, handY, pHandX, pHandY;

void setup() {
  //taille écran
  size(1925, 1035, P2D);
  //arrière-plan
  background(0);

  //télécharger vidéo
  movie = new Movie(this, "etoiless.mov");
  movie.loop();

  //animations 
  minim = new Minim(this);

  //ronds position, taille, couleur, et musique
  bell1 = new Bell(1, 0, 100, color(30, 82, 252), "file1.mp3"); 
  bell2 = new Bell(2, 72, 100, color(0, 127, 255), "file2.mp3");
  bell3 = new Bell(3, 144, 100, color(24, 175, 252), "file3.mp3");
  bell4 = new Bell(4, 216, 100, color(70, 2, 173), "file4.mp3");
  bell5 = new Bell(5, 288, 100, color(114, 98, 252), "file5.mp3");

  smooth();

  leap = new LeapMotion(this).allowGestures(); 

  //lancer animations
  init_animation1();
  init_animation3();
  init_animation4();
  init_animation5();
  init_animation2();

  //télécharger musiques
  sibal1 = minim.loadFile("file1.mp3");
  sibal2 = minim.loadFile("file2.mp3");
  sibal3 = minim.loadFile("file3.mp3");
  sibal4 = minim.loadFile("file4.mp3");
  sibal5 = minim.loadFile("file5.mp3");

}


// ======================================================
//Callbacks

void leapOnInit() {
  println("Leap Motion Init");
}
void leapOnConnect() {
  println("Leap Motion Connect");
}
void leapOnFrame() {
  // println("Leap Motion Frame");
}
void leapOnDisconnect() {
  println("Leap Motion Disconnect");
}
void leapOnExit() {
  println("Leap Motion Exit");
}




//page accueil
void mainAnimationLoop() {



  if (pageSelected == 0) {

    //animation ronds (vibrations)
    bell1.jiggle();
    bell2.jiggle();
    bell3.jiggle();
    bell4.jiggle();
    bell5.jiggle();

    //montrer animation
    bell1.display();
    bell2.display();
    bell3.display();
    bell4.display();
    bell5.display();

    //arrêter musique sur la page 0
    sibal1.pause();
    sibal2.pause();
    sibal3.pause();
    sibal4.pause();
    sibal5.pause();

    //fonctionne avec mains
    for (Hand hand : leap.getHands ()) {

      //définir pouce et index
      PVector thumbPos = hand.getThumb().getPosition();
      PVector indexPos =hand.getIndexFinger().getPosition();

      //quand on touche un rond(1, 2, 3, 4 et 5), aller sur la page (1, 2, 3, 4, et 5) de son animation et lancer sa musique
      if (bell1.contains(thumbPos.x, thumbPos.y) && bell1.contains(indexPos.x, indexPos.y) ) {
        pageSelected = 1;
        loop_animation1(); 
        sibal1 = minim.loadFile("file1.mp3");
        sibal1.play();
      }
      if (bell2.contains(thumbPos.x, thumbPos.y) && bell2.contains(indexPos.x, indexPos.y) ) {
        pageSelected = 2;
        loop_animation2(); 
        sibal2 = minim.loadFile("file2.mp3");
        sibal2.play();
      }
      if (bell3.contains(thumbPos.x, thumbPos.y) && bell3.contains(indexPos.x, indexPos.y) ) {
        pageSelected = 3;
        loop_animation3();
        sibal3 = minim.loadFile("file3.mp3");
        sibal3.play();
      }
      if (bell4.contains(thumbPos.x, thumbPos.y) && bell4.contains(indexPos.x, indexPos.y) ) {
        pageSelected = 4;
        loop_animation4();
        sibal4 = minim.loadFile("file4.mp3");
        sibal4.play();
      }
      if (bell5.contains(thumbPos.x, thumbPos.y) && bell5.contains(indexPos.x, indexPos.y) ) {
        pageSelected = 5;
        sibal5.play();
      }
    }
  } 
  //lancer Loop Animation (1, 2, 3, 4 et 5) (draw)
  else if (pageSelected == 1) {
    loop_animation1();
  } else if (pageSelected == 2) {
    loop_animation2(); 
    //background(0, 255, 0);
  } else if (pageSelected == 3) {
    loop_animation3();
  } else if (pageSelected == 4) {
    loop_animation4();
  } else if (pageSelected == 5) {
    loop_animation5();
  }
}







void draw() {
  //arrière plan
  background(0);
  //lancer la vidéo et définition de la taille de la vidéo
  image(movie, 0, 0, width, height);

  mainAnimationLoop();

  // Attribuer les valeurs de position de la main trouvées à la frame précédente aux variables pHandX et pHandY
  pHandX = handX; // position précédente de la main en X
  pHandY = handY; // position précédente de la main en Y


  //int fps = leap.getFrameRate();

  for (Hand hand : leap.getHands ()) {



    // Attribuer des valeurs de position actuelle de la main aux variables de la main
    handX = hand.getPosition().x; // position actuelle de la main en X
    handY = hand.getPosition().y; // position actuelle de la main en Y
    for (Finger finger : hand.getFingers()) {
      if (hand.getGrabStrength()> 0.9 && hand.getOutstretchedFingers().size()==0) {
        pageSelected = 0;
      }
    }

    //

    for (Finger finger : hand.getFingers()) {
      PVector fingerPosition = finger.getPosition();
      if (pageSelected == 0) {
        fill(255);
        ellipse(fingerPosition.x, fingerPosition.y, 48, 48);
      }
    }
  }
}


void movieEvent(Movie m) {
  m.read();
}

void keyPressed() {
  if (key == 'r') {
    // replace the balls 
    bell1.replace(1, 0, 100, color(30, 82, 252), "file1.mp3"); 
    bell2.replace(2, 72, 100, color(0, 127, 255), "file2.mp3");
    bell3.replace(3, 144, 100, color(24, 175, 252), "file3.mp3");
    bell4.replace(4, 216, 100, color(70, 2, 173), "file4.mp3");
    bell5.replace(5, 288, 100, color(114, 98, 252), "file5.mp3");
  }
  //enter in the page(0,1,2,3,4 and 5 )
  if (key == '0') pageSelected = 0;
  if (key == '1') pageSelected = 1;
  if (key == '2') pageSelected = 2;
  if (key == '3') pageSelected = 3;
  if (key == '4') pageSelected = 4;
  if (key == '5') pageSelected = 5;
}
