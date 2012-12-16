package jp.tp.boids.model
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import jp.tp.boids.BoidsFacade;
	import jp.tp.boids.particle.*;
	import jp.tp.boids.vo.ParticleVO;
	
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
		public var list:Vector.<ParticleVO>;
		
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
			
		}
		
		public function update():void
		{
			if(press1) BoidsParticlesProxy.getInstance().addParticle(new ParticleVO(new Point(Math.random()*500, Math.random()*500)));
				//mousePt)); //addParticle(mousePt);
//			if(press2) addShark(mousePt);
			press2 = false;
			
			var bmd:BitmapData = BoidsBmpProxy.getInstance().bmd;
			if(!bmd) return;
			BoidsParticlesProxy.getInstance().moveParticles();
			
			bmd.lock();            
			bmd.fillRect(bmd.rect, BoidsBmpProxy.getInstance().baseColor);
			
			var list:Vector.<ParticleVO> = BoidsParticlesProxy.getInstance().list;
			for each(var p:ParticleVO in list)
			{
				bmd.draw(p.bmp, p.matrix);
			}
			bmd.unlock();
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