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
		private var _bmp:Shape;
		public function ParticleVO(
			pos:Point, 
			maxDist:Number = 50, 
			minDist:Number = 20)
		{
			this.pos = pos;
			this.vector = 
					new Point(Math.random() - 0.5, Math.random() - 0.5),
			this.maxDist = Math.random()*Math.random()* 50 + 12// maxDist;
			this.minDist = Math.random()* 5 + 5;
			createBmp();
		}

		public function get bmp():Shape
		{
			return _bmp;
		}
		public function get matrix():Matrix
		{
			var mtx:Matrix = new Matrix();
			mtx.rotate(Math.atan2(vector.y, vector.x));
			mtx.translate(pos.x, pos.y);
			return mtx;
		}
		private function createBmp():void
		{
			_bmp = new Shape();
			with ( _bmp.graphics ) {
				lineStyle (1, 0x333333, .2);
				drawCircle( 0, 0, maxDist );
				lineStyle (1, 0xffffff, .2);
				drawCircle( 0, 0, minDist );
				
				beginFill( 0xffffff, 0.3 );
				lineStyle (1, 0xffffff, .9);
				moveTo(0,3);
				lineTo(10,0);
				lineTo(0,-3);
			}
		}
	}
}