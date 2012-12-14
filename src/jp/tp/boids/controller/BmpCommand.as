package jp.tp.boids.controller
{	
	
	import flash.geom.Point;
	
	import jp.tp.boids.constants.BoidsConst;
	import jp.tp.boids.model.BoidsBmpProxy;
	import jp.tp.boids.model.BoidsFrameProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class BmpCommand extends SimpleCommand
	{
		public function BmpCommand()
		{
			super();
		}
		
		override public function execute(n:INotification):void
		{
			switch(n.getName())
			{
				case BoidsConst.CALL_RESIZE_BMP:
					BoidsBmpProxy.getInstance().resize(n.getBody() as Point);
					break;
			}
		}

	}
}