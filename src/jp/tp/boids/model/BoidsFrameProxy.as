package jp.tp.boids.model
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	import jp.tp.boids.BoidsFacade;
	import jp.tp.boids.particle.*;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class BoidsFrameProxy extends Proxy
	{
		public static const NAME:String = "BoidsFrame";
		
		public static const MAX:Number = 1000;
		public static const RANGE:Number = 50;//影響半径
		public static const V_DIV:uint = Math.ceil(465 / RANGE); //横方向の分割数
		public static const H_DIV:uint = Math.ceil(465 / RANGE); //縦方向の分割数
		
		private var map:Vector.<Vector.<Vector.<Particle>>>;
		private var particles:Vector.<Particle>;
		
		[Bindable]
		public var numParticles:uint;
		private var color:ColorTransform;
		private var count:int;
		private var press:Boolean;
		
		public var press1:Boolean;
		public var press2:Boolean;
		
		public var mousePt:Point;
		
		public function BoidsFrameProxy()
		{
			super(NAME);
			
			color = new ColorTransform( 0.80, 0.80, 0.85, 1, -3,-2,-2 );
			particles = new Vector.<Particle>();
			numParticles = 0;
			count = 0;
			map = new Vector.< Vector.< Vector.<Particle> > >(H_DIV);
			map.fixed = true;
			for(var i:uint = 0; i<H_DIV; i++ ){
				map[i] = new Vector.< Vector.<Particle> >(V_DIV);
				map[i].fixed = true;
				for(var j:uint = 0; j<H_DIV; j++ ){
					map[i][j] = new Vector.< Particle >; 
				}
			}
			
		}
		
		public function update():void
		{
			if(press1) addSardine(mousePt);
			if(press2) addShark(mousePt);
			press2 = false;
			
			var bmd:BitmapData = BoidsBmpProxy.getInstance().bmd;
			if(!bmd) return;
			bmd.lock();            
			//				img.colorTransform(img.rect, color);
			bmd.fillRect(bmd.rect, BoidsBmpProxy.getInstance().baseColor);
			setNeighbors();
			moveParticles();
			bmd.unlock();
			//				text.text = "numParticles: " + numParticles;
		}
		private function addSardine(pt:Point):void {
			if( numParticles < MAX ){
				const p:Particle = particles[numParticles++] = new Sardine( pt.x, pt.y );
				p.move();
			}
		}
		
		private function addShark(pt:Point):void {
			const p:Particle = particles[numParticles++] = new Shark( pt.x, pt.y );
			p.move();
		}
		
		private function setNeighbors():void {
			var dx:Number, dy:Number;
			const particles:Vector.<Particle> = this.particles;
			
			//分割された各領域ごとで近くのパーティクルをさがす。
			for(var i:uint= 0; i < H_DIV; i++) {
				const mapi:Vector.<Vector.<Particle>> = map[i];
				for(var j:uint = 0; j < V_DIV; j++){
					var mapij:Vector.<Particle> = mapi[j];
					var minN:int = i-1; if( minN < 0 ){ minN = 0 }
					var minM:int = j-1; if( minM < 0 ){ minM = 0 }
					var maxN:int = i+2; if( maxN > H_DIV ){ maxN = H_DIV }
					var maxM:int = j+2; if( maxM > V_DIV ){ maxM = V_DIV }
					for each( var pi:Particle in mapij ){
						l:{
							for(var n:uint = minN; n < maxN; n++ ){
								const mapn:Vector.<Vector.<Particle>> = map[n];
								for(var m:uint = minM; m < maxM; m++ ){
									const mapnm:Vector.<Particle> = mapn[m];
									for each(var pj:Particle in mapnm ){
										//piと同じパーティクルが現れたら終了
										if ( pi == pj ) { break l; }
										pi.lookAt( pj );
										pj.lookAt( pi );
									}
								}
							}
						}
					}
				}
			}
		}
		
		private function moveParticles():void {
			count++;
			const img:BitmapData = BoidsBmpProxy.getInstance().bmd;
			const particles:Vector.<Particle> = this.particles;
			
			for(var i:uint = 0; i < numParticles; i++) {
				const pi:Particle = particles[i];
				if ( pi.life <= 0 ) {
					particles.splice( i, 1 );
					pi.moveMap( map );
					numParticles--;
					i--;
				}else{
					pi.move();
					pi.moveMap( map );
					pi.draw( img );
				}
			}			
		}		
		public static function getInstance():BoidsFrameProxy
		{
			if (!BoidsFacade.getInstance().hasProxy(NAME))
			{
				BoidsFacade.getInstance().registerProxy(new BoidsFrameProxy());
			}
			return BoidsFacade.getInstance().retrieveProxy(NAME) as BoidsFrameProxy;
		}
		
	}
}