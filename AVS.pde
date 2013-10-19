void drawAVSParticles() {
 
 for(int i=0; i<3; i++) {
    handleBoundaryCollisions(avs[i]);
  }
  
  fill(color(255, 0, 0, 100));
  ellipse(avs[0].position().x(), avs[0].position().y(), 25, 15);
  
  fill(color(0, 255, 0, 100));
  ellipse(avs[1].position().x(), avs[1].position().y(), 25, 15);
  
  fill(color(0, 0, 255, 100));
  ellipse(avs[2].position().x(), avs[2].position().y(), 25, 15);
  
}

void updateAVS(int sec) {
 
 int mill = millis();
  
 if(mill%500 == 0 && lastDistTrack != mill) {
   // -- record dist
   for(int i=0; i<3; i++) {
     distX[i] += avs[i].position().x();
     distY[i] += avs[i].position().y();
   }
   // --
   lastDistTrack = mill;
 }
  
 if(sec%5 == 0 && lastNeedUpdate != sec) {
    
    // -- update need
    theta += 5;
    if(theta > 360) theta = 0;
    lastNeedUpdate = sec;
    
    int theta_a = theta - 5;
    if(theta_a < 0) theta_a = 360; 
    
    int theta_b = theta + 5;
    if(theta_b > 360) theta_b = 0; 
    
    avsStrength[0] += (cos(theta_a)*4000);
    avsStrength[1] += (cos(theta)*4000);
    avsStrength[2] += (cos(theta_b)*4000);
    
    for(int i=0; i<3; i++) {
      for(int j=i+1; j<3; j++) {
        physics.makeAttraction(avs[i], avs[j], avsStrength[i], 20);
      }
    }
    
    println("theta: " + theta + " avs strength 0: " + avsStrength[0] + " 1: " + avsStrength[1] + " 2: " + avsStrength[2]); 
    
    // -- 
    
    // -- record disp
    for(int i=0; i<3; i++) {
      prevX[i] = avs[i].position().x()-(width/2);
      prevY[i] = avs[i].position().y()-(height/2);
      dispX[i] += prevX[i];
      dispY[i] += prevY[i];
    }
   // --
   
    // -- get away from corners
    int cornerArea = 50;
    
    for(int i=0; i<3; i++) {
      
      // top left
      if(avs[i].position().x() >= 0 && avs[i].position().x() <= cornerArea && avs[i].position().y() >= 0 && avs[i].position().y() <= cornerArea) {
        println("stuck top left");
        avs[i].velocity().add(25.0, -25.0, 0);
        lastStuck[i] = sec;
        stuckCount++;
      }
      
      // top right
      if(avs[i].position().x() >= (width-cornerArea) && avs[i].position().x() <= width && avs[i].position().y() >= 0 && avs[i].position().y() <= cornerArea) {
        println("stuck top right");
        avs[i].velocity().add(-25.0, -25.0, 0);
        lastStuck[i] = sec;
        stuckCount++;
      }
      
      // bottom left
      if(avs[i].position().x() >= 0 && avs[i].position().x() <= cornerArea && avs[i].position().y() >= (height-cornerArea) && avs[i].position().y() <= height) {
        println("stuck bottom left");
        avs[i].velocity().add(25.0, 25.0, 0);
        lastStuck[i] = sec;
        stuckCount++;
      }
      
      // bottom right
      if(avs[i].position().x() >= (width-cornerArea) && avs[i].position().x() <= width && avs[i].position().y() >= (height-cornerArea) && avs[i].position().y() <= height) {
        println("stuck bottom right");
        avs[i].velocity().add(-25.0, 25.0, 0);
        lastStuck[i] = sec;
        stuckCount++;
      }
      
    }
    
    if(stuckCount > 1 && stuckCount_0 > 0) {
      println("::: RESET :::");
      resetParticles();
    }
    
    stuckCount_0 = stuckCount;
    stuckCount = 0;
    
    // -- calc disp
    //println("disp x 0: " + dispX[0] + " 1: " + dispX[1] + " 2: " + dispX[2]);
    //println("disp y 0: " + dispY[0] + " 1: " + dispY[1] + " 2: " + dispY[2]);
    
    for(int i=0; i<3; i++) {
      dispTotal[i] = sqrt( (pow(dispX[i], 2) + pow(dispY[i], 2)) );
      dispX[i] = 0;
      dispY[i] = 0;
    }
    
    println("disp total: 0: " + dispTotal[0] + " 1: " + dispTotal[1] + " 2: " + dispTotal[2]);
    // --
    
    // -- add entropy
    boolean needEntropy = false;
    float addingVel = 5.0;
    
    if(abs(dispTotal[0]-dispTotal[1]) < 10.0) {// && abs(dispTotal[0]-dispTotal[1]) > 30.0) {
      
      println("changing entropy: 0 & 1");
      avs[0].velocity().add(-1*addingVel, -1*addingVel, 0);
      avs[1].velocity().add(addingVel, addingVel, 0);
      
    } else if(abs(dispTotal[1]-dispTotal[2]) < 10.0) {// && abs(dispTotal[1]-dispTotal[2]) < 30.0) {
      
      println("changing entropy: 1 & 2");
      avs[1].velocity().add(-1*addingVel, -1*addingVel, 0);
      avs[2].velocity().add(addingVel, addingVel, 0);
      
    } else if(abs(dispTotal[0]-dispTotal[2]) < 10.0) {// && abs(dispTotal[0]-dispTotal[2]) > 30.0) {
      
      println("changing entropy: 0 & 2");
      avs[0].velocity().add(-1*addingVel, -1*addingVel, 0);
      avs[2].velocity().add(addingVel, addingVel, 0);
      
    }
    // --
    
    numUpdates++;
    lastDispUpdate = sec;
    
  }
  
  
  if(sec%20 == 0 && lastDistUpdate != sec) {
    
    // -- calc dist
    for(int i=0; i<3; i++) {
      distTotal[i] = sqrt( (pow(distX[i], 2) + pow(distY[i], 2)) );
      distX[i] = 0;
      distY[i] = 0;
    }
    
    println("dist total: 0: " + distTotal[0] + " 1: " + distTotal[1] + " 2: " + distTotal[2]);
    // --
    
    lastDistUpdate = sec;
  }
  
  
}




void resetParticles() {
 
 for(int i=0; i<3; i++) {
    avs[i] = physics.makeParticle(1.0, random(0, width), random(0, height), 0);
  }
  
  for(int i=0; i<3; i++) {
    for(int j=i+1; j<3; j++) {
      physics.makeAttraction(avs[i], avs[j], avsStrength[i], 50);
    }
  }
  
  
  for(int i=0; i<6; i++) {
    robotA[i] = physics.makeParticle(1.0, random(0, width), random(0, height), 0);
  }
  
  for(int i=0; i<6; i++) {
    for(int j=0; j<3; j++) {
      physics.makeAttraction(robotA[i], avs[j], robotAStrength[i], 50);
    }
  }
  
}


