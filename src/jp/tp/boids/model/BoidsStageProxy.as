package jp.tp.boids.model
{
	import jp.tp.boids.BoidsFacade;
	import jp.tp.boids.constants.BoidsConst;
	
	import mx.core.UIComponent;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class BoidsStageProxy extends Proxy
	{
		public static const NAME:String = "BoidsStage";
		

		public var boids:UIComponent;
		public var groups:UIComponent;
		
		public function BoidsStageProxy()
		{
			super(NAME);
		}
		
		public static function getInstance():BoidsStageProxy
		{
			if (!BoidsFacade.getInstance().hasProxy(NAME))
			{
				BoidsFacade.getInstance().registerProxy(new BoidsStageProxy());
			}
			return BoidsFacade.getInstance().retrieveProxy(NAME) as BoidsStageProxy;
		}
		
	}
}