package jp.tp.boids.controller
{	
	
	import flash.geom.Point;
	
	import jp.tp.boids.constants.BoidsConst;
	import jp.tp.boids.model.BoidsFrameProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class FrameCommand extends SimpleCommand
	{
		public function FrameCommand()
		{
			super();
		}
		
		override public function execute(n:INotification):void
		{
			switch(n.getName())
			{
				case BoidsConst.CALL_UPDATE_FRAME:
					BoidsFrameProxy.getInstance().update();
					break;
				case BoidsConst.CALL_SET_PRESS1_STATE:
					BoidsFrameProxy.getInstance().press1 = n.getBody() as Boolean;
					break;
				case BoidsConst.CALL_SET_PRESS2_STATE:
					BoidsFrameProxy.getInstance().press2 = n.getBody() as Boolean;
					break;
				case BoidsConst.CALL_SET_MOUSE_POINT:
					BoidsFrameProxy.getInstance().mousePt = n.getBody() as Point;
					break;
			}
		}

	}
}