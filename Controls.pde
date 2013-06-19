public class Controls
{
	
	ControlP5 ui;
	FFT fft;

	RadioButton inputRadio;
	CheckBox checkbox;

	public Controls () {
		
	}

	public Controls(ControlP5 $ui, FFT $fft)
	{
		ui = $ui;
		fft = $fft;
	}

	void setup()
	{
		ui.addFrameRate().setInterval(10).setPosition(10, height-20);

		// ui.addRadioButton("input")
		// 	.setPosition(10, 60)
	 //     	.setSize(10, 10)
	 //     	.setColorForeground(color(150))
	 //     	.setColorActive(color(255))
	 //     	.setColorBackground(color(100))
	 //     	.addItem("line", 0)
	 //     	.addItem("mic", 1);

	 //    checkbox = ui.addCheckBox("showLines")
	 //     	.setPosition(10, 90)
	 //     	.setSize(10, 10)
	 //     	.setColorForeground(color(150))
	 //     	.setColorActive(color(255))
	 //     	.setColorBackground(color(100))
	 //     	.setItemsPerRow(1)
  //           .setSpacingRow(5)
  //           .addItem("seek", 0)
  //           .addItem("separate", 50)
  //           .addItem("cohesion", 100)
  //           .addItem("pull", 150);
	}

	void draw()
	{
		fft.forward(audioInput.mix);
	
		for (int i = 0; i < fft.avgSize(); i++){
			float avg = fft.getAvg(i);
			noStroke();
			fill(255);
			rect((width-80) + i*2, height-10, 1, -avg/4);
		}
	}

}