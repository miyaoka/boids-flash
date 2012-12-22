package jp.tp.boids.model
{
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import jp.tp.boids.BoidsFacade;
	import jp.tp.boids.constants.BoidsConst;
	import jp.tp.boids.vo.BulletVO;
	import jp.tp.boids.vo.PersonVO;
	
	import mx.core.UIComponent;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class BoidsParticlesProxy extends Proxy
	{
		public static const NAME:String = "BoidsParticles";
		public var persons:Vector.<PersonVO> = new Vector.<PersonVO>();
		public var bullets:Vector.<BulletVO> = new Vector.<BulletVO>();
		
		private var count:int = 0;
		
		
		public function BoidsParticlesProxy()
		{
			super(NAME);
		}
		public function addParticle():void 
		{
			var stage:UIComponent = BoidsStageProxy.getInstance().boids;
			if(!stage) return;

			var vo:PersonVO = new PersonVO(new Point(Math.random() * stage.width, Math.random() * stage.height));
			persons.push(vo);
			vo.display.x = vo.pos.x;
			vo.display.y = vo.pos.y;
			stage.addChild(vo.display);
		}
		public function moveParticles():void 
		{
			var stage:UIComponent = BoidsStageProxy.getInstance().boids;
			var groups:UIComponent = BoidsStageProxy.getInstance().groups;
			if(!stage || !groups) return;
			
			
			var rect:Rectangle = new Rectangle(0, 0, stage.width, stage.height);
			var margin:Number = 80;
			rect.left += margin;
			rect.top += margin;
			rect.right -= margin;
			rect.bottom -= margin;
			var timer:int;
			count = (++count) % 5;
			if(count==0) 
			{
				groups.removeChildren();
				groups.alpha = 1.0;
			}
			else
			{
				groups.alpha *= 0.97;
			}
			
			moveBullets();
			
			for each(var p:PersonVO in persons)
			{
				if(count==0)
				{
					var cohesionList:Vector.<PersonVO> = new Vector.<PersonVO>();
					var separationDist:Vector.<PersonVO> = new Vector.<PersonVO>();
					var shootDist:Vector.<PersonVO> = new Vector.<PersonVO>();
					for each(var p2:PersonVO in persons)
					{
						var dist:Number;
						dist = Point.distance(p2.pos, p.pos);
						if(p2.type != p.type)
						{
							if(dist > p.shootDist) continue;
							shootDist.push(p2);
						}
						if(dist < p.cohesionDist) cohesionList.push(p2);
						
						if(p2 == p) continue;
						if(dist > p.separationDist) continue;
						separationDist.push(p2);
					}
					
					var v:Point = separation(p,separationDist).add(
						cohesion(p, cohesionList).add(
							alignment(p, cohesionList)
						)
					);
					shoot(p, shootDist);
					
					v.x *= 0.02;
					v.y *= 0.02;
					v = v.add(bounding(p, rect));
					p.vector = p.vector.add(v);
					
					if( (Math.abs(p.vector.x) > p.maxSpeed) || (Math.abs(p.vector.y) > p.maxSpeed))
					{
						p.vector.normalize(p.maxSpeed);
					}
				}
				p.pos = p.pos.add(p.vector);
				p.display.x = p.pos.x;
				p.display.y = p.pos.y;
				p.display.rotation = Math.atan2(p.vector.y, p.vector.x) * 180 / Math.PI;
			}

		}
		private function moveBullets():void
		{
			var stage:UIComponent = BoidsStageProxy.getInstance().boids;
			if(!stage) return;			
			l: for (var i:int = 0; i < bullets.length; i++)
			{
				var b:BulletVO = bullets[i];
				b.pos = b.pos.add(b.vector);
				b.display.x = b.pos.x;
				b.display.y = b.pos.y;
				b.display.rotation = Math.atan2(b.vector.y, b.vector.x) * 180 / Math.PI;

				for (var j:int = 0; j < persons.length; j++)
				{
					var p:PersonVO = persons[j];
					if(p.type != b.type && Point.distance(b.pos, p.pos) < 6)
					{
						p.life = (p.type != b.type) ? p.life -1 : p.life - 0.2;
						p.display.scaleX *= 0.98;
						p.display.scaleY *= 0.95;
//						p.cohesionDist *= 0.9;
//						p.separationDist *= 0.9;
//						p.shootDist *= 0.9;
//						p.maxSpeed *= 0.95;
						
						p.pos.x += b.vector.x * (Math.random()*2 + 2.0);
						p.pos.y += b.vector.y * (Math.random()*2 + 2.0);
						p.vector.x += b.vector.x * (Math.random() * 0.05 + 0.05);
						p.vector.y += b.vector.y * (Math.random() * 0.05 + 0.05);
						
						p.vector.normalize(p.maxSpeed);
						
						stage.removeChild(b.display);				
						bullets.splice(i,1);
						i--;
						
						if(p.life < 0)
						{
							stage.removeChild(p.display);
							persons.splice(j,1);
							j--;
						}
						continue l;
					}
				}
				if(--b.life < 0)
				{
					stage.removeChild(b.display);				
					bullets.splice(i,1);
					i--;
				}
			}			
		}
		private function separation(vo:PersonVO, targetList:Vector.<PersonVO>):Point
		{
			if(targetList.length < 1) return new Point();

			var center:Point = new Point();
			for each(var p:PersonVO in targetList)
			{
				center = center.add(p.pos);
			}
			center.x /= targetList.length;
			center.y /= targetList.length;
			
			var v:Point = vo.pos.subtract(center);
			v.x *= 0.7;
			v.y *= 0.7;
			
			return v;
		}
		private function alignment(vo:PersonVO, targetList:Vector.<PersonVO>):Point
		{
			var timer:int = getTimer();
			if(targetList.length < 1) return new Point();
			
			var center:Point = new Point();
			for each(var p:PersonVO in targetList)
			{
				center = center.add(p.vector);
			}
			center.x /= targetList.length;
			center.y /= targetList.length;
			var v:Point = center//.subtract(vo.vector);
			v.x *= 2.5;
			v.y *= 2.5;
			return v;
		}
		private function cohesion(vo:PersonVO, targetList:Vector.<PersonVO>):Point
		{
			if(targetList.length < 1) return new Point();
			
			var friendCenter:Point = new Point();
			var enemyCenter:Point = new Point();
			var friends:Number = 0;
			var enemys:Number = 0;
			for each(var p:PersonVO in targetList)
			{
				if(p.type == vo.type)
				{
					friendCenter = friendCenter.add(p.pos);
					friends++;
				}
				else
				{
					enemyCenter = enemyCenter.add(p.pos);
					enemys++;
				}
			}
			
			
			if(friends > 0)
			{
				friendCenter.x /= friends;
				friendCenter.y /= friends;
				
				if(friends > 1)
				{
					var shape:Shape = new Shape();
									
					with ( shape.graphics) {
						lineStyle (1, vo.color, 0.2);
						drawCircle( 0, 0, vo.cohesionDist );
						moveTo(-4, 0);
						lineTo(4, 0);
						moveTo(0, 4);
						lineTo(0, -4);
					}		
					var groups:UIComponent = BoidsStageProxy.getInstance().groups;
					shape.x = friendCenter.x;
					shape.y = friendCenter.y;
					groups.addChild(shape);
				}
			}
			if(enemys > 0)
			{
				enemyCenter.x /= enemys;
				enemyCenter.y /= enemys;
			}			
			var v:Point = friendCenter.subtract(vo.pos);
			if(enemys > 0) v = v.add(vo.pos.subtract(enemyCenter));
			
			v.x *= 0.3;
			v.y *= 0.3;
			return v;
		}
		private function bounding(vo:PersonVO, rect:Rectangle):Point
		{
			var v:Point = new Point();
			if(rect.left > vo.pos.x) v.x += .1;
			if(rect.right < vo.pos.x) v.x -= .1;
			if(rect.top > vo.pos.y) v.y += .1;
			if(rect.bottom < vo.pos.y) v.y -= .1;
			
			
			return v;
		}		
		private function shoot(vo:PersonVO, targetList:Vector.<PersonVO>):void
		{
			if(targetList.length < 1) return;
			vo.heat = --vo.heat < 0 ? 0 : vo.heat;
			if(vo.heat > 100) return;
			
			var minRot:Number;
			for each(var p:PersonVO in targetList)
			{
				//-2PI ~ 2PI -> 0 ~ 2PI
				var rotDiff:Number = Math.abs(Math.atan2(p.pos.y - vo.pos.y, p.pos.x - vo.pos.x) - Math.atan2(vo.vector.y, vo.vector.x));
				//0 ~ 2PI -> 0 ~ PI
				if(rotDiff > Math.PI) rotDiff = Math.abs((rotDiff - Math.PI * 2));
				
				minRot = !minRot ? rotDiff : (rotDiff < minRot ? rotDiff : minRot);
			}			
			
			if(minRot > Math.PI * 0.1) 
			{
				vo.heat *= 0.9;

				return;
			}
			var stage:UIComponent = BoidsStageProxy.getInstance().boids;
			if(!stage) return;
			
			var b:BulletVO = new BulletVO(vo.pos.clone(), vo.type);
			b.vector = vo.vector.clone();
			b.vector.normalize(3.0);
			bullets.push(b);
			b.display.x = b.pos.x;
			b.display.y = b.pos.y;
			stage.addChild(b.display);
			
			vo.heat+=30;
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