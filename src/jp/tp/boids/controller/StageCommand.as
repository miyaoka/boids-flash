package jp.tp.boids.controller
{	
	
	import jp.tp.boids.constants.BoidsConst;
	import jp.tp.boids.model.BoidsBmpProxy;
	import jp.tp.boids.model.BoidsFrameProxy;
	import jp.tp.boids.model.BoidsStageProxy;
	
	import mx.core.UIComponent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class StageCommand extends SimpleCommand
	{
		public function StageCommand()
		{
			super();
		}
		
		override public function execute(n:INotification):void
		{
			switch(n.getName())
			{
				case BoidsConst.CALL_SET_BOIDS_STAGE:
					BoidsStageProxy.getInstance().boids = (n.getBody() as UIComponent);
					break;
				case BoidsConst.CALL_SET_GROUPS_STAGE:
					BoidsStageProxy.getInstance().groups = (n.getBody() as UIComponent);
					break;
			}
		}

	}
}