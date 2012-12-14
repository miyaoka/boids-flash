package jp.tp.boids.particle
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;

	public class Sardine extends Fish {
		private static const MAX:Number = 0.08;    //最大の加速度
		private static const MIN:Number = 0;        //最小の加速度
		private var RANGE:Number = 40 //5 + normalDistribution(10, 30);    //視界半径
		private static const PULL:Number = 0.01; //引き寄せる力
		private var PUSH:Number = 0.5// * 5 * RANGE / 40; //離れる力
		private static const WALL:Number = 0.8; //壁から離れる力
		private static const THRUST:Number = 0.05; //前方へ進む力
		private static const RAND:Number = 0.2; //気まぐれの大きさ
		private static const RAND2:Number = 0.5; //気まぐれの大きさ2
		private var shape:Shape = new Shape;
		
		function Sardine( x:Number, y:Number ){
			super( x, y );
			vx = ( 1 - 2 * Math.random() ) * .5;
			vy = ( 1 - 2 * Math.random() ) * .5;
			with ( shape.graphics ) {
				lineStyle (1, 0x333333, .5);	// 線のスタイル指定
				drawCircle( 0, 0, RANGE );
				
				beginFill( 0xffffff, 0.3 );
				lineStyle (1, 0xffffff, .5);	// 線のスタイル指定
				moveTo(0,3);
				lineTo(10,0);
				lineTo(0,-3);
//				drawLine(
//				drawCircle( 0, 0, 0.5)//RANGE / 10 );
			}
//			shape.graphics.drawRect(-RANGE, -RANGE, RANGE, RANGE);
		}
		/**
		 * 正規分布
		 * average: 平均
		 * sd: 標準偏差 (av-sd)から(av+sd)の範囲内が68.26%、2sdが95.44%、3sdが99.74%になる
		 * 
		 * over/under: 平均以上／以下の場合に掛ける係数
		 */ 
		private static function normalDistribution(mean:Number = 0.5, sd:Number= 0.1, over:Number = 1, under:Number = 1):Number
		{
			//独立した乱数2つ
			var r1:Number = 1 - Math.random(); // 0 < x <= 1
			var r2:Number = Math.random(); // 0 <= x < 1
			
			
			//Box-Muller's method
			return sd 
			* Math.sqrt(-2 * Math.log(r1))
				* Math.sin(2 * Math.PI * r2) // 0 ~ 1 ~ 0 ~ -1
				* ((r2 < 0.5) ? over : under) //r2が0.5未満ならsinの上弦で正　：0.5以上なら下弦で負
				+ mean;
		}		
		override public function move():void {
			var f:Number, d:Number, dx:Number, dy:Number;
			if( neighbor is Shark ){
				escape( MAX );
			}else{
				thrust( THRUST, RAND );
				if ( neighbor is Fish ) {
					guide( PULL, PUSH );
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
			if( p is Shark ){
				if ( neighbor is Sardine ) {             
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
			}else if( p is Sardine ){
				if ( neighbor is Shark ) { return; }
				if( Math.random() < RAND2 ){ return; } //時々一番近い魚の以外にも注目する。
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
			var mtx:Matrix = new Matrix()//(1,0,0,1,x,y);
			mtx.rotate(Math.atan2(vy, vx));
			mtx.translate(x,y);
			img.draw( shape, mtx);
		}
	}
}