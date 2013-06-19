class Vehicle
{
	PVector location;
	PVector velocity;
	PVector acceleration;
	float r;
	float maxforce;
	float maxspeed;
	float mass;
	Attractor attractor;
	
	int scaleRate = 30;
	Boolean isScaled = false;
	
	int INITIAL_SIZE = 0;
	float scaleTo = 5;
	
	// color randomColor;
	
	color fillColor;
	
	Vehicle(float x, float y)
	{
		location = new PVector(x, y);
		r = INITIAL_SIZE;
		maxspeed = 18;
		maxforce = 2.5;
		acceleration = new PVector(0, 0);
		velocity = new PVector(0, 0);
		mass = 1;
		// randomColor = color( int(random(0,255)), int(random(0,255)), int(random(0,255)), int(random(100,200)));
	}
	
	void applyForce(PVector force)
	{
		acceleration.add(force);
	}
	
	void applyBehaviors(ArrayList<Vehicle> vehicles, Attractor a) 
	{
		PVector separate = separate(vehicles);
		PVector seek = seek(a.location);
		separate.mult(2);
		seek.mult(1);
		applyForce(separate);
		applyForce(seek);
	  }

	// seek
	PVector seek(PVector target) {
		PVector desired = PVector.sub(target,location);
		desired.normalize();
		desired.mult(maxspeed);
		
		PVector steer = PVector.sub(desired,velocity);
		steer.limit(maxforce);

		if (isSeekLines){
			stroke(fillColor);
			strokeWeight(1);
			line(location.x, location.y, target.x, target.y);	
		}

		return steer;
	}

	// Separation
	PVector separate (ArrayList<Vehicle> vehicles) {
		float desiredseparation = r*2;
		PVector sum = new PVector();
		int count = 0;
		// For every boid in the system, check if it's too close
		for (Vehicle other : vehicles) {
			float d = PVector.dist(location, other.location);
		 	
		  	if ((d > 0) && (d < desiredseparation)) {
				
				if (isSeparationLines){
					stroke(fillColor);
					strokeWeight(1);
					line(location.x, location.y, other.location.x, other.location.y);
				}
			
				PVector diff = PVector.sub(location, other.location);
				diff.normalize();
				diff.div(d);        // Weight by distance
				sum.add(diff);
				count++;            // Keep track of how many
		  	}
		}
		// Average -- divide by how many
		if (count > 0) {
		  	sum.div(count);
		  	// Our desired vector is the average scaled to maximum speed
		  	sum.normalize();
		  	sum.mult(maxspeed);
		  	// Implement Reynolds: Steering = Desired - Velocity
		  	sum.sub(velocity);
		  	sum.limit(maxforce);
		}
		return sum;
	}
	
	//cohesion
	void cohesion (ArrayList<Vehicle> vehicles) {
		float desiredseparation = r*2;
		PVector sum = new PVector();
		int count = 0;
		// For every boid in the system, check if it's too close
		for (Vehicle other : vehicles) {
		  	float d = PVector.dist(location, other.location);

		  	if (d > desiredseparation) {
				// Calculate vector pointing away from neighbor
				PVector diff = PVector.sub(location, other.location);
				diff.normalize();
				diff.mult(-d);      // Weight by distance
				sum.add(diff);
				count++;            // Keep track of how many
		  	}
		}
		// Average -- divide by how many
		if (count > 0) {
		  sum.div(count);
		  // Our desired vector is the average scaled to maximum speed
		  sum.normalize();
		  sum.mult(maxspeed);
		  // Implement Reynolds: Steering = Desired - Velocity
		  PVector steer = PVector.sub(sum, velocity);
		  steer.limit(maxforce);
		  applyForce(steer);
		}
	  }
	
	// Method to update location
	  void update() {
		// Update velocity
		velocity.add(acceleration);
		// Limit speed
		velocity.limit(maxspeed);
		location.add(velocity);
		// Reset accelertion to 0 each cycle
		acceleration.mult(0);
		if(isScaleUp) {
			scaleUpFunction();
		} 
		if(isScaleDown) {
			scaleDownFunction();
		}
		
	  }

	  void display() {
		//fill(255, 100);
		//fill(0, 50);
		// noStroke();
		//stroke(255, 50);
		pushMatrix();
		translate(location.x, location.y);
		//ellipse(0, 0, r, r);
		imageMode(CENTER);
		if (isShowImage){
			// tint(randomColor);
			// image(orb, 0, 0, r*2, r*2);
			tint(fillColor);
			image(orb, 0, 0, r, r);
			// tint(randomColor2);
			// image(orb, 0, 0, r/2, r/2);
		}
		if (isShowWireframe){
			// tint(randomColor);
			// image(orbWireframe, 0, 0, r*2, r*2);
			tint(fillColor);
			image(orbWireframe, 0, 0, r, r);
			image(orbWireframe, 0, 0, r, r);
			image(orbWireframe, 0, 0, r, r);
			image(orbWireframe, 0, 0, r, r);
			image(orbWireframe, 0, 0, r, r);
		}
		popMatrix();
	  }

	  // Wraparound
	  void borders() {
		if (location.x < -r) location.x = width+r;
		if (location.y < -r) location.y = height+r;
		if (location.x > width+r) location.x = -r;
		if (location.y > height+r) location.y = -r;
	  }
	
	void scaleUp(float amount)
	{
		//r += amount;
		scaleTo = amount * 5;
		if(amount < r) {
			isScaleDown = true;
		} else {
			isScaleUp = true;
		}
	}
	
	void scaleDown()
	{
		r = INITIAL_SIZE;
	}
	
	void scaleUpFunction()
	{
		if(r < scaleTo){
			r += 1.0;
		}
	}
	
	void scaleDownFunction()
	{
		if(r > scaleTo + INITIAL_SIZE) {
			r -= 5;
		}
	}
	
	Boolean isScaleUp = false;
	Boolean isScaleDown = false;

	void setColor(color $color)
	{
		fillColor = $color;
	}
	
}