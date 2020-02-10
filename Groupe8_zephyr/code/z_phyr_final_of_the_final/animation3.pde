// ANIMATION ANEMONE BLEUE 
final int nbWeeds = 100;
SeaWeed[] weeds;
PVector rootNoise = new PVector(random(123456), random(123456));
float radius = 180, bott = 600;
Boolean noiseOn = false;
PVector center, mouse;
float mouseDist, targetMouseDist;//mouse interaction distance
PVector targetSpeed = new PVector(0, 0);
float a = 480;
int touchCount;

// fonction setup - lancement animation 3
void init_animation3() {
  center = new PVector(width/2, height/2);
  weeds = new SeaWeed[nbWeeds];
  for (int i = 0; i < nbWeeds; i++) {
    weeds[i] = new SeaWeed(i*TWO_PI/nbWeeds, 1*radius);
  }
}

// fonction draw - définition de couleur du fond de la page, 
void loop_animation3() {
  background(0);
  noStroke();
  fill(20, 10, 20);//, 50);
  rect(0, 0, width, height);
  rootNoise.add(new PVector(.01, .01));
  strokeWeight(1);
  
  // définission de la variable d qui correspond à la position des mains dans l'espace
  // pHandX/HandY = ancienne position et handX/handY = position actuelle 
  float d = dist(handX, handY, pHandX, pHandY);
  //float d = 10;
  targetMouseDist = 3 * d;
  if (d > 0) {
    mouseDist = min(mouseDist + d/10, 50);
  } else {
    mouseDist = max(mouseDist - 1, 0);
  }
   // Définition du mouvement de l'anémone qui dépend du mouvement des mains
  mouse = new PVector(handX, handY);
  float tmpa = 0;
  PVector targetCenter;
  if (mousePressed) {
    targetCenter = mouse.get();
    targetSpeed = targetCenter.get();
    targetSpeed.sub(center);
    targetSpeed.mult(.06);
  } else {
    int tmpTouchCount = constrain(touchCount, 0, 20);
    tmpa = a + (bott-a) * map(tmpTouchCount, 0, 20, 1, 0);
    targetSpeed.y += (tmpa - center.y) * .001;
    targetSpeed.mult(.97);
  }
  center.add(targetSpeed);
  if (center.y > bott) {
    center.y = bott;
    targetSpeed.y *= -1;
  }

  touchCount = 0;
  println(nbWeeds);
  for (int i = 0; i < nbWeeds; i++) {
    weeds[i].update();
  }
}






/*void keyPressed() {
 if (key == 'n') {
 noiseOn = !noiseOn;
 }
 }*/


// Définition des couleurs des différentes branches de l'anémone
class MyColor
{
  float R, G, B, Rspeed, Gspeed, Bspeed;
  final static float minSpeed = .6;
  final static float maxSpeed = 1.8;
  final static float minR = 20;
  final static float maxR = 85;
  final static float minG = 198;
  final static float maxG = 255;
  final static float minB = 200;
  final static float maxB = 212;

  MyColor()
  {
    init();
  }

  public void init()
  {
    R = random(minR, maxR);
    G = random(minG, maxG);
    B = random(minB, maxB);
    Rspeed = (random(1) > .5 ? 1 : -1) * random(minSpeed, maxSpeed);
    Gspeed = (random(1) > .5 ? 1 : -1) * random(minSpeed, maxSpeed);
    Bspeed = (random(1) > .5 ? 1 : -1) * random(minSpeed, maxSpeed);
  }

  public void update()
  {
    Rspeed = ((R += Rspeed) > maxR || (R < minR)) ? -Rspeed : Rspeed;
    Gspeed = ((G += Gspeed) > maxG || (G < minG)) ? -Gspeed : Gspeed;
    Bspeed = ((B += Bspeed) > maxB || (B < minB)) ? -Bspeed : Bspeed;
  }

  public color getColor()
  {
    return color(R, G, B);
  }
}

class SeaWeed {
  final static float DIST_MAX = 3;//length of each segment
  final static float FLOTATION = -7.5;//flotation constant
  int nbSegments;
  PVector[] pos;//position of each segment
  float[] thetas;
  color[] cols;//colors array, one per segment
  MyColor myCol = new MyColor();
  float x, y;//origin of the weed
  float baseTheta;

  SeaWeed(float p_rad, float p_length) {
    nbSegments = (int)(p_length/DIST_MAX);
    pos = new PVector[nbSegments];
    cols = new color[nbSegments];
    thetas = new float[nbSegments];
    baseTheta = p_rad;
    float cosi = cos(baseTheta);
    float sinu = sin(baseTheta);
    x = center.x;
    y = center.y;
    pos[0] = new PVector(x, y);
    for (int i = 1; i < nbSegments; i++) {
      pos[i] = new PVector(pos[i-1].x - DIST_MAX*cosi, pos[i-1].y - DIST_MAX*sinu);
      cols[i] = myCol.getColor();
      float qqq = noise(pos[i].x/22, pos[i].y/22);
      qqq = map(qqq, 0, 1, -PI/3, PI/3) * map(i, 0, nbSegments-1, 0, 1);
      thetas[i] = 0;//qqq;
    }
  }

  void update() {
    pos[0] = center.get();
    Boolean touched = false;
    for (int i = 1; i < nbSegments; i++) {
      if (noiseOn) {
        float n = noise(rootNoise.x + .002 * pos[i].x, rootNoise.y + .002 * pos[i].y);
        float noiseForce = (.5 - n) * 7;
        pos[i].x += noiseForce;
        pos[i].y += noiseForce;
      }
      PVector pv = new PVector(cos(baseTheta+thetas[i]), sin(baseTheta+thetas[i]));
      pv.mult(map(i, 1, nbSegments, FLOTATION, .6*FLOTATION));
      pos[i].add(pv);

      if (!mousePressed) {
        float d = PVector.dist(mouse, pos[i]);
        if (d < mouseDist) {// && pmouseX != mouseX && abs(pmouseX - mouseX) < 12)
          PVector tmpPV = mouse.get();       
          tmpPV.sub(pos[i]);
          tmpPV.normalize();
          tmpPV.mult(mouseDist);
          tmpPV = PVector.sub(mouse, tmpPV);
          pos[i] = tmpPV.get();
        }
      }

      PVector tmp = PVector.sub(pos[i-1], pos[i]);
      tmp.normalize();
      tmp.mult(DIST_MAX);
      tmp.rotate(thetas[i]);
      pos[i] = PVector.sub(pos[i-1], tmp);

      if (pos[i].y > bott) {
        touched = true;
        pos[i].y = bott;
      }
    }

    if (touched) {
      touchCount += 1;
    }

    updateColors();
    
    // début de la forme
    beginShape();
    noFill(); 
    println("anemone");
    for (int i = 0; i < nbSegments; i++) { 
      stroke(cols[i]);
      vertex(pos[i].x, pos[i].y);
    }
     // fin de la forme 
    endShape();
  }

  void updateColors() {
    myCol.update();
    cols[0] = myCol.getColor();
    for (int i = nbSegments-1; i > 0; i--) {
      cols[i] = cols[i-1];
    }
  }
}
