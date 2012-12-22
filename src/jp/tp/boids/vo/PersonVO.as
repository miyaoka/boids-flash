package jp.tp.boids.vo
{
	import flash.display.Shape;
	import flash.geom.Point;
	
	public class PersonVO extends ParticleVO
	{
		public var cohesionDist:Number;
		public var separationDist:Number;
		public var shootDist:Number;
		public var heat:Number = 0 + Math.random() * 50;
		
		public function PersonVO(pos:Point)
		{
			life = 10;
			this.vector = new Point(Math.random() - 0.5, Math.random() - 0.5),
			this.cohesionDist = Math.random()*Math.random()*Math.random()*Math.random() * 150 + 70;
			this.separationDist = Math.random()* Math.random()* 30 + 25;
			this.shootDist = 150;
			type = Math.floor(Math.random() * 5);
			super(pos);
			
		}
		override protected function createDisplay():void
		{
			_display = new Shape();
			with ( _display.graphics ) {
				/*
				lineStyle (null, 0xffffff, .1);
				drawCircle( 0, 0, cohesionDist );
				lineStyle (null, 0xffffff, .1);
				drawCircle( 0, 0, separationDist );
				*/
				
				lineStyle (null, color, 1);
				moveTo(-5,6);
				lineTo(10,0);
				lineTo(-5,-6);
				lineTo(-5,6);
			}			
		}
	}
}