import jp.nyatla.nyar4psg.*;
import jp.nyatla.nyar4psg.utils.*;



/** SEMAINE DE WORKSHOP CODE CRÉATIF DU 27/01/2020 AU 31/01/2020
 * 
 * Code permettant de reconnaître des markers à l'aide d'une webcam 
 * et de déclencher une animation (graphisme et son) lorsque ces markers sont cachés
 * utilise la librairie nyar4psg de Artoolkit pour l'utilisation des markers
 */
 
import processing.video.*; //librairie pour utiliser la caméra
import jp.nyatla.nyar4psg.*; // librairie pour utiliser les markers
import processing.sound.*; // librairie pour le son

// on charge les variables des animations
SoundFile sample1;
Amplitude rms1;
float sum1;

SoundFile sample2;
Amplitude rms2;
float sum2;

SoundFile sample3;
Amplitude rms3;
float sum3;

SoundFile sample4;
Amplitude rms4;
float sum4;
ArrayList<Bulle2> baballes2 = new ArrayList<Bulle2>();

SoundFile sample5;
Amplitude rms5;
float sum5;

SoundFile sample6;
Amplitude rms6;
float sum6;

Amplitude ampl;
SoundFile kick;
int actRandomSeed = 35;

SoundFile sample7;
Amplitude rms7;
float sum7;
ArrayList<Bulle> 
  baballes = new ArrayList<Bulle>();

SoundFile sample8;
Amplitude rms8;
float sum8;

SoundFile sample9;
Amplitude rms9;
float sum9;

// ici ce sont les variables de la caméra et des markers
Capture cam;
MultiMarker nya;

// on ajoute un facteur qui permet de lisser le son
float smoothingFactor = 0.25;

//pour l'animation du maker 1
Drop[] drops = new Drop[100];


