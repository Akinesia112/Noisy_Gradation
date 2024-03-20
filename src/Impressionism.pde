PGraphics pg;

int squareSize = 38;
int cols = 13718 / squareSize;
int rows = 27436 / squareSize;
int[][] colors = new int[rows][cols];
float circleRadius = squareSize; // Initialize the radius to be the same as squareSize
float flowerRadius = squareSize; // Initialize the radius to be the same as squareSize

// ratio
float ratio = (float)1800 / (float)13718;

int mode = 4;

// Control sin curve
float stretch = 160;
float compression = 0.027;
float Xshift = 120;
float Yshift = -300;
int range1 = 60;
int range2 = 50;


int noiseRange1 = 0;
int noiseRange2 = 0;

boolean sNoise_g = true;
float squareNoise = 10;
float squareNoiseMax = 50;

float scaleFlower = 1.5;
color startColor1 = color(100, 100, 100);
color startColor2 = color(185, 240, 151);
color startColor3 = color(112,128,145);

float targetR = 54;
float targetG = 168;
float targetB = 245;
float setAlpha = 120;

void setup() {

  size(500, 500, P2D);
}

void draw() {

  pg = createGraphics(13718, 27436);
  pg.beginDraw();
  //pg.background(255);
  //initializeColors();
  initializeRandomRGBColor();

  if (mode == 1) {
    drawSquareGrid();
  } else if (mode == 2) {
    drawCircleGrid();
  } else if (mode == 3) {
    drawFlower();
  }else if (mode == 4) {
    drawMode4();
  }
  
  drawCurve();
  pg.endDraw();
  pg.save("flower0319/img_sgrid_Flower_" + scaleFlower + "_setAlpha_" + setAlpha + "_rgb_" + targetR + "_"  + targetG + "_" + targetB +".png");
  pg.clear();
  exit();
}



void initializeColors() {
  for (int y = 0; y < rows; y++) {
    int baseGrey = int(stretch * sin(getSinRatio(y * compression) + Yshift) + Xshift); //************************************************************ sin curve
    for (int x = 0; x < cols; x++) {

      int grayValue = baseGrey + int(random(-range1, range2));
      grayValue = constrain(grayValue, 0, 255);
      colors[y][x] = color(grayValue, grayValue, grayValue);
    }
  }
}

void initializeRandomRGBColor() {

  for (int y = 0; y < rows; y++) {
    int baseGrey = int(stretch * sin(getSinRatio(y * compression) + Yshift) + Xshift);
    for (int x = 0; x < cols; x++) {

      int grayValue = baseGrey + int(random(-range1, range2));
      grayValue = constrain(grayValue, 0, 255);
      colors[y][x] = color(grayValue, grayValue, grayValue);

      //int greyR = grayValue;
      //float sc = 0.02*y;
      float weight1 = 0.29; // 可以根據需要調整這些權重
      float weight2 = 0.34;
      float weight3 = 0.37; // 確保總和為 1
      // weight based color blending
      float mixedR = (red(startColor1) * weight1 + red(startColor2) * weight2 + red(startColor3) * weight3) * grayValue / 255;
      float mixedG = (green(startColor1) * weight1 + green(startColor2) * weight2 + green(startColor3) * weight3) * grayValue / 255;
      float mixedB = (blue(startColor1) * weight1 + blue(startColor2) * weight2 + blue(startColor3) * weight3) * grayValue / 255;

      // apply random offset and constrain
      int randomR = constrain(int(mixedR) + int(random(0, targetR * y/722)), 0, 255);
      int randomG = constrain(int(mixedG) + int(random(0, targetG * y/722)), 0, 255);
      int randomB = constrain(int(mixedB) + int(random(0, targetB * y/722)), 0, 255);

      
      // int randomR = constrain(int(grayValue)+int(random(0, targetR * y/722)), 0, 255);
      // int randomG = constrain(int(grayValue)+int(random(0, targetG * y/722)), 0, 255);
      // int randomB = constrain(int(grayValue)+int(random(0, targetB * y/722)), 0, 255);

      // int randomBotR = int(random(0,2));
      // int randomBotG = int(random(0,15));
      // int randomBotB = int(random(0,10));

      colors[y][x] = color(randomR, randomG, randomB);
    }
  }
}

//********



void drawSquareGrid() {
  for (int y = 0; y < rows; y++) {
    if (sNoise_g) squareNoise = map(y, 0, rows, 0, squareNoiseMax);
    for (int x = 0; x < cols; x++) {
      int grayValue = colors[y][x];
      fill(grayValue);
      noStroke();
      float adjustedX = x * squareSize + random(-squareNoise, squareNoise);
      float adjustedY = y * squareSize + random(-squareNoise, squareNoise);
      rect(adjustedX, adjustedY, squareSize, squareSize);
    }
  }
}

// Mode 2
void drawCircleGrid() {
  for (int y = 0; y < rows; y++) {
    if (sNoise_g) squareNoise = map(y, 0, rows, 0, squareNoiseMax);
    for (int x = 0; x < cols; x++) {
      int grayValue = colors[y][x];
      pg.fill(grayValue);
      pg.noStroke();
      float adjustedX = x * squareSize + squareSize / 2 + random(-squareNoise, squareNoise);
      float adjustedY = y * squareSize + squareSize / 2 + random(-squareNoise, squareNoise);
      float circleRadius2 = random(0.1, 3.5) *circleRadius;
      pg.ellipse(adjustedX + squareSize / 2, adjustedY + squareSize / 2, circleRadius2, circleRadius2);
    }
  }
}

