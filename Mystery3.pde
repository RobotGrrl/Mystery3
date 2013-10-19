/*
  Mystery
  -------
  Controlling a robot from a particle system
  
  Created by RobotGrrl
  robotgrrl.com
  
  CC BY-SA
*/

import traer.physics.*;


// -- PHYS -- //
ParticleSystem physics;


// -- AVS -- //
Particle avs[] = new Particle[3];
int avsStrength[] = {-2000, 0, 2000};
int theta = 0;
int lastNeedUpdate = 0;
int lastDistTrack = 0;
int numUpdates = 0;

int stuckCount = 0;
int stuckCount_0 = 0;

float prevX[] = {0, 0, 0};
float prevY[] = {0, 0, 0};
float dispX[] = {0, 0, 0};
float dispY[] = {0, 0, 0};
float dispTotal[] = {0, 0, 0};
float distX[] = {0, 0, 0};
float distY[] = {0, 0, 0};
float distTotal[] = {0, 0, 0};
int lastDispUpdate = 0;
int particleAddedEntropy = 0;
int lastAddEntropy = 0;
boolean entropyRemoved = true;
boolean addedEntropy = false;
int lastStuck[] = {0, 0, 0};
int newEntropy[] = {0, 0, 0};
int lastDistUpdate = 0;

// --

String ROBOT_ID_A = "930";
Particle robotA[] = new Particle[6];
int robotAStrength[] = {1000, 1000, 1000, 1000, 1000, 1000};
float robotADistance[][] = new float[6][3];
int lastRobotADist = 0;
int robotAProximityCount[] = {0, 0, 0};






// -- MISC -- //
int lastUpdate = 0;


void setup() {
  size(1000, 720);
  smooth();
  ellipseMode(CENTER);
  noStroke();
  //noCursor();

  physics = new ParticleSystem(0.0, 0.0);
  
  resetParticles();

}

void draw() {
  
  physics.tick();
  
  drawAVSParticles();
  
  fill(color(255, 255, 255, 100));
  for(int i=0; i<6; i++) {
    handleBoundaryCollisions(robotA[i]);
    ellipse(robotA[i].position().x(), robotA[i].position().y(), 10, 5);
  }
  
  
  int sec = second();
  
  updateAVS(sec);
  
  /*
  if(numUpdates%10 == 0 && numUpdates != 0) { // reset it all
  
  println("::: RESET :::");
  
  resetParticles();
  
  numUpdates++;
  
  }
  */
  
  
  
  
  
  // -- small particles
  
  
  if(sec%5 == 0 && lastRobotADist != sec) {
    
    // -- find proximity particles
    for(int i=0; i<6; i++) {
      for(int j=0; j<3; j++) {
        robotADistance[i][j] = sqrt( pow( abs( robotA[i].position().x()-avs[j].position().x() ) , 2) + pow( abs( robotA[i].position().y()-avs[j].position().y() ) , 2) );
        
        if(robotADistance[i][j] < 35.0) {
          robotAProximityCount[j] += 1;
        }
    
      }
    }
    // --
    
    lastRobotADist = sec;
  }
  
  
  
  if(sec%20 == 0 && lastUpdate != sec) {
    
    // -- count proximities
    
    /*
    for(int i=0; i<3; i++) {
      robotAProximityCount[i] /= 4; // 20/5 = 4
    }
    */
    
    println("proximity particles:  0: " + robotAProximityCount[0] + "  1: " + robotAProximityCount[1] + "  2: " + robotAProximityCount[2]);
    
    for(int i=0; i<3; i++) {
      robotAProximityCount[i] = 0;
    }
    
    // --
    
    lastUpdate = sec;
  }

  fill(color(0, 0, 0, 25));
  rect(0, 0, width, height);
  
}

void updateRobotAStrength(int sen, float val, float max, float min, float avg) {
  
  float mapped = 0;
  
  if(val < avg) {
    mapped = map(val, min, max, -1000, 0);
  } else {
    mapped = map(val, min, max, 0, 1000);
  }
  
  robotAStrength[sen] = (int)mapped;
  
  for(int j=0; j<3; j++) {
    physics.makeAttraction(robotA[sen], avs[j], robotAStrength[sen], 50);
  }
  
}


void calculateChangeAmount() {
  
  
  
}


void handleBoundaryCollisions( Particle p ) {
  if ( p.position().x() < 0 || p.position().x() > width ) {
    p.velocity().set(-0.9*p.velocity().x(), p.velocity().y(), 0);
  }
  if ( p.position().y() < 0 || p.position().y() > height ) {
    p.velocity().set(p.velocity().x(), -0.9*p.velocity().y(), 0);
  }
  p.position().set( constrain( p.position().x(), 0, width ), constrain( p.position().y(), 0, height ), 0 ); 
}

