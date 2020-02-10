// ANIMATION AVEC DES CERCLES SUPERPOSES 

float R2 = 30;
float S = 10;
float T = 10;

int N = 5;

float ringX[] = new float[N];
float ringY[] = new float[N];
float ringK[] = new float[N];

// Fonction setup - lancement de l'animation 
void init_animation2() {
  for (int i = 0; i < N; i++) {
    ringX[i] = 0.5 * width;
    ringY[i] = 0.5 * height;
    ringK[i] = i + 1;
  }
}


// Fonction draw - définitions graphiques de l'animation : couleur, taille
void loop_animation2() {
  background(0);

  stroke(0x11, 0x11, 0x22);
  strokeWeight(2);
  
  // Définition de la position des mains
  for (Hand hand : leap.getHands ()) {
    PVector h = hand.getPosition();
    if (!paused)
      for (int i = 0; i < N; i++) {
        ringY[i] += 0.2 * (N - i) * (h.y - ringY[i]) / N;
      }

    for (int i = N - 1; i >= 0; i--) {
      fill(45, 108, 252);
      drawCurl(ringX[i], ringY[i], R2 * ringK[i], -S * ringK[i], T);
    }

    for (int i = 0; i < N; i++) {
      fill(124, 175, 252);
      drawCurl(ringX[i], ringY[i], R2 * ringK[i], +S * ringK[i], T);
    }
  }
}


// Définition des anneaux 
void drawCurl(float x, float y, float r, float s, float t) {
  pushMatrix();
  translate(x, y);
  beginShape();
  vertex(-r, -t);
  bezierVertex(-r, s - t, +r, s - t, +r, -t);
  vertex(+r, +t);
  bezierVertex(+r, s + t, -r, s + t, -r, +t);
  endShape(CLOSE);
  popMatrix();
}


boolean paused = false;
