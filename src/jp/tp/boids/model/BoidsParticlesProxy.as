package jp.tp.boids.model
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import jp.tp.boids.BoidsFacade;
	import jp.tp.boids.constants.BoidsConst;
	import jp.tp.boids.vo.ParticleVO;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class BoidsParticlesProxy extends Proxy
	{
		public static const NAME:String = "BoidsParticles";
		public var list:Vector.<ParticleVO> = new Vector.<ParticleVO>();
		
		
		public function BoidsParticlesProxy()
		{
			super(NAME);
		}
		public function addParticle(vo:ParticleVO):void 
		{
//			if( list.length >= MAX ) return;
			list.push(vo);
		}
		public function moveParticles():void 
		{
			var rect:Rectangle = BoidsBmpProxy.getInstance().bmd.rect;
			var margin:Number = 40;
			rect.left += margin;
			rect.top += margin;
			rect.right -= margin;
			rect.bottom -= margin;
			var timer:int;
			
			for each(var p:ParticleVO in list)
			{
				var maxList:Vector.<ParticleVO> = new Vector.<ParticleVO>();
				var minList:Vector.<ParticleVO> = new Vector.<ParticleVO>();
				for each(var p2:ParticleVO in list)
				{
					if(p2 == p) continue;
					var dist:Number = Point.distance(p2.pos, p.pos);
					if(dist > p.maxDist) continue;
					maxList.push(p2);
					if(dist > p.minDist) continue;
					minList.push(p2);
				}
				
				
//				p.vector.x *= 0.9;
//				p.vector.x *= 0.9;
				var v:Point = separation(p,minList).add(
					cohesion(p, maxList).add(
						bounding(p, rect).add(
							alignment(p, maxList)
						)
					)
				);// + bounding(p);
//				v = alignment(p, maxList);
				v.x *= 0.02;
				v.y *= 0.02;
				p.vector = p.vector.add(v);
				if( (Math.abs(p.vector.x) > 1) || (Math.abs(p.vector.y) > 1))
				{
					p.vector.normalize(1);
				}
				p.pos = p.pos.add(p.vector);
			}
		}	
		private function separation(vo:ParticleVO, targetList:Vector.<ParticleVO>):Point
		{
			if(targetList.length < 1) return new Point();

			var center:Point = new Point();
			for each(var p:ParticleVO in targetList)
			{
				center = center.add(p.pos);
			}
			center.x /= targetList.length;
			center.y /= targetList.length;
			
			var v:Point = vo.pos.subtract(center);
			v.x *= 0.05 * 10;
			v.y *= 0.05 * 10;
			
			return v;
		}
		private function alignment(vo:ParticleVO, targetList:Vector.<ParticleVO>):Point
		{
			var timer:int = getTimer();
			if(targetList.length < 1) return new Point();
			
			var center:Point = new Point();
			for each(var p:ParticleVO in targetList)
			{
				center = center.add(p.vector);
			}
			center.x /= targetList.length;
			center.y /= targetList.length;
			var v:Point = center//.subtract(vo.vector);
			v.x *= 0.01 * 10 * 2;
			v.y *= 0.01 * 10 * 2;
			return v;
		}
		private function cohesion(vo:ParticleVO, targetList:Vector.<ParticleVO>):Point
		{
			if(targetList.length < 1) return new Point();
			
			var center:Point = new Point();
			for each(var p:ParticleVO in targetList)
			{
				center = center.add(p.pos);
			}
			center.x /= targetList.length;
			center.y /= targetList.length;
			
			var v:Point = center.subtract(vo.pos);
			v.x *= 0.01 * 5;
			v.y *= 0.01 * 5;
			return v;
		}
		private function bounding(vo:ParticleVO, rect:Rectangle):Point
		{
			var v:Point = new Point();
			if(rect.left > vo.pos.x) v.x += 2;
			if(rect.right < vo.pos.x) v.x -= 2;
			if(rect.top > vo.pos.y) v.y += 2;
			if(rect.bottom < vo.pos.y) v.y -= 2;
			
			
			return v;
		}		


		public static function getInstance():BoidsParticlesProxy
		{
			if (!BoidsFacade.getInstance().hasProxy(NAME))
			{
				BoidsFacade.getInstance().registerProxy(new BoidsParticlesProxy());
			}
			return BoidsFacade.getInstance().retrieveProxy(NAME) as BoidsParticlesProxy;
		}
		
	}
}