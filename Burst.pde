class Burst
{
	float m;
	float radius = 1;
	color burstColor = whiteColor;
	float increment = 50;
	float alpha;
	float xpos = width/2;
	float ypos = height/2;
	
	Burst()
	{
		alpha = random(50, 100);
		increment = random(1, 5);
		xpos = xpos;
		ypos = ypos;
	}
	
	void update()
	{
		if (radius < height){
			radius *= increment;
		} else {
			radius = 0;
		}
		
		// fill( burstColor, alpha );
		// noStroke();
		// ellipse(xpos, ypos, radius, radius);
		// fill( burstColor, 255 );
		// noStroke();
		// rect(0, 0, width, height);
		imageMode(CENTER);
		tint(burstColor, alpha);
		image(softOrb, xpos, ypos, radius, radius);
	}

	void setColor(color $color)
	{
		burstColor = $color;
	}
	
}