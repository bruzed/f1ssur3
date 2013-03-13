public class Scene
{
	
	float _x, _y;
	int _width, _height;
	FFT _fft;
	
	public Scene (float $x, float $y, int $width, int $height, FFT $fft) 
	{
		_x = $x;
		_y = $y;
		_width = $width;
		_height = $height;
		_fft = $fft;
	}

	void setup(){

	}
	
	void draw(){
		fill(255);
		rect(_x, _y, _width, _height);
	}

}