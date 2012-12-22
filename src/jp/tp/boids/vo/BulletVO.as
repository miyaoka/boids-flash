package jp.tp.boids.vo
{
	import flash.display.Shape;
	import flash.geom.Point;
	
	public class BulletVO extends ParticleVO
	{
		public function BulletVO(pos:Point, type:uint)
		{
			life = 60;
			this.type = type;
			super(pos);
		}
		override protected function createDisplay():void
		{		
			_display = new Shape();
			with ( _display.graphics ) {
				
				lineStyle (1, color, 1);
				moveTo(0,1);
				lineTo(4,0);
				lineTo(0,-1);
				lineTo(0,1);
			}
		}		
	}
}