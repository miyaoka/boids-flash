package jp.tp.boids.particle
{
	import flash.display.BitmapData;
	
	import jp.tp.boids.model.BoidsFrameProxy;

	public class Particle
	{
		public var x:Number;    //x方向の位置
		public var y:Number;    //y方向の位置
		public var mapX:uint;    
		public var mapY:uint;    
		public var vx:Number;   //vx方向の位置
		public var vy:Number;   //vy方向の位置
		public var fx:Number;   //x方向の加速度
		public var fy:Number;   //y方向の加速度
		public static const DF:Number = 0.96; //抵抗係数
		public var color:uint = 0xFFFFFF;
		public var life:int = 1;
		
		public function Particle(x:Number, y:Number) {
			this.x = x;
			this.y = y;
			vx = vy = 0;
			fx = fy = 0;
		}
		
		public function move():void {
			x += vx += fx;
			y += vy += fy;
			vx *= DF;
			vy *= DF;
			fx = 0;
			fy = 0;
			
			if (x < 1 ) { vy = 0; vx = 0; x = 1; }
			else if(x > 464 ){ vy = 0; vx = 0; x = 464 }
			if(y < 1 ){ vy = 0; vx = 0; y = 1; }
			else if(y > 464 ){ vy = 0; vx = 0; y = 464 }   
		}
		
		public function lookAt( p:Particle ):void {}
		
		public function moveMap( map:Vector.<Vector.<Vector.<Particle>>> ):void {
			const mx:int = this.x / BoidsFrameProxy.RANGE;
			const my:int = this.y / BoidsFrameProxy.RANGE;
			const pmx:int = this.mapX;
			const pmy:int = this.mapY;
			if( life == 0 || mx != pmx || my != pmy ){
				const mp:Vector.<Particle> = map[ pmx ][ pmy ]
				const index:int = mp.indexOf( this );
				if ( index != -1) {
					mp.splice( index, 1 );
				}
				if( life != 0 ){
					map[ mx ][ my ].push( this );
					this.mapY = my; this.mapX = mx;
				}
			}
		}
		
		public function draw( img:BitmapData ):void{
			img.setPixel( x, y, color )
		}
	}
}