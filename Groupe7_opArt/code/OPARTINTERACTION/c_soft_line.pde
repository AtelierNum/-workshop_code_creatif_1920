class Soft_line {

  int resolution;
  Node [] nodes;
  Spring [] springs;
  float x1, y1, x2, y2;


  Soft_line(float x1, float y1, float x2, float y2, int resolution) {
    this.resolution = resolution ;
    nodes = new Node [resolution];
    springs = new Spring [resolution-1];

    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;

    for (int i = 0 ; i <resolution ; i++) {
      if (i==0) {
        nodes[i] = new Node(x1, y1 );
      }
      else {
        nodes[i] = new Node(abs(x2)*i/resolution, abs(y2)*i/resolution);
        //  nodes[i].setBoundary((x2-x1)*i/resolution -150, (y2-y1)*i/resolution-150, 
        //                       (x2-x1)*i/resolution*i/5+150, (y2-y1)*i/resolution+150);
        nodes[i].setDamping(0.09);
        //nodes[i].setRadius(50);
        // nodes[i].setStrength(25);
        springs[i-1] = new Spring(nodes[i], nodes[i-1]);
        springs[i-1].setStiffness(1);
        springs[i-1].setDamping(0.09);
        PVector p1 = new PVector(nodes[i].location.x, nodes[i].location.y);
        PVector p2 = new PVector(nodes[i-1].location.x, nodes[i-1].location.y);
       // springs[i-1].setLength(dist(nodes[i].location.x, nodes[i].location.y, nodes[i-1].location.x, nodes[i-1].location.y)*6/9);
        springs[i-1].setLength(1);

        if (i == resolution-1) {
          nodes[resolution-1] = new Node (x2, y2);
        }
      }
    }
  }

  void run() {
    beginShape();
    curveVertex(x1, y1);
    for (int i = 0 ; i < resolution ; i++) {
      if (i!=0 && i!=resolution-1) {
        nodes[i].update();
        nodes[i].attract(nodes);
      }
      //   else {
      //  }    
      curveVertex(nodes[i].location.x, nodes[i].location.y);
    }
    curveVertex(x2, y2);
    endShape();
    /*
    for (int i = 0 ; i < resolution ; i++) {
      ellipse(nodes[i].location.x, nodes[i].location.y, 5, 5);
    }*/

    for (int i = 0 ; i < resolution-1 ; i++) {
      springs[i].update();
    }
  }
}
