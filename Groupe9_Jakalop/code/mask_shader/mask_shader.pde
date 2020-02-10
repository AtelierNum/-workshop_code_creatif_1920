// a shader variable
PShader mask;
// two Pgraphics objects to be blended
PGraphics top_pg;
PImage maskImage;


import processing.serial.*; //import de la bibliotèque serialpour le microbit
Serial port;  
MicroSensor micro;

  
  int timer;
  int moveDetect;
  int animNumber = 1;
  
  import processing.sound.*; // import de la bibliothèque son
  SoundFile file; //fichier son
  WhiteNoise noise;//bruit blanc
  LowPass lowPass;// filtre passe bas
  



void setup() {

  // initialisation de la communication via usb depuis arduino
  // ATTENTION à bien utiliser le port adapté
  printArray(Serial.list());
  String portName = Serial.list()[5]; //<= bien utiliser le bon numéro de port ici !!
  port = new Serial(this, portName, 115200);
  micro = new MicroSensor(port);
  
  file = new SoundFile(this, "data/1.wav"); //selection fichier son
  file.play(); // lecture du son
  
   noise = new WhiteNoise(this); // variable bruit blanc
  lowPass = new LowPass(this); // variable filtre passe bas



  size(1280, 800, P3D);
  mask = loadShader("mask.frag");
  top_pg = createGraphics(width, height, P3D);
  maskImage = loadImage("mask.png");
  mask.set("sketchSize", float( width ), float( height ));
  mask.set( "topLayerResolution", float( width ), float( height ) );
  mask.set( "maskResolution", float( height ), float( height ) );
  frameRate(200);
}

void draw() {
 

  micro.update(); // mise a jour des infos envoyé par le microbit

  int move = micro.getXAccel(); // variable récuperant l' accelération sur l'axe X

  
  if(move < 0){  //permet d'avoir une valeur de l'acceleration toujours positive
    move = move*-1;}
    
      
  
  timer = timer + 1; // timer qui s'execute toute les rafraichissement
  
  if(timer == 10){
    timer = 0;
    moveDetect = move; // toute les 10 frames on met a jour la valeur de detection de l'acceleration et on remet le timer à 0
    
    

  }
  
      if((move - moveDetect) > 16){ //si la valeur actuelle de l'accelerometre et différente de celle d'il y a 10 frame alors on change la valeur du numéro de l'animation
      animNumber = animNumber + 1;
      if(animNumber == 4){
        animNumber = 1;
      
    }
    
    
  }


  
  
  
  if(animNumber == 1){ //affichage de l'annimation si son numéro est le bon
    
  noise.play(0.5);
  lowPass.process(noise, 800);
  
    top_pg.beginDraw();
    
    background(0);

  int d1 = 5;
  top_pg.fill(0, 30);
  top_pg.rect(0, 0, width, height);
  top_pg.fill(0, 255, 255);
  top_pg.noStroke();
 


  for (float y = d1/2; y < height; y += d1/2) { // y +=4 equivalant à y = y
    float angle = radians(frameCount+y)*0.5;
    float x = width/2 + width/2 * sin(angle)* sin(y);
    top_pg.rect(x + sin(angle), y + sin(angle), d1 * sin(angle), d1 * sin(angle));
  }

  top_pg.endDraw();
  
  }
  
   if(animNumber == 2){ //affichage de l'annimation si son numéro est le bon
     
       noise.play(0.8); //modification de la quantité de bruit
      lowPass.process(noise, 500);// modification dela fréquence du filtre passe bas
     
     top_pg.beginDraw(); //utilisation du calque top_pg qui est sous le masque pour les animation
     
     background(0);
     
     top_pg.lights();
     
     int d2  = 10;
     
    top_pg.fill(0, 50);
    top_pg.rect(0, 0, width, height);
    top_pg.fill(255, 255, 0);
    top_pg.stroke(125,50,150);
  
  for (float y = d2/2; y < height; y += d2/2) { // y +=4 equivalant à y = y
    float angle = radians(frameCount+y)*0.5;
    float x = width/2 + width/2 * sin(angle)* sin(y);
    top_pg.rect(x - sin(angle), y - sin(angle), d2 * sin(angle) , d2 * sin(angle));
  }
  
    top_pg.pushMatrix();
    top_pg.translate(width/2, height/2, +400);
    top_pg.rotateZ(radians(random(0,360)));
    top_pg.noFill();
    top_pg.stroke(100,25,125, 100);
    top_pg.strokeWeight(2);
    top_pg.sphere(280);
    top_pg.popMatrix();
    
    top_pg.pushMatrix();
    top_pg.translate(width/2, height/2, +400);
    top_pg.rotateZ(radians(random(0,360)));
    top_pg.noFill();
    top_pg.stroke(255, 255, 0, 50);
    top_pg.strokeWeight(2);
    top_pg.sphere(280);
    top_pg.popMatrix();
         
         
     top_pg.endDraw();
   
   }
   
   if(animNumber == 3){ //affichage de l'annimation si son numéro est le bon
     
       noise.play(0.1);
       lowPass.process(noise, 200);
       
       
     top_pg.beginDraw();
   
    background(0);
  int d3 = 50;
  top_pg.fill(0, 30);
  top_pg.rect(0, 0, width, height);
  top_pg.fill(250, 0, 255);
  top_pg.noStroke();
  
  for (float y = d3/50; y < height; y += d3/50) { // y +=4 equivalant à y = y
    float angle = radians(frameCount+y);
    float x = width/2 + width/2 * sin(angle)* sin(y);
    top_pg.rect(x + sin(angle), y + sin(angle), d3 * sin(angle) , d3 * sin(angle));
  }
  
  top_pg.endDraw();
   
   }
  
  

  mask.set("topLayer", top_pg);
  mask.set("maskImage", maskImage);


  shader(mask);
  // Draw the output of the shader onto a rectangle that covers the whole viewport
  rect(0, 0, width, height);
  // Call resetShader() so that further geometry remains unaffected by the shader
  resetShader();
}
