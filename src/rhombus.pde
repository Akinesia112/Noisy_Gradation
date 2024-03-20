int squareSize = 2;
int cols = 800 / squareSize;
int rows = 1600 / squareSize;
int[][] colors = new int[rows*2][cols];
color startColor1 = color(0, 112, 128); // start Color1
color startColor2 = color(0, 128, 128); // start Color2
color startColor3 = color(0,128,145); // start Color3
// sin ***************** part1
float stretch = 140; //+-10up
float compression = 0.003; //+-0.001
float Xshift = 150; //+-10up
float Yshift = -300; //+-0.1
int range1 = 60; //+-10up
int range2 = 60; //+-10up
int noiseRange1 = 0; //X
int noiseRange2 = 0; //X
//***********************
// Add a new variable for the circle radius
float circleRadius = squareSize; // Initialize the radius to be the same as squareSize

// part2****************************
boolean sNoise_g = true;
float squareNoise = 60; // row1 Initialize square noise
float squareNoiseMax = 500; // sNoise_g = 2
// *******************************


// larger
// ellipse

// Update the drawSquareGrid function (or create a new function drawCircleGrid) to draw circles
void drawDiamondGrid() {
  for (int y = 0; y < rows*2; y++) {
    if(sNoise_g) squareNoise = map(y, 0, rows, 0, squareNoiseMax); // Gradually increase square noise from top to bottom
    for (int x = 0; x < cols; x++) {
      int grayValue = colors[y][x];
      
      fill(grayValue);
      noStroke();
      // Calculate a random offset for each diamond within a range to make them look staggered
      float offsetX = random(-squareSize, squareSize);
      float offsetY = random(-squareSize, squareSize);
      // Apply the offsets to the center position of each diamond
      float centerX = x * squareSize + squareSize / 2 + offsetX;
      float centerY = y * squareSize + squareSize / 2 + offsetY;
      
      // Draw the diamond by creating a rotated square
      pushMatrix(); // Save the current state of the coordinate system
      translate(centerX, centerY); // Move the origin to the center of the diamond
      rotate(QUARTER_PI); // Rotate the coordinate system by 45 degrees (PI/4)
      rectMode(CENTER); // Draw the square from its center
      rect(0, 0, squareSize, squareSize); // Draw the square, which appears as a diamond due to rotation
      popMatrix(); // Restore the original state of the coordinate system
    }
  }
}



// Now you can call the drawCircleGrid function in the setup to draw the circles on the grid
void setup() {
  size(800, 1600);
  background(255);
  initializeColors();
  // drawSquareGrid(); // Comment this out if you don't want squares
  // drawPentagonGrid(); // Comment this out if you don't want pentagons
  drawCircleGrid(); // Add this to draw circles
  drawCurve();
  save("sgridww5_" + squareSize + "_" + int(stretch) + "_" + compression + "_" + int(Xshift) + "_" + Yshift + "_" + range1 + "_" + range2 + "_" + noiseRange1 + "_" + noiseRange2 + ".png");
}

void initializeColors() {
  for (int y = 0; y < rows*2; y++) {
    for (int x = 0; x < cols; x++) {
      
      int baseGray = int(stretch * sin(y * compression + Yshift) + Xshift);
      int grayValue = baseGray + int(random(-range1, range2));
      
      grayValue = constrain(grayValue, 0, 255);
      
      //Color1+Color2+Color3
      //colors[y][x] = grayValue*startColor1+grayValue*startColor2+grayValue*startColor3;
      colors[y][x] = grayValue*startColor1;
    }
  }
}

void drawSquareGrid() {
  for (int y = 0; y < rows*2; y++) {
    if(sNoise_g) squareNoise = map(y, 0, rows, 0, squareNoiseMax); // Gradually increase square noise from top to bottom
    for (int x = 0; x < cols; x++) {
      int grayValue = colors[y][x];
      
      fill(grayValue); //****************
      noStroke();
      float adjustedX = x * squareSize + random(-squareNoise, squareNoise); // Adjust square position with noise
      float adjustedY = y * squareSize + random(-squareNoise, squareNoise); // Adjust square position with noise
      rect(adjustedX, adjustedY, squareSize, squareSize);

      //println(squareNoise); //******
    }
  }
}

void drawPentagonGrid() {
  float radius = squareSize / sqrt(2); // Approximate radius to fit pentagons within the grid
  for (int y = 0; y < rows*2; y++) {
    if(sNoise_g) squareNoise = map(y, 0, rows, 0, squareNoiseMax); // Gradually increase square noise from top to bottom
    for (int x = 0; x < cols; x++) {
      int grayValue = colors[y][x];
      
      fill(grayValue);
      noStroke();
      float centerX = x * squareSize + squareSize / 2 + random(-squareNoise, squareNoise); // Center of the pentagon
      float centerY = y * squareSize + squareSize / 2 + random(-squareNoise, squareNoise); // Center of the pentagon
      
      beginShape();
      for (int i = 0; i < 5; i++) { // Draw a pentagon
        float angle = TWO_PI / 5 * i;
        float vertexX = centerX + cos(angle) * radius;
        float vertexY = centerY + sin(angle) * radius;
        vertex(vertexX, vertexY);
      }
      endShape(CLOSE);
    }
  }
}


void drawCurve() {
  stroke(0, 0, 225);
  line(width/2, 0, width/2, height);

  stroke(255, 0, 0);
  noFill();

  // curve 1
  beginShape();
  for (int y = 0; y < rows; y++) {
    float x = map(stretch * sin(y * compression + Yshift) + Xshift, 0, 255, 0, width/2);
    curveVertex(x, y * squareSize);
  }
  endShape();

  // - curve 2
  stroke(200, 0, 0);
  beginShape();
  for (int y = 0; y < rows; y++) {
    float x1 = map(stretch * sin(y * compression + Yshift) + Xshift - range1, 0, 255, 0, width/2);
    curveVertex(x1, y * squareSize);
  }
  endShape();


  // curve 3
  beginShape();
  for (int y = 0; y < rows; y++) {
    float x2 = map(stretch * sin(y * compression + Yshift) + Xshift + range2, 0, 255, 0, width/2);
    curveVertex(x2, y * squareSize);
  }
  endShape();
}
