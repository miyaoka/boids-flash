package jp.tp.boids.vo
{
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class ParticleVO
	{
		public var vector:Point;
		public var pos:Point;
		public var maxSpeed:Number = Math.random() * 0.5 + 0.5;
		public var life:Number = 0;
		public var type:int = 0;
		protected var _display:Shape;
		public function ParticleVO(pos:Point)
		{
			this.pos = pos;
			createDisplay();
		}

		public function get display():Shape
		{
			return _display;
		}
		public function get color():uint
		{
			var color:uint;
			switch(type)
			{
				case 0:
					color = 0xffffff;
					break;
				case 1:
					color = 0xff0000;
					break;
				case 2:
					color = 0x00ff00;
					break;
				case 3:
					color = 0x0000ff;
					break;
			}			
			return color;
		}
		protected function createDisplay():void
		{
			_display = new Shape();
			with ( _display.graphics ) {
				lineStyle (null, 0xffffff, .1);
				drawCircle( 0, 0, maxDist );
				lineStyle (null, 0xffffff, .1);
				drawCircle( 0, 0, minDist );
				
				lineStyle (2, color, 1);
				moveTo(0,3);
				lineTo(10,0);
				lineTo(0,-3);
				lineTo(0,3);
			}
		}
	}
}