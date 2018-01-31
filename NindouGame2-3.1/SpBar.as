package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	
	public class SpBar extends MovieClip
	{
		var color:ColorTransform = new ColorTransform();
		
		public function SpBar()
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			meter.width = 0;
		}
		
		private function onEnterFrame(event:Event):void
		{
			if (MovieClip(parent) != null)
			{
				MovieClip(parent).spAdd(this);
			}

			//almost SP 1
			if (meter.width == 0)
			{
				color.color = 0xFFFFFF;
				spText.text = "";
			}
			if (meter.width < 40 && meter.width > 0)
			{
				color.color = 0xAED73D;
				spText.text = "";
			}
			//SP 1
			else if (meter.width >= 40 && meter.width < 80)
			{
				color.color = 0xE946A3;
				spText.text = "SP 1";
			}
			//SP 2
			else if (meter.width >= 80 && meter.width < 120)
			{
				color.color = 0x79A8D6;
				spText.text = "SP 2";
			}
			//SP 3, aka SP MAX
			else if (meter.width >= 120)
			{
				color.color = 0x82F4EC;
				spText.text = "SP 3";
			}
			
			meter.transform.colorTransform = color;
			spCircle.transform.colorTransform = color;
		}
	}
}