// Mode 3
void drawFlower() {
  for (int y = 0; y < rows; y++) {
    if (sNoise_g) squareNoise = map(y, 0, rows, 0, squareNoiseMax);
    for (int x = 0; x < cols; x++) {
      int grayValue = colors[y][x];
      pg.fill(grayValue);
      pg.noStroke();
      float adjustedX = x * squareSize + random(-5 * squareNoise, 5 * squareNoise);
      float adjustedY = y * squareSize + random(-5 * squareNoise, 5 * squareNoise);
      
      drawFlowerShape(adjustedX, adjustedY);
    }
  }
}

void drawFlowerShape(float x, float y) {
  float petalSize = random(15, 50) * scaleFlower;
  float petalHeight = random(30, 80) * scaleFlower;

  float angleIncrement = TWO_PI / random(3, 5);

  float startAngle = random(TWO_PI); // Random start angle for each petal

  pg.pushMatrix();
  pg.translate(x, y);

  for (float angle = startAngle; angle < TWO_PI + startAngle; angle += angleIncrement) {
    pg.pushMatrix();
    pg.rotate(angle);
    pg.ellipse(0, 0, petalSize, petalHeight);
    pg.popMatrix();
  }

  pg.popMatrix();
}

// Mode 4: 
//
//void drawMode4() {
//  String folderPath = "D:/YTC/ArtPaper_Processing/01 - 9500"; // 指定图片文件夹的路径
//  File folder = new File(folderPath);
//  File[] listOfFiles = folder.listFiles((dir, name) -> name.endsWith(".png"));
//  PImage[] images = new PImage[listOfFiles.length];

//  for (int i = 0; i < listOfFiles.length; i++) {
//    images[i] = loadImage(listOfFiles[i].getAbsolutePath());
//  }

//  int imageIndex = 0;
//  for (int y = 0; y < rows; y++) {
//    for (int x = 0; x < cols; x++) {
//      if (imageIndex >= images.length) {
//        imageIndex = 0; // Restart from the first image if we've used all
//      }
//      // Calculate position with some randomness
//      float adjustedX = x * squareSize + random(-squareNoise, squareNoise);
//      float adjustedY = y * squareSize + random(-squareNoise, squareNoise);
//      // Adjust image size if necessary
//      PImage img = images[imageIndex++];
//      float imgScale = squareSize / max(img.width, img.height); // Scale image to fit the square
//      pg.image(img, adjustedX, adjustedY, img.width * imgScale, img.height * imgScale);
//    }
//  }
//}

// Mode 4: 印象派不規則筆觸風格
void drawMode4() {
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      // 取得目前位置的顏色
      int colorValue = colors[y][x];
      // 在每個格子內繪製不規則的筆觸
      drawImpressionistStrokes(x * squareSize, y * squareSize, squareSize, colorValue);
    }
  }
}

// 在指定區域內繪製不規則筆觸
void drawImpressionistStrokes(float x, float y, float size, int colorValue) {
  int strokes = 10; // 每個格子內的筆觸數量
  pg.noStroke();
  for (int i = 0; i < strokes; i++) {
    float offsetX = random(-2*size, 2*size);
    float offsetY = random(-2*size, 2*size);
    float strokeSize = random(size / 8, 8*size);
    pg.fill(colorValue, 255); // 设置颜色和透明度
    pg.pushMatrix();
    pg.translate(x + size / 2 + offsetX, y + size / 2 + offsetY);
    pg.rotate(random(TWO_PI)); // 隨機旋轉角度
    pg.beginShape();
    // 建立不規則形狀
    for (float angle = 0; angle < TWO_PI; angle += random(PI / 8, PI / 4)) {
      float r = strokeSize + random(-strokeSize / 4, strokeSize / 4);
      float posX = r * cos(angle)+random(-size / 2, size / 2);
      float posY = r * sin(angle)+random(-size / 2, size / 2);
      pg.vertex(posX, posY);
    }
    pg.endShape(CLOSE);
    pg.popMatrix();
  }
}


void drawCurve() {
  pg.strokeWeight(int(1/ratio));
  pg.stroke(0, 0, 225);
  pg.line(width / 2, 0, width / 2, height);

  pg.stroke(255, 0, 0);
  pg.noFill();

  pg.beginShape();
  for (int y = 0; y < rows; y++) {
    float x = map(stretch * sin(getSinRatio(y * compression) + Yshift) + Xshift, 0, 255, 0, width/2);
    pg.curveVertex(x, y * squareSize);
  }
  pg.endShape();

  pg.stroke(200, 0, 0); // Set the color of the offset curves to light gray
  pg.beginShape();
  for (int y = 0; y < rows; y++) {
    float x1 = map(stretch * sin(getSinRatio(y * compression) + Yshift) + Xshift - range1, 0, 255, 0, width/2);
    pg.curveVertex(x1, y * squareSize);
  }
  pg.endShape();

  pg.beginShape();
  for (int y = 0; y < rows; y++) {
    float x2 = map(stretch * sin(getSinRatio(y * compression) + Yshift) + Xshift + range2, 0, 255, 0, width/2);
    pg.curveVertex(x2, y * squareSize);
  }
  pg.endShape();
}

float getSinRatio(float angle) {
  return angle * ratio;
}
