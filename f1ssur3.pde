import javax.media.opengl.GL2;
import ddf.minim.*;
import ddf.minim.analysis.*;
import controlP5.*;
import codeanticode.syphon.*;

float SCENE_LOCATION_X = 0;
float SCENE_LOCATION_Y = 0;
int SCENE_SIZE_W = 1280;
int SCENE_SIZE_H = 768;

Minim minim;
AudioInput audioInput;
FFT fft;
Scene1 scene1;
PImage orb;
GL2 gl; 
PGraphicsOpenGL pgl;
SyphonServer server;
PGraphics canvas;
ControlP5 ui;

void setup(){
	size(SCENE_SIZE_W, SCENE_SIZE_H, P3D);
	canvas = createGraphics(width, height, P3D);
	server = new SyphonServer(this, "f1ssur3");

	pgl = (PGraphicsOpenGL) g;  // g may change
  	gl = pgl.beginPGL().gl.getGL2();

  	ui = new ControlP5(this);
  	ui.setAutoDraw(false);

	background(0, 0, 0, 255);

	orb = loadImage("white_orb.png");
	// orb = loadImage("circle.png");

	minim = new Minim(this);
	audioInput = minim.getLineIn(Minim.STEREO, 512);
	fft = new FFT(audioInput.bufferSize(), audioInput.sampleRate());
	fft.logAverages(22, 3);

  	scene1 = new Scene1(SCENE_LOCATION_X, SCENE_LOCATION_Y, SCENE_SIZE_W, SCENE_SIZE_H, fft, canvas);
  	scene1.setup();
  	
}

void draw(){

	pgl.beginPGL();
		gl.glDisable(GL2.GL_DEPTH_TEST);
		gl.glEnable(GL2.GL_BLEND);
		gl.glBlendFunc(GL2.GL_SRC_ALPHA, GL2.GL_ONE);
	pgl.endPGL();
	
	canvas.beginDraw();
	canvas.background(0, 0, 0);
	// canvas.lights();
	// canvas.translate(width/2, height/2, 0);
	// canvas.rotateX(frameCount * 0.01);
	// canvas.rotateY(frameCount * 0.01);
	// canvas.box(150);
	scene1.draw();
	canvas.endDraw();
	image(canvas, 0, 0);
	server.sendImage(canvas);

}