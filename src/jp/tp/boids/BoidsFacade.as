package jp.tp.boids
{
	import org.puremvc.as3.patterns.facade.Facade;
	public class BoidsFacade extends Facade
	{
		public function BoidsFacade(enforcer:SingletonEnforcer)
		{
		}
		public static function getInstance():BoidsFacade
		{
			if(!instance)
			{
				instance = new BoidsFacade(new SingletonEnforcer());
			}
			return instance as BoidsFacade
		}
	}
}
class SingletonEnforcer{}