package jp.tp.boids.particle
{
	public class Fish extends Particle {
		public var neighbor:Particle;
		public var d2:Number;
		public var dx:Number;
		public var dy:Number;
		
		function Fish( x:Number, y:Number ){
			super( x, y );
		}
		
		//壁際の処理
		protected function wall( push:Number, r:Number ):void{
			if ( x < r ) { fx += push / x; }
			else if ( x > 465 - r ) { fx -= push / (465 - x); }
			if ( y < r ) { fy += push / y; }
			else if ( y > 465 - r ) { fy -= push / (465 - y); }
		}
		
		//前方に加速
		protected function thrust( f:Number, r:Number ):void {
			var vx2:Number = r * ( 1 - 2 * Math.random() ) + vx;
			var vy2:Number = r * ( 1 - 2 * Math.random() ) + vy;
			var v:Number = f * Math.random() / Math.sqrt( vx2 * vx2 + vy2 * vy2 );
			fx += vx2 * v;
			fy += vy2 * v;
		}
		
		protected function guide( pull:Number, push:Number ):void {
			var d:Number = Math.sqrt( d2 );
			var f:Number = -push/(d*d) + pull;
			fx += dx * f;
			fy += dy * f;
		}
		protected function escape( f:Number ):void {
			var r:Number = f / Math.sqrt( dx*dx + dy*dy );
			fx -= dx * r;
			fy -= dy * r;
		}
		protected function chase( f:Number ):void {
			var r:Number = f// / Math.sqrt( dx*dx + dy*dy );
			fx += dx * r;
			fy += dy * r;
		}
		
		//速度を丸める
		protected function round( min:Number, max:Number ):void{
			var f2:Number = fx * fx + fy * fy;
			var r:Number;
			if ( f2 == 0 ) {
			}else{
				if ( f2 < min*min ) {
					r = min / Math.sqrt( f2 );
					fx *= r;
					fy *= r;
				}else if( f2 > max*max ){
					r = max / Math.sqrt( f2 );
					fx *= r;
					fy *= r;
				}
			}
		}
	}	
}