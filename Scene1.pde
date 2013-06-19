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
	ArrayList<Vehicle> otherVehicles;
	ArrayList<Vehicle> moreVehicles;
	ArrayList<Vehicle> evenmoreVehicles;
	Attractor attractor, attractor2;

	int NUM_BURSTS = 30;
	int NUM_VEHICLES = 30;
	ArrayList bursts;
	ArrayList yellowbursts;

	public Scene1 (float $x, float $y, int $width, int $height, FFT $fft) 
	{
		super($x, $y, $width, $height, $fft);
	}

	void setup(){
		vehicles = new ArrayList<Vehicle>();
		otherVehicles = new ArrayList<Vehicle>();
		moreVehicles = new ArrayList<Vehicle>();
		evenmoreVehicles = new ArrayList<Vehicle>();
		attractor = new Attractor(random(_width), random(_height));
		attractor2 = new Attractor(random(_width), random(_height));

	  	for (int i = 0; i < NUM_VEHICLES; i++) {
	  		Vehicle vehicle = new Vehicle(random(_width),random(_height));
	  		vehicle.setColor(whiteColor);
	    	vehicles.add(vehicle);
	  	}

	  	for (int i = 0; i < NUM_VEHICLES; i++) {
	  		Vehicle otherVehicle = new Vehicle(random(_width),random(_height));
	  		otherVehicle.r = random(2, 10);
	  		otherVehicle.setColor(yellowColor);
	    	otherVehicles.add(otherVehicle);
	  	}

	  	for (int i = 0; i < NUM_VEHICLES; i++) {
	  		Vehicle moreVehicle = new Vehicle(random(_width),random(_height));
	  		moreVehicle.setColor(yellowColor2);
	    	moreVehicles.add(moreVehicle);
	  	}

	  	for (int i = 0; i < NUM_VEHICLES; i++) {
	  		Vehicle evenmoreVehicle = new Vehicle(random(_width),random(_height));
	  		evenmoreVehicle.r = random(2, 20);
	  		evenmoreVehicle.setColor(yellowColor2);
	    	evenmoreVehicles.add(evenmoreVehicle);
	  	}

		bursts = new ArrayList();
		yellowbursts = new ArrayList();
	}
	
	void draw(){
		_fft.forward(audioInput.mix);
		int w = int(_width/_fft.avgSize());

		for( int i = 0; i < _fft.avgSize(); i++ ) {
			//attractor
			if( _fft.getAvg(i) > ATTRACTOR_MOVE_SENSITIVITY ) {
				attractor.wander();
				attractor.run();
				attractor2.wander();
				attractor2.run();
			}
			//scale vehicles
			if( _fft.getAvg(i) > VEHICLE_SCALE_SENSITIVITY_MIN && _fft.getAvg(i) < VEHICLE_SCALE_SENSITIVITY_MAX ) {
				Vehicle vehicle = (Vehicle) vehicles.get(i);
				vehicle.scaleUp(_fft.getAvg(i));

				// Vehicle moreVehicle = (Vehicle) moreVehicles.get(i);
				// moreVehicle.scaleUp(_fft.getAvg(i));
			}

			if( _fft.getAvg(i) > BURST_SENSIVITY ) {
				if (bursts.size() < NUM_BURSTS){
					Burst burst = new Burst();
					bursts.add(burst);	
				} else {
					bursts.clear();
				}

				if (yellowbursts.size() < NUM_BURSTS){
					Burst burst = new Burst();
					burst.setColor(yellowColor);
					yellowbursts.add(burst);	
				} else {
					yellowbursts.clear();
				}
			}
		}

		for (int j = 0; j<bursts.size(); j++){
			Burst burst = (Burst) bursts.get(j);
			burst.xpos = attractor.location.x;
			burst.ypos = attractor.location.y;
			burst.update();
		}

		for (int j = 0; j<yellowbursts.size(); j++){
			Burst burst = (Burst) yellowbursts.get(j);
			burst.xpos = attractor2.location.x;
			burst.ypos = attractor2.location.y;
			burst.update();
		}

		attractor.display();
		attractor.borders();

		attractor2.display();
		attractor2.borders();

	  	for (Vehicle v : vehicles) {
	    	v.applyBehaviors(vehicles, attractor);
	    	v.applyBehaviors(vehicles, attractor2);

			if(isDoCohesion) {
				v.cohesion(vehicles);
			}
	    	
			v.borders();
	    	v.update();
	    	v.display();
	  	}

	  	for (Vehicle ov : otherVehicles) {
	    	ov.applyBehaviors(otherVehicles, attractor);
	    	ov.applyBehaviors(otherVehicles, attractor2);

			if(isDoCohesion) {
				ov.cohesion(otherVehicles);
			}
	    	
			ov.borders();
	    	ov.update();
	    	ov.display();
	  	}

	  	for (Vehicle mv : moreVehicles) {
	    	mv.applyBehaviors(moreVehicles, attractor);
	    	mv.applyBehaviors(moreVehicles, attractor2);

			if(isDoCohesion) {
				mv.cohesion(moreVehicles);
			}
	    	
			mv.borders();
	    	mv.update();
	    	mv.display();
	  	}

	  	for (Vehicle emv : evenmoreVehicles) {
	    	emv.applyBehaviors(evenmoreVehicles, attractor);
	    	emv.applyBehaviors(evenmoreVehicles, attractor2);

			if(isDoCohesion) {
				emv.cohesion(evenmoreVehicles);
			}
	    	
			emv.borders();
	    	emv.update();
	    	emv.display();
	  	}
	}

	void setVehicleSpeed(float speed)
	{
		for (Vehicle v : vehicles) {
			v.maxspeed = speed;
		}

		for (Vehicle ov : otherVehicles) {
			ov.maxspeed = speed;
		}

		for (Vehicle mv : moreVehicles) {
			mv.maxspeed = speed;
		}

		for (Vehicle emv : evenmoreVehicles) {
			emv.maxspeed = speed;
		}
	}

	void setVehicleForce(float force)
	{
		for (Vehicle v : vehicles) {
			v.maxforce = force;
		}

		for (Vehicle ov : otherVehicles) {
			ov.maxforce = force;
		}

		for (Vehicle mv : moreVehicles) {
			mv.maxforce = force;
		}

		for (Vehicle emv : evenmoreVehicles) {
			emv.maxforce = force;
		}
	}

	void setAttractorSpeed(float speed)
	{
		// attractor.maxspeed = speed;
		ATTRACTOR_MOVE_SENSITIVITY = speed;
	}

	void setAttractorForce(float force)
	{
		attractor.maxforce = force;
		attractor2.maxforce = force;
	}

	void setBurstSens(float sens)
	{
		BURST_SENSIVITY = sens;
	}

}