public class SceneWindow
{

	float _x, _y, _width, _height;
	
	//--------------------------------------
	//  CONSTRUCTOR
	//--------------------------------------
	
	public SceneWindow (float $x, float $y, float $width, float $height) {
		_x = $x;
		_y = $y;
		_width = $width;
		_height = $height;
	}

	void setup(){
		
	}
	
	void draw(){
		fill(255);
		rect(_x, _y, _width, _height);
	}

}