import javax.media.opengl.GL2;
import ddf.minim.*;
import ddf.minim.analysis.*;
import controlP5.*;
import codeanticode.syphon.*;
import oscP5.*;
import netP5.*;

float SCENE_LOCATION_X = 0;
float SCENE_LOCATION_Y = 0;
int SCENE_SIZE_W = 800;
int SCENE_SIZE_H = 600;

Minim minim;
AudioInput audioInput;
FFT fft;
Scene1 scene1;
PImage orb, orbWireframe, softOrb;
GL2 gl; 
PGraphicsOpenGL pgl;
SyphonServer server;
PGraphics canvas;
ControlP5 ui;
Controls controls;
OscP5 oscP5;
NetAddress myBroadcastLocation;
color randomColor, randomColor1, randomColor2;
ArrayList colorsList;

color whiteColor, yellowColor, yellowColor2;

Boolean isSeekLines, isSeparationLines, isDoCohesion, isShowImage, isShowWireframe;

void setup(){
	size(SCENE_SIZE_W, SCENE_SIZE_H, P3D);
	canvas = createGraphics(width, height, P3D);
	server = new SyphonServer(this, "f1ssur3");

	// colorMode(HSB);

	colorsList = new ArrayList();
	colorsList.add(randomColor);
	colorsList.add(randomColor1);
	colorsList.add(randomColor2);

	pgl = (PGraphicsOpenGL) g;  // g may change
  	gl = pgl.beginPGL().gl.getGL2();

	background(0, 0, 0);

	softOrb = loadImage("white_orb.png");
	orbWireframe = loadImage("white_orb_wireframe.png");
	orb = loadImage("circle.png");

	minim = new Minim(this);
	audioInput = minim.getLineIn(Minim.STEREO, 512);
	fft = new FFT(audioInput.bufferSize(), audioInput.sampleRate());
	fft.logAverages(22, 3);

	isSeekLines = isSeparationLines = isDoCohesion = isShowImage = isShowWireframe = false;

	generateRandomColor();

  	scene1 = new Scene1(SCENE_LOCATION_X, SCENE_LOCATION_Y, SCENE_SIZE_W, SCENE_SIZE_H, fft);
  	scene1.setup();

  	ui = new ControlP5(this);
  	controls = new Controls(ui, fft);
  	controls.setup();

  	oscP5 = new OscP5(this, 12000);
  	myBroadcastLocation = new NetAddress("127.0.0.1", 32000);
}

void draw(){

	pgl.beginPGL();
		gl.glDisable(GL2.GL_DEPTH_TEST);
		gl.glEnable(GL2.GL_BLEND);
		gl.glBlendFunc(GL2.GL_SRC_ALPHA, GL2.GL_ONE);
	pgl.endPGL();
	
	background(0, 0, 0);
	scene1.draw();

	server.sendImage(pgl);

	controls.draw();

	textSize(10);
	text(oscP5.ip(), 12, height-30);
}

void generateRandomColor()
{
	// randomColor = color( int(random(0,255)), 255, 255, int(random(100,200)) );
	// randomColor1 = color( int(random(0,255)), 255, 255, int(random(100,200)) );
	// randomColor2 = color( int(random(0,255)), 255, 255, int(random(100,200)) );
	int primary = 255;
	randomColor = color( primary, 0, 255, 255 );
	randomColor1 = color( primary, 0, 255, 255 );
	randomColor2 = color( primary, 0, 255, 255 );

	whiteColor = color( 255, 255, 255 );
	yellowColor = color( 255, 166, 0 );
	yellowColor2 = color( 255, 220, 0);
}

void oscEvent(OscMessage $e) 
{
	// println("### received an osc message with addrpattern "+ $e.addrPattern()+" and typetag "+ $e.typetag());
	// $e.print();

	// seek lines
	if ( $e.checkAddrPattern("/seekLines") == true ) {
		int value = int( $e.get(0).floatValue() );
		switch (value){
			case 0 :
				isSeekLines = false;
				break;	
			case 1 :
				isSeekLines = true;
				break;	
		}
	}

	// separation lines
	if ( $e.checkAddrPattern("/separationLines") == true ) {
		int value = int( $e.get(0).floatValue() );
		switch (value){
			case 0 :
				isSeparationLines = false;
				break;	
			case 1 :
				isSeparationLines = true;
				break;	
		}
	}

	// do cohesion
	if ( $e.checkAddrPattern("/doCohesion") == true ) {
		int value = int( $e.get(0).floatValue() );
		switch (value){
			case 0 :
				isDoCohesion = false;
				break;	
			case 1 :
				isDoCohesion = true;
				break;	
		}
	}

	// change color
	if ( $e.checkAddrPattern("/changeColor") == true ) {
		int value = int( $e.get(0).floatValue() );
		switch (value){	
			case 1 :
				generateRandomColor();
				break;
		}
	}

	// show image
	if ( $e.checkAddrPattern("/showImage") == true ) {
		int value = int( $e.get(0).floatValue() );
		switch (value){
			case 0 :
				isShowImage = false;
				break;	
			case 1 :
				isShowImage = true;
				break;	
		}
	}

	// show wireframe
	if ( $e.checkAddrPattern("/showWireframe") == true ) {
		int value = int( $e.get(0).floatValue() );
		switch (value){
			case 0 :
				isShowWireframe = false;
				break;	
			case 1 :
				isShowWireframe = true;
				break;	
		}
	}

	// vehicle speed
	if ( $e.checkAddrPattern("/vehicleSpeed") == true ){
		float value = $e.get(0).floatValue();
		scene1.setVehicleSpeed(value);
	}

	// vehicle force
	if ( $e.checkAddrPattern("/vehicleForce") == true ){
		float value = $e.get(0).floatValue();
		scene1.setVehicleForce(value);
	}

	// attractor speed
	if ( $e.checkAddrPattern("/attractorSpeed") == true ){
		float value = $e.get(0).floatValue();
		scene1.setAttractorSpeed(value);
	}

	// attractor force
	if ( $e.checkAddrPattern("/attractorForce") == true ){
		float value = $e.get(0).floatValue();
		scene1.setAttractorForce(value);
	}

	// burst sensitivity
	if ( $e.checkAddrPattern("/burstSens") == true ){
		float value = $e.get(0).floatValue();
		scene1.setBurstSens(value);
	}	
	
}