// SETUP //
void setup() {
  size(displayWidth, displayHeight,P2D); //on veut que notre fenêtre fasse la taille de l'écran
  noCursor(); // pratique pour cacher la souris en mode présentation
  //colorMode(RGB, 100);
  
  println(MultiMarker.VERSION);  
  cam=new Capture(this, displayWidth, displayHeight); //pour fonctionner correctement la caméra doit être reglé au mêmes dimensions que l'écran
  
  //on ajoute les 10 markers
  nya=new MultiMarker(this, width, height, "camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
  nya.addARMarker("patt.hiro", 80);//id=0
  nya.addARMarker("patt.kanji", 80);//id=1
  nya.addNyIdMarker(0, 80);//id=2
  nya.addNyIdMarker(1, 80);//id=3
  nya.addNyIdMarker(2, 80);//id=4
  nya.addNyIdMarker(3, 80);//id=5
  nya.addNyIdMarker(4, 80);//id=6
  nya.addNyIdMarker(5, 80);//id=7
  nya.addNyIdMarker(6, 80);//id=8
  nya.addNyIdMarker(7, 80);//id=9


//on ajoute les 10 sons
  sample1 = new SoundFile(this, "bass.wav");
  sample1.loop(); //loop pour que le son se joue en boucle
  //sample1.amp(1);

  sample2 = new SoundFile(this, "piano.wav");
  sample2.loop();
  //sample2.amp(0.5);

  sample3 = new SoundFile(this, "drum.wav");
  sample3.loop();

  sample4 = new SoundFile(this, "synth.wav");
  sample4.loop();

  sample5 = new SoundFile(this, "Bell Loop.wav");
  sample5.loop();

  sample6 = new SoundFile(this, "808 Loop 01.wav");
  sample6.loop();

  sample7 = new SoundFile(this, "Pad Loop 3 copie.wav");
  sample7.loop();

  sample8 = new SoundFile(this, "Perc Loop 02.wav");
  sample8.loop();

  sample9 = new SoundFile(this, "String Loop.wav");
  sample9.loop();
  
  kick = new SoundFile(this, "Perc Loop 3.wav" );
  kick.loop();

// puis on ajoute les rms pour chaque son, qui analyse le son pour que l'animation réagisse au rythme de la musique
  rms1 = new Amplitude(this);
  rms1.input(sample1);

  rms2 = new Amplitude(this);
  rms2.input(sample2);

  rms3 = new Amplitude(this);
  rms3.input(sample3);

  rms4 = new Amplitude(this);
  rms4.input(sample4);

  rms5 = new Amplitude(this);
  rms5.input(sample5);

  rms6 = new Amplitude(this);
  rms6.input(sample6);

  ampl = new Amplitude(this);
  ampl.input(kick);

  rms7 = new Amplitude(this);
  rms7.input(sample7);

  rms8 = new Amplitude(this);
  rms8.input(sample8);

  rms9 = new Amplitude(this);
  rms9.input(sample9);

 //on demande à la caméra de se lancer
  cam.start();

//pour l'animation du maker 1
  for (int i = 0; i < drops.length; i++) {
    drops[i]= new Drop();
  }
}

void draw() {
  background(0); //on ajoute un arriere plan noir

  if (cam.available() !=true) {
    return;
  }
  cam.read();
  nya.detect(cam);
  // on dit à la caméra de detecter les markers
  //nya.drawBackground(cam);//pour faire disparaitre le retour cam on enlève cette ligne de code

  //  println(nya.isExistMarker(0)); utile si on veut voir dans la console si la cam detecte un marker


// LES ANIMATIONS //

// animation changement de couleurs du fond
  if (!nya.isExistMarker(9)) { //si le marker 9 existe, avec le ! devant c'est l'inverse donc "si le marker à n'existe pas"
    sum3 += (rms3.analyze() - sum3) * smoothingFactor;
    float rms_scaled = sum3 * (height/2) * 5;
    //println(sum3);
    if (sum3 <0.15) {
      fill(4, 50, 111);
      rect(0, 0, width, height);
    } else if (sum3 <0.25 && sum3 >0.15) {
      fill(6, 40, 111);
      rect(0, 0, width, height);
    } else {
      fill(8, 50, 111);
      rect(0, 0, width, height);
    }

    if (sample3.isPlaying() == false) { 
      sample3.play(); //si le marker est caché le son marche
    }
  } else {
    sample3.stop(); //sinon il s'arrête
  }

  
  //animation cercle qui grandit en partant du centre (son bass)
  if (!nya.isExistMarker(0)) { //si le marker 0 existe, avec le ! devant c'est l'inverse donc "si le marker à n'existe pas"

    stroke(132, 82, 224);
    strokeWeight(3);
    noFill();

    sum1 += (rms1.analyze() - sum1) * smoothingFactor;

    float rms_scaled = sum1 * (height/2) * 5;

    ellipse(width/2, height/2, rms_scaled, rms_scaled);
    ellipse(width/2, height/2, rms_scaled/2, rms_scaled/2);
    ellipse(width/2, height/2, rms_scaled/25, rms_scaled/25);
    ellipse(width/2, height/2, rms_scaled/3, rms_scaled/3);
    ellipse(width/2, height/2, rms_scaled/4, rms_scaled/4);

    if (sample1.isPlaying() == false) { 
      sample1.play();
      // println("ok");
    }
  } else {
    sample1.stop();
  }


// animation pluie rose
  println(nya.isExistMarker(1));
  if (!nya.isExistMarker(1)) {
    for (int i = 0; i < drops.length; i++) {
      drops[i].show();
      drops[i].fall();
    }
    if (sample2.isPlaying() == false) { 
      sample2.play();
    }
  } else {
    sample2.stop();
  }


//animation bulles qui grandissent
  if (!nya.isExistMarker(2)) {
    sum4 += (rms4.analyze() - sum4) * smoothingFactor;
    if (rms4.analyze() > 0.05) baballes2.add(new Bulle2());
    for (int i = 0; i < baballes2.size(); i++) {
      Bulle2 b = baballes2.get(i);
      b.agrandir();
      b.afficher();
    }
    for (int i = baballes2.size() - 1; i >= 0; i--) {
      Bulle2 b = baballes2.get(i);
      if (b.is_alive == false) {
        baballes2.remove(i);
      }
    }

    if (sample4.isPlaying() == false) { 
      sample4.play();
    }
  } else {
    sample4.stop();
  }
  
  
  //animation cercle degrader rose --> blanc, en forme de losange
  if (!nya.isExistMarker(3)) {
    noStroke();
    fill(255, 100, 150);
    sum5 += (rms5.analyze() - sum5) * smoothingFactor;
    float rms_scaled = sum5 * (height/2) * 5;

    push();
    noFill();
    stroke(255, 70, 150);
    strokeWeight(3);
    ellipse(width * 0.4, height * 0.4, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(255, 70, 160);
    strokeWeight(3);
    ellipse(width * 0.35, height * 0.45, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(255, 70, 170);
    strokeWeight(3);
    ellipse(width * 0.3, height * 0.5, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(255, 70, 180);
    strokeWeight(3);
    ellipse(width * 0.25, height * 0.55, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(255, 70, 190);
    strokeWeight(3);
    ellipse(width * 0.3, height * 0.6, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(255, 70, 200);
    strokeWeight(3);
    ellipse(width * 0.35, height * 0.65, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(255, 70, 210);
    strokeWeight(3);
    ellipse(width * 0.40, height * 0.7, rms_scaled, rms_scaled);
    pop();

    //2 Gauche
    push();
    noFill();
    stroke(255, 70, 220);
    strokeWeight(3);
    ellipse(width * 0.45, height * 0.75, rms_scaled, rms_scaled);
    pop();

    // cercle du bas 
    push();
    noFill();
    stroke(255, 70, 230);
    strokeWeight(3);
    ellipse(width * 0.5, height * 0.80, rms_scaled, rms_scaled);
    pop();

    // 2 Droite
    push();
    noFill();
    stroke(255, 70, 220);
    strokeWeight(3);
    ellipse(width * 0.55, height * 0.75, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(255, 70, 210);
    strokeWeight(3);
    ellipse(width * 0.6, height * 0.7, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(255, 70, 200);
    strokeWeight(3);
    ellipse(width * 0.65, height * 0.65, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(255, 70, 190);
    strokeWeight(3);
    ellipse(width * 0.7, height * 0.6, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(255, 70, 180);
    strokeWeight(3);
    ellipse(width * 0.75, height * 0.55, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(255, 70, 170);
    strokeWeight(3);
    ellipse(width * 0.7, height * 0.5, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(255, 70, 160);
    strokeWeight(3);
    ellipse(width * 0.65, height * 0.45, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(255, 70, 150);
    strokeWeight(3);
    ellipse(width * 0.6, height * 0.4, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(255, 70, 140);
    strokeWeight(3);
    ellipse(width * 0.55, height * 0.35, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(255, 70, 130);
    strokeWeight(3);
    ellipse(width * 0.5, height * 0.3, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(255, 70, 140);
    strokeWeight(3);
    ellipse(width * 0.45, height * 0.35, rms_scaled, rms_scaled);
    pop();

    if (sample5.isPlaying() == false) { 
      sample5.play();
    }
  } else {
    sample5.stop();
  }

  //annimation cercles en vertical (qui s'agrandissent) , degradé de bleu violet.
  if (!nya.isExistMarker(4)) {

    noStroke();
    fill(255, 100, 150);
    sum6 += (rms6.analyze() - sum6) * smoothingFactor;
    float rms_scaled = sum6 * (height/2) * 5;

    push();
    noFill();
    stroke(120, 30, 200);
    strokeWeight(7);
    ellipse(width * 0.5, height * 0.4, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(120, 30, 200);
    strokeWeight(7);
    ellipse(width * 0.5, height * 0.65, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(55, 50, 250);
    strokeWeight(3);
    ellipse(width * 0.5, height * 0.45, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(55, 80, 250);
    strokeWeight(3);
    ellipse(width * 0.5, height * 0.55, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(55, 90, 250);
    strokeWeight(3);
    ellipse(width * 0.5, height * 0.6, rms_scaled, rms_scaled);
    pop();


    push();
    noFill();
    stroke(55, 160, 250);
    strokeWeight(3);
    ellipse(width * 0.5, height * 0.5, rms_scaled, rms_scaled);
    pop();

    if (sample6.isPlaying() == false) { 
      sample6.play();
    }
  } else {
    sample6.stop();
  }

  //animation oscillation bleue
  if (!nya.isExistMarker(5)) {
    float amp = ampl.analyze();

    stroke(49, 215, 255);
    strokeWeight(1);
    strokeJoin(ROUND);
    noFill();
    float scale = map(amp, 0, 1, -height/5, height/5);

    beginShape();
    for (int x = 0; x < width; x+=10) {
      float y = random(-1, 1)*scale + height/2;   
      vertex(x, y);
    }
    endShape();

    noStroke();
    fill(196, 88, 255);

    //randomSeed(actRandomSeed);
    for (int x = 0; x < width; x+=5) {
      float y = random(-1, 1)* (scale * 2) + height/2;   
      ellipse(x, y, 3, 3);
    }

    if (kick.isPlaying() == false) { 
      kick.play();
    }
  } else {
    kick.stop();
  }

//animation cercle qui s'agrandissent
  if (!nya.isExistMarker(6)) {

    sum7 += (rms7.analyze() - sum7) * smoothingFactor;
    if (rms7.analyze() > 0.5) baballes.add(new Bulle());
    for (int i = 0; i < baballes.size(); i++) {
      Bulle b = baballes.get(i);
      b.agrandir();
      b.afficher();
    }
    for (int i = baballes.size() - 1; i >= 0; i--) {
      Bulle b = baballes.get(i);
      if (b.is_alive == false) {
        baballes.remove(i);
      }
    }
    if (sample7.isPlaying() == false) { 
      sample7.play();
    }
  } else {
    sample7.stop();
  }

//animation groupe de rectangles en diagonales qui changent de taille rose, blanc, bleu
  if (!nya.isExistMarker(7)) {

    noStroke();
    sum8 += (rms8.analyze() - sum8) * smoothingFactor;
    float rms_scaled = sum8 * (height/2) * 5;

    push();
    noFill();
    stroke(190, 90, 200);
    strokeWeight(2);
    rect(width * 0.1, height * 0.1, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(180, 80, 200);
    strokeWeight(2);
    rect(width * 0.11, height * 0.11, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(170, 70, 200);
    strokeWeight(2);
    rect(width * 0.12, height * 0.12, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(160, 60, 200);
    strokeWeight(2);
    rect(width * 0.13, height * 0.13, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(150, 50, 200);
    strokeWeight(2);
    rect(width * 0.14, height * 0.14, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(150, 50, 200);
    strokeWeight(2);
    rect(width * 0.2, height * 0.2, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(140, 40, 200);
    strokeWeight(2);
    rect(width * 0.21, height * 0.21, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(130, 30, 200);
    strokeWeight(2);
    rect(width * 0.22, height * 0.22, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(120, 20, 200);
    strokeWeight(2);
    rect(width * 0.23, height * 0.23, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(110, 10, 200);
    strokeWeight(2);
    rect(width * 0.24, height * 0.24, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(180, 150, 220);
    strokeWeight(2);
    rect(width * 0.31, height * 0.31, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(200, 180, 240);
    strokeWeight(2);
    rect(width * 0.32, height * 0.32, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(250, 250, 250);
    strokeWeight(2);
    rect(width * 0.33, height * 0.33, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(180, 200, 240);
    strokeWeight(2);
    rect(width * 0.34, height * 0.34, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(150, 180, 220);
    strokeWeight(2);
    rect(width * 0.35, height * 0.35, rms_scaled, rms_scaled);
    pop();


    push();
    noFill();
    stroke(110, 110, 250);
    strokeWeight(2);
    rect(width * 0.4, height * 0.4, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(100, 100, 240);
    strokeWeight(2);
    rect(width * 0.41, height * 0.41, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(90, 90, 230);
    strokeWeight(2);
    rect(width * 0.42, height * 0.42, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(80, 80, 220);
    strokeWeight(2);
    rect(width * 0.43, height * 0.43, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(70, 70, 210);
    strokeWeight(2);
    rect(width * 0.44, height * 0.44, rms_scaled, rms_scaled);
    pop();


    push();
    noFill();
    stroke(60, 60, 200);
    strokeWeight(2);
    rect(width * 0.5, height * 0.5, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(50, 50, 190);
    strokeWeight(2);
    rect(width * 0.51, height * 0.51, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(40, 40, 180);
    strokeWeight(2);
    rect(width * 0.52, height * 0.52, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(30, 30, 170);
    strokeWeight(2);
    rect(width * 0.53, height * 0.53, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(20, 20, 160);
    strokeWeight(2);
    rect(width * 0.54, height * 0.54, rms_scaled, rms_scaled);
    pop();


    if (sample8.isPlaying() == false) { 
      sample8.play();
    }
  } else {
    sample8.stop();
  }

//animation ligne de rectangles en haut et bas de page qui change de taille
  if (!nya.isExistMarker(8)) {
    noStroke();
    sum9 += (rms9.analyze() - sum9) * smoothingFactor;
    float rms_scaled = sum9 * (height/-0.8) * 4;
    float rms_scal = sum9 * (height/0.8) * 4;

    push();
    noFill();
    stroke(180, 10, 250);
    strokeWeight(2);
    rect(width * 0.35, height * 0.9, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(190, 20, 240);
    strokeWeight(2);
    rect(width * 0.36, height * 0.9, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(175, 40, 230);
    strokeWeight(2);
    rect(width * 0.37, height * 0.9, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(65, 20, 200);
    strokeWeight(3);
    rect(width * 0.38, height * 0.9, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(70, 30, 210);
    strokeWeight(3);
    rect(width * 0.39, height * 0.9, rms_scaled, rms_scaled);
    pop();


    push();
    noFill();
    stroke(60, 60, 200);
    strokeWeight(3);
    rect(width * 0.5, height * 0.9, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(50, 50, 190);
    strokeWeight(3);
    rect(width * 0.51, height * 0.9, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(165, 20, 200);
    strokeWeight(2);
    rect(width * 0.52, height * 0.9, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(170, 30, 230);
    strokeWeight(2);
    rect(width * 0.53, height * 0.9, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(170, 30, 210);
    strokeWeight(2);
    rect(width * 0.54, height * 0.9, rms_scaled, rms_scaled);
    pop();



    push();
    noFill();
    stroke(250, 250, 250);
    strokeWeight(4);
    rect(width * 0.63, height * 0.9, rms_scaled, rms_scaled);
    pop();



    push();
    noFill();
    stroke(180, 50, 220);
    strokeWeight(2);
    rect(width * 0.71, height * 0.9, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(200, 80, 240);
    strokeWeight(2);
    rect(width * 0.72, height * 0.9, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(70, 40, 240);
    strokeWeight(3);
    rect(width * 0.73, height * 0.9, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(80, 40, 210);
    strokeWeight(3);
    rect(width * 0.74, height * 0.9, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(50, 20, 220);
    strokeWeight(3);
    rect(width * 0.75, height * 0.9, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(55, 20, 200);
    strokeWeight(3);
    rect(width * 0.81, height * 0.9, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(70, 80, 240);
    strokeWeight(3);
    rect(width * 0.82, height * 0.9, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(50, 50, 210);
    strokeWeight(3);
    rect(width * 0.83, height * 0.9, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(180, 20, 240);
    strokeWeight(2);
    rect(width * 0.84, height * 0.9, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(160, 10, 220);
    strokeWeight(2);
    rect(width * 0.85, height * 0.9, rms_scaled, rms_scaled);
    pop();
    push();
    noFill();
    stroke(55, 20, 200);
    strokeWeight(3);
    rect(width * 0.91, height * 0.9, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(70, 80, 240);
    strokeWeight(3);
    rect(width * 0.92, height * 0.9, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(50, 50, 210);
    strokeWeight(3);
    rect(width * 0.93, height * 0.9, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(180, 20, 240);
    strokeWeight(2);
    rect(width * 0.94, height * 0.9, rms_scaled, rms_scaled);
    pop();

    push();
    noFill();
    stroke(160, 10, 220);
    strokeWeight(2);
    rect(width * 0.95, height * 0.9, rms_scaled, rms_scaled);
    pop();




    push();
    noFill();
    stroke(180, 10, 250);
    strokeWeight(2);
    rect(width * 0.05, height * 0.1, rms_scal, rms_scal);
    pop();

    push();
    noFill();
    stroke(190, 20, 240);
    strokeWeight(2);
    rect(width * 0.06, height * 0.1, rms_scal, rms_scal);
    pop();

    push();
    noFill();
    stroke(175, 40, 230);
    strokeWeight(2);
    rect(width * 0.07, height * 0.1, rms_scal, rms_scal);
    pop();

    push();
    noFill();
    stroke(65, 20, 200);
    strokeWeight(3);
    rect(width * 0.08, height * 0.1, rms_scal, rms_scal);
    pop();

    push();
    noFill();
    stroke(70, 30, 210);
    strokeWeight(3);
    rect(width * 0.09, height * 0.1, rms_scal, rms_scal);
    pop();


    push();
    noFill();
    stroke(60, 60, 200);
    strokeWeight(3);
    rect(width * 0.2, height * 0.1, rms_scal, rms_scal);
    pop();

    push();
    noFill();
    stroke(50, 50, 190);
    strokeWeight(3);
    rect(width * 0.21, height * 0.1, rms_scal, rms_scal);
    pop();

    push();
    noFill();
    stroke(165, 20, 200);
    strokeWeight(2);
    rect(width * 0.22, height * 0.1, rms_scal, rms_scal);
    pop();

    push();
    noFill();
    stroke(170, 30, 230);
    strokeWeight(2);
    rect(width * 0.23, height * 0.1, rms_scal, rms_scal);
    pop();

    push();
    noFill();
    stroke(170, 30, 210);
    strokeWeight(2);
    rect(width * 0.24, height * 0.1, rms_scal, rms_scal);
    pop();



    push();
    noFill();
    stroke(250, 250, 250);
    strokeWeight(4);
    rect(width * 0.33, height * 0.1, rms_scal, rms_scal);
    pop();



    push();
    noFill();
    stroke(180, 50, 220);
    strokeWeight(2);
    rect(width * 0.41, height * 0.1, rms_scal, rms_scal);
    pop();

    push();
    noFill();
    stroke(200, 80, 240);
    strokeWeight(2);
    rect(width * 0.42, height * 0.1, rms_scal, rms_scal);
    pop();

    push();
    noFill();
    stroke(70, 40, 240);
    strokeWeight(3);
    rect(width * 0.43, height * 0.1, rms_scal, rms_scal);
    pop();

    push();
    noFill();
    stroke(80, 40, 210);
    strokeWeight(3);
    rect(width * 0.44, height * 0.1, rms_scal, rms_scal);
    pop();

    push();
    noFill();
    stroke(50, 20, 220);
    strokeWeight(3);
    rect(width * 0.45, height * 0.1, rms_scal, rms_scal);
    pop();

    push();
    noFill();
    stroke(55, 20, 200);
    strokeWeight(3);
    rect(width * 0.51, height * 0.1, rms_scal, rms_scal);
    pop();

    push();
    noFill();
    stroke(70, 80, 240);
    strokeWeight(3);
    rect(width * 0.52, height * 0.1, rms_scal, rms_scal);
    pop();

    push();
    noFill();
    stroke(50, 50, 210);
    strokeWeight(3);
    rect(width * 0.53, height * 0.1, rms_scal, rms_scal);
    pop();

    push();
    noFill();
    stroke(180, 20, 240);
    strokeWeight(2);
    rect(width * 0.54, height * 0.1, rms_scal, rms_scal);
    pop();

    push();
    noFill();
    stroke(160, 10, 220);
    strokeWeight(2);
    rect(width * 0.55, height * 0.1, rms_scal, rms_scal);
    pop();

    push();
    noFill();
    stroke(55, 20, 200);
    strokeWeight(3);
    rect(width * 0.13, height * 0.1, rms_scal, rms_scal);
    pop();

    push();
    noFill();
    stroke(70, 80, 240);
    strokeWeight(3);
    rect(width * 0.14, height * 0.1, rms_scal, rms_scal);
    pop();

    push();
    noFill();
    stroke(50, 50, 210);
    strokeWeight(3);
    rect(width * 0.15, height * 0.1, rms_scal, rms_scal);
    pop();

    push();
    noFill();
    stroke(180, 20, 240);
    strokeWeight(2);
    rect(width * 0.16, height * 0.1, rms_scal, rms_scal);
    pop();

    push();
    noFill();
    stroke(160, 10, 220);
    strokeWeight(2);
    rect(width * 0.17, height * 0.1, rms_scal, rms_scal);
    pop();

    if (sample9.isPlaying() == false) { 
      sample9.play();
    }
  } else {
    sample9.stop();
  }



  /* truc à copier coller pour relier chaque animation à un marker
   if (!nya.isExistMarker(1)) {
   
   if (sample2.isPlaying() == false) { 
   sample2.play();
   }
   } else {
   sample2.stop();
   }
   
  */
   
   
//Repères des markers permettant une meilleure visibilité pour la reconnaissance via la webcam
  fill(40, 40, 40, 255);
  noStroke();
  rect(870, 650, 110, 85);
  
  fill(40, 40, 40, 255);
  rect(870, 300, 110, 85);
  
  fill(40, 40, 40, 255);
  rect(470, 400, 110, 85);
  
  fill(40, 40, 40, 255);
  rect(670, 500, 110, 85);
  
  fill(40, 40, 40, 255);
  rect(670, 150, 110, 85);
  
  fill(40, 40, 40, 255);
  rect(1070, 50, 110, 85);
  
  fill(40, 40, 40, 255);
  rect(1270, 250, 110, 85);
  
  fill(40, 40, 40, 255);
  rect(1470, 450, 110, 85);
  
  fill(40, 40, 40, 255);
  rect(1170, 600, 110, 85);
  
  fill(40, 40, 40, 255);
  rect(380, 680, 110, 85);
  //fill(0,0,0,255);
  //rect(0, 0, width, height);
}

//création du push et pop qu'on utilise dans bcp d'animations en p5js
void push() { 
  pushMatrix();
  pushStyle();
}
void pop() {
  popMatrix();
  popStyle();
}

// bises, amusez vous bien !
