int squareSize = 2;
int cols = 800 / squareSize;
int rows = 1600 / squareSize;
int[][] colors = new int[rows*2][cols];
color startColor1 = color(112, 11, 128); // start Color1
color startColor2 = color(112, 11, 128); // start Color2
color startColor3 = color(112,128,145); // start Color3

//color startColor1 = color(0, 112, 128); // start Color1
//color startColor2 = color(0, 128, 128); // start Color2
//color startColor3 = color(0,128,145); // start Color3

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
void drawCircleGrid() {
  for (int y = 0; y < rows*2; y++) {
    if(sNoise_g) squareNoise = map(y, 0, rows, 0, squareNoiseMax); // Gradually increase square noise from top to bottom
    for (int x = 0; x < cols; x++) {
      int grayValue = colors[y][x];
      
      fill(grayValue);
      noStroke();
      float adjustedX = x * squareSize + squareSize / 2 + random(-squareNoise, squareNoise); // Center of the circle
      float adjustedY = y * squareSize + squareSize / 2 + random(-squareNoise, squareNoise); // Center of the circle
      ellipse(adjustedX, adjustedY, circleRadius*2, circleRadius*2); // Draw the circle with the specified radius
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
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      
      int baseGray = int(stretch * sin(y * compression + Yshift) + Xshift);
      int grayValue = baseGray + int(random(-range1, range2));
      
      grayValue = constrain(grayValue, 0, 255);
      
      // 分別對 startColor1, startColor2, startColor3 的 RGB 分量進行加權計算
      float weight1 = 0.29; // 可以根據需要調整這些權重
      float weight2 = 0.34;
      float weight3 = 0.37; // 確保總和為 1
      
      int r = int((red(startColor1) * weight1 + red(startColor2) * weight2 + red(startColor3) * weight3) * grayValue / 255);
      int g = int((green(startColor1) * weight1 + green(startColor2) * weight2 + green(startColor3) * weight3) * grayValue / 255);
      int b = int((blue(startColor1) * weight1 + blue(startColor2) * weight2 + blue(startColor3) * weight3) * grayValue / 255);
      
      // 組合成新的顏色值
      colors[y][x] = color(r, g, b);
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
