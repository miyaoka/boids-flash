package jp.tp.boids.model
{
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import jp.tp.boids.BoidsFacade;
	import jp.tp.boids.constants.BoidsConst;
	import jp.tp.boids.vo.ParticleVO;
	
	import mx.core.UIComponent;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class BoidsParticlesProxy extends Proxy
	{
		public static const NAME:String = "BoidsParticles";
		public var list:Vector.<ParticleVO> = new Vector.<ParticleVO>();
		
		
		public function BoidsParticlesProxy()
		{
			super(NAME);
		}
		public function addParticle():void 
		{
			var stage:UIComponent = BoidsStageProxy.getInstance().boids;
			if(!stage) return;

			var vo:ParticleVO = new ParticleVO(new Point(Math.random() * stage.width, Math.random() * stage.height));
			list.push(vo);
			stage.addChild(vo.display);
		}
		public function moveParticles():void 
		{
			var stage:UIComponent = BoidsStageProxy.getInstance().boids;
			var groups:UIComponent = BoidsStageProxy.getInstance().groups;
			if(!stage || !groups) return;
			
			groups.removeChildren();
			
			var rect:Rectangle = new Rectangle(0, 0, stage.width, stage.height);
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
					var dist:Number = Point.distance(p2.pos, p.pos);
					if(dist > p.maxDist) continue;
					maxList.push(p2);
					
					if(p2 == p) continue;
					if(dist > p.minDist) continue;
					minList.push(p2);
				}
				
				
//				p.vector.x *= 0.9;
//				p.vector.x *= 0.9;
				var v:Point = separation(p,minList).add(
					cohesion(p, maxList).add(
						alignment(p, maxList)
					)
				);// + bounding(p);
//				v = alignment(p, maxList);
				v.x *= 0.02;
				v.y *= 0.02;
				v = v.add(bounding(p, rect));
				p.vector = p.vector.add(v);
				if( (Math.abs(p.vector.x) > p.maxSpeed) || (Math.abs(p.vector.y) > p.maxSpeed))
				{
					p.vector.normalize(p.maxSpeed);
				}
				p.pos = p.pos.add(p.vector);
				p.display.x = p.pos.x;
				p.display.y = p.pos.y;
				p.display.rotation = Math.atan2(p.vector.y, p.vector.x) * 180 / Math.PI;
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
			
			if(targetList.length > 1)
			{
				var shape:Shape = new Shape();
				
				with ( shape.graphics) {
					lineStyle (null, 0x00ffff, 0.2);
					drawCircle( 0, 0, vo.maxDist );
					moveTo(-4, 0);
					lineTo(4, 0);
					moveTo(0, 4);
					lineTo(0, -4);
				}		
				var groups:UIComponent = BoidsStageProxy.getInstance().groups;
				shape.x = center.x;
				shape.y = center.y;
				groups.addChild(shape);
				
			}
			
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