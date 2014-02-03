class HUD {

  ControlP5 cp5;
  PMatrix3D currCameraMatrix;
  PGraphics3D g3;

  int depthMin;
  int depthMax;
  int padL;
  int padR;

  HUD(PApplet pa) {
    g3 = (PGraphics3D)g;
    cp5 = new ControlP5(pa);

    depthMin = 100;
    depthMax = 1800;
    padL = 50;
    padR = 600;

    cp5.addSlider("depthMin").setPosition(10, 10).setRange(0, 5000);
    cp5.addSlider("depthMax").setPosition(10, 30).setRange(0, 5000);
    cp5.addSlider("padL").setPosition(10, 50).setRange(0, 319);
    cp5.addSlider("padR").setPosition(10, 70).setRange(320, 639);
  }

  void display() {
    currCameraMatrix = new PMatrix3D(g3.camera);
    hint(DISABLE_DEPTH_TEST);
    perspective();
    camera();
    //  Start HUD
    cp5.draw();
    pushMatrix();
    PImage preview = delaBlob.getMaskPreview();
    translate(width - preview.width * 0.25, height - preview.height * 0.25);
    scale(0.25);
    noStroke();
    image(preview, 0, 0, preview.width, preview.height);
    delaBlob.displayContour();
    stroke(255, 0, 0);
    noFill();
    line(padL, 0, padL, preview.height);
    line(padR, 0, padR, preview.height);
    rect(0, 0, preview.width, preview.height);
    noStroke();
    popMatrix();
    //  End HUD
    hint(ENABLE_DEPTH_TEST);
    g3.camera = currCameraMatrix;
  }
}

