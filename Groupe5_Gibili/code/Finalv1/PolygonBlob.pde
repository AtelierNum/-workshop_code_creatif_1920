import java.util.Collections;
class PolygonBlob extends Polygon2D {
  Body body;
 
  //La forme de lq personne
  void createPolygon() {
    ArrayList<ArrayList<PVector>> contours = new ArrayList<ArrayList<PVector>>();
    int selectedContour = 0;
    int selectedPoint = 0;
 
    // Crée les contours du blob
    for (int n=0 ; n<theBlobDetection.getBlobNb(); n++) {
      Blob b = theBlobDetection.getBlob(n);
      if (b != null && b.getEdgeNb() > 100) {
        ArrayList<PVector> contour = new ArrayList<PVector>();
        for (int m=0; m<b.getEdgeNb(); m++) {
          EdgeVertex eA = b.getEdgeVertexA(m);
          EdgeVertex eB = b.getEdgeVertexB(m);
          if (eA != null && eB != null) {
            EdgeVertex fn = b.getEdgeVertexA((m+1) % b.getEdgeNb());
            EdgeVertex fp = b.getEdgeVertexA((max(0, m-1)));
            float dn = dist(eA.x*kinectWidth, eA.y*kinectHeight, fn.x*kinectWidth, fn.y*kinectHeight);
            float dp = dist(eA.x*kinectWidth, eA.y*kinectHeight, fp.x*kinectWidth, fp.y*kinectHeight);
            if (dn > 15 || dp > 15) {
              if (contour.size() > 0) {
                contour.add(new PVector(eB.x*kinectWidth, eB.y*kinectHeight));
                contours.add(contour);
                contour = new ArrayList<PVector>();
              } else {
                contour.add(new PVector(eA.x*kinectWidth, eA.y*kinectHeight));
              }
            } else {
              contour.add(new PVector(eA.x*kinectWidth, eA.y*kinectHeight));
            }
          }
        }
      }
    }
    
    while (contours.size() > 0) {
      
      // find next contour
      float distance = 999999999;
      if (getNumPoints() > 0) {
        Vec2D vecLastPoint = vertices.get(getNumPoints()-1);
        PVector lastPoint = new PVector(vecLastPoint.x, vecLastPoint.y);
        for (int i=0; i<contours.size(); i++) {
          ArrayList<PVector> c = contours.get(i);
          PVector fp = c.get(0);
          PVector lp = c.get(c.size()-1);
          if (fp.dist(lastPoint) < distance) { 
            distance = fp.dist(lastPoint); 
            selectedContour = i; 
            selectedPoint = 0;
          }
          if (lp.dist(lastPoint) < distance) { 
            distance = lp.dist(lastPoint); 
            selectedContour = i; 
            selectedPoint = 1;
          }
        }
      } else {
        PVector closestPoint = new PVector(width, height);
        for (int i=0; i<contours.size(); i++) {
          ArrayList<PVector> c = contours.get(i);
          PVector fp = c.get(0);
          PVector lp = c.get(c.size()-1);
          if (fp.y > kinectHeight-5 && fp.x < closestPoint.x) { 
            closestPoint = fp; 
            selectedContour = i; 
            selectedPoint = 0;
          }
          if (lp.y > kinectHeight-5 && lp.x < closestPoint.y) { 
            closestPoint = lp; 
            selectedContour = i; 
            selectedPoint = 1;
          }
        }
      }
 
      // Ajoute des contours
      ArrayList<PVector> contour = contours.get(selectedContour);
      if (selectedPoint > 0) { Collections.reverse(contour); }
      for (PVector p : contour) {
        add(new Vec2D(p.x, p.y));
      }
      contours.remove(selectedContour);
    }
  }
 
  // Crée les application physique sur le body
 void createBody() {
    // Pour toujours recréer le body
    BodyDef bd = new BodyDef();
    body = box2d.createBody(bd);
    // S' il y a plus d'une personne
    if (getNumPoints() > 0) {
      // create a vec2d array of vertices in box2d world coordinates from this polygon
      // Crée une liste Vec2D de vecteurs dans les coordonnées du monde de box2D pour le blob
      Vec2[] verts = new Vec2[getNumPoints()/2];
      for (int i=0; i<getNumPoints()/2; i++) {
        Vec2D v = vertices.get(i*2);
        verts[i] = box2d.coordPixelsToWorld(v.x, v.y);
      }
      // Crée une chaine depuis la liste
      ChainShape chain = new ChainShape();
      chain.createChain(verts, verts.length);
      // create fixture in body from the chain (this makes it actually deflect other shapes)
      body.createFixture(chain, 1);
    }
  }
 
  // Détruis le body
  void destroyBody() {
    box2d.destroyBody(body);
  }
}
