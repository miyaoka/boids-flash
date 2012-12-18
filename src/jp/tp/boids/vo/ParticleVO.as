package jp.tp.boids.vo
{
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class ParticleVO
	{
		public var vector:Point;
		public var pos:Point;
		public var maxDist:Number;
		public var minDist:Number;
		public var maxSpeed:Number = Math.random() * .1 + 1.0;
		private var _display:Shape;
		public function ParticleVO(
			pos:Point, 
			maxDist:Number = 50, 
			minDist:Number = 20)
		{
			this.pos = pos;
			this.vector = 
					new Point(Math.random() - 0.5, Math.random() - 0.5),
			this.maxDist = Math.random()*Math.random()*Math.random()*Math.random()* 100 + 25// maxDist;
			this.minDist = Math.random()* Math.random()* 5 + 15;
			createDisplay();
		}

		public function get display():Shape
		{
			return _display;
		}
		public function get matrix():Matrix
		{
			var mtx:Matrix = new Matrix();
			mtx.rotate(Math.atan2(vector.y, vector.x));
			mtx.translate(pos.x, pos.y);
			return mtx;
		}
		private function createDisplay():void
		{
			_display = new Shape();
			with ( _display.graphics ) {
				/*
				lineStyle (1, 0x333333, .2);
				drawCircle( 0, 0, maxDist );
				lineStyle (1, 0xffffff, .1);
				drawCircle( 0, 0, minDist );
				*/
				
				lineStyle (null, 0xffffff, 1);
				moveTo(0,3);
				lineTo(10,0);
				lineTo(0,-3);
				lineTo(0,3);
			}
		}
	}
}