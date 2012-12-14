package jp.tp.boids.particle
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;

	public class Shark extends Fish {
		private static const MAX:Number = 0.1;    //最大の加速度
		private static const MIN:Number = 0.06;        //最小の加速度
		private static const RANGE:Number = 50;    //視界半径
		private static const PUSH:Number = 0.5; //離れる力
		private static const WALL:Number = 1; //壁から離れる力
		private static const THRUST:Number = 0.08; //前方へ進む力
		private static const RAND:Number = 1; //気まぐれの大きさ
		private static const SIZE:Number = 2;
		private var shape:Shape = new Shape;
		
		function Shark( x:Number, y:Number ){
			super( x, y );
			vx = ( 1 - 2 * Math.random() ) * .5;
			vy = ( 1 - 2 * Math.random() ) * .5;
			with ( shape.graphics ) {
				beginFill( 0x6688FF, 1 );
				drawCircle( 0, 0, SIZE );
			}
		}
		
		override public function move():void {
			var f:Number, d:Number, dx:Number, dy:Number;
			if ( neighbor is Sardine ) {
				chase( MAX );
			}else {
				thrust( THRUST, RAND );
				if( neighbor is Shark ){
					guide( 0, PUSH )
				}
			}
			neighbor = null;
			d2 = RANGE * RANGE;
			wall( WALL, RANGE );
			round( MIN, MAX );
			super.move();
		}
		
		override public function lookAt( p:Particle ):void {
			var dx:Number, dy:Number, d2:Number;
			if( p is Sardine ){
				if ( neighbor is Shark ) {             
					this.dx = p.x - x;
					this.dy = p.y - y;
					this.d2 = dx * dx + dy * dy;
					neighbor = p;
					return;
				}
				dx = p.x - x;
				dy = p.y - y;
				d2 = dx * dx + dy * dy;
				if ( d2 < this.d2 ) {
					this.d2 = d2;
					this.dx = dx;
					this.dy = dy;
					neighbor = p;
				}
				if( d2 < SIZE*SIZE ){ p.life = 0; }
			}else if( p is Shark ){
				if ( neighbor is Sardine ) { return; }
				dx = p.x - x;
				dy = p.y - y;
				d2 = dx * dx + dy * dy;
				if ( d2 < this.d2 ) {
					this.d2 = d2;
					this.dx = dx;
					this.dy = dy;
					neighbor = p;
				}
			}
		}
		override public function draw(img:BitmapData):void {
			img.draw( shape, new Matrix(1,0,0,1,x,y) );
		}
	}
}