// M_6_1_02.pde
// Spring.pde
// 
// Generative Gestaltung, ISBN: 978-3-87439-759-9
// First Edition, Hermann Schmidt, Mainz, 2009
// Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
// Copyright 2009 Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
//
// http://www.generative-gestaltung.de
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

// modified for js compatibility by berenger.recoules@gmail.com
class Spring {
  Node fromNode;
  Node toNode;

  float l = 9;
  float stiffness = 0.65;
  float damping = 0.1;

  // ------ constructors ------
  Spring(Node theFromNode, Node theToNode) {
    fromNode = theFromNode;
    toNode = theToNode;
  }

  Spring(Node theFromNode, Node theToNode, float theLength, float theStiffness, float theDamping) {
    fromNode = theFromNode;
    toNode = theToNode;

    l = theLength;
    stiffness = theStiffness;
    damping = theDamping;
  }

  // ------ apply forces on spring and attached nodes ------
  void update() {
    // calculate the target position
    // target = normalize(to - from) * length + from
    PVector diff = PVector.sub(toNode.location, fromNode.location);
    diff.normalize();
    diff.mult(l);
    PVector target = PVector.add(fromNode.location, diff);

    PVector force = PVector.sub(target, toNode.location);
    force.mult(0.5);
    force.mult(stiffness);
    force.mult(1 - damping);

    toNode.velocity.add(force);
    fromNode.velocity.add(PVector.mult(force, -1));
  }

  // ------ getters and setters ------
  Node getFromNode() {
    return fromNode;
  }

  void setFromNode(Node theFromNode) {
    fromNode = theFromNode;
  }

  Node getToNode() {
    return toNode;
  }

  void setToNode(Node theToNode) {
    toNode = theToNode;
  }

  float getLength() {
    return l;
  }

  void setLength(float theLength) {
    this.l= theLength;
  }

  float getStiffness() {
    return stiffness;
  }

  void setStiffness(float theStiffness) {
    this.stiffness = theStiffness;
  }

  float getDamping() {
    return damping;
  }

  void setDamping(float theDamping) {
    this.damping = theDamping;
  }
}
