public class Scene1 extends Scene
{
	
	float ATTRACTOR_MOVE_SENSITIVITY_DEFAULT = 10;
	float VEHICLE_SCALE_SENSITIVITY_MIN_DEFAULT = 0;
	float VEHICLE_SCALE_SENSITIVITY_MAX_DEFAULT = 100;
	float BURST_SENSIVITY_DEFAULT = 10;

	float ATTRACTOR_MOVE_SENSITIVITY = 30;
	float VEHICLE_SCALE_SENSITIVITY_MIN = 0;
	float VEHICLE_SCALE_SENSITIVITY_MAX = 100;
	float BURST_SENSIVITY = 50;

	int scaleRate = 0;

	ArrayList<Vehicle> vehicles;
	Attractor attractor, attractor2;

	int NUM_BURSTS = 30;
	int NUM_VEHICLES = 30;
	ArrayList bursts;

	public Scene1 (float $x, float $y, int $width, int $height, FFT $fft) {
		super($x, $y, $width, $height, $fft);
	}

	void setup(){
		vehicles = new ArrayList<Vehicle>();
		attractor = new Attractor(random(_width), random(_height));
		// attractor2 = new Attractor(random(_width), random(_height));
	  	for (int i = 0; i < NUM_VEHICLES; i++) {
	    	vehicles.add(new Vehicle(random(_width),random(_height)));
	  	}
		bursts = new ArrayList();
	}
	
	void draw(){
		_fft.forward(audioInput.mix);
		int w = int(_width/_fft.avgSize());

		for( int i = 0; i < _fft.avgSize(); i++ ) {
			//attractor
			if( _fft.getAvg(i) > ATTRACTOR_MOVE_SENSITIVITY ) {
				attractor.wander();
				attractor.run();
				// attractor2.wander();
				// attractor2.run();
			}
			//scale vehicles
			if( _fft.getAvg(i) > VEHICLE_SCALE_SENSITIVITY_MIN && _fft.getAvg(i) < VEHICLE_SCALE_SENSITIVITY_MAX ) {
				Vehicle vehicle = (Vehicle) vehicles.get(i);
				vehicle.scaleUp(_fft.getAvg(i));
			} else {
				// Vehicle vehicle = (Vehicle) vehicles.get(i);
				// vehicle.scaleDown();
			}

			if( _fft.getAvg(i) > BURST_SENSIVITY ) {
				if (bursts.size() < NUM_BURSTS){
					Burst burst = new Burst();
					bursts.add(burst);	
				} else {
					bursts.clear();
				}
			}
		}

		for (int j = 0; j<bursts.size(); j++){
			Burst burst = (Burst) bursts.get(j);
			burst.xpos = attractor.location.x;
			burst.ypos = attractor.location.y;
			burst.update();
		}

		attractor.display();
		attractor.borders();
		// attractor2.display();
		// attractor2.borders();

	  	for (Vehicle v : vehicles) {
	    	// Path following and separation are worked on in this function
	    	v.applyBehaviors(vehicles, attractor);
	    	// v.applyBehaviors(vehicles, attractor2);
			
			if(mousePressed == true) {
				v.cohesion(vehicles);
			}
	    	
			v.borders();
	    	v.update();
	    	v.display();
	  	}
	}

}