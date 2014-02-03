import gab.opencv.*;
import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;
import org.processing.wiki.triangulate.*;
import controlP5.*;
import SimpleOpenNI.*;

int GRAYSCALE = ALPHA;

SimpleOpenNI  context;
boolean live;
String recordPath;

float rotX = radians(180);  // by default rotate the hole scene 180deg around the x-axis, the data from openni comes upside down
float rotY = radians(0);
float zoomF = 0.2f;

DelaBlob delaBlob;
HUD hud;

void setup()
{
  size(800, 600, P3D);
  
  live = false;
  recordPath = "rec_01.oni";
  
  hud = new HUD(this);
  delaBlob = new DelaBlob(this);

  initKinect();
  delaBlob.init();
}

void draw()
{
  update();
  perspective(radians(45), float(width)/float(height), 10, 150000);
  background(0);
  pushMatrix();
  translate(width/2, height/2, 0);
  rotateX(rotX);
  rotateY(rotY);
  scale(zoomF);
  translate(0, 0, -1000);

  delaBlob.displayMesh();
  delaBlob.displayProxy();

  popMatrix();

  hud.display();
}

void update() {
  context.update();
  if ((context.nodes() & SimpleOpenNI.NODE_DEPTH) == 0 || (context.nodes() & SimpleOpenNI.NODE_IMAGE) == 0)
  {
    println("No frame.");
    return;
  }
  delaBlob.update();
}

void initKinect() {
  if (live) {
    context = new SimpleOpenNI(this);
    if (context.isInit() == false)
    {
      println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
      exit();
      return;
    }
  } 
  else {
    context = new SimpleOpenNI(this, recordPath);
  }

  context.enableDepth();
  context.enableRGB();
  context.setMirror(true);
  context.alternativeViewPointDepthToImage();
}

