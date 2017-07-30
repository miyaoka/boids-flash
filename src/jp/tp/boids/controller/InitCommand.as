package jp.tp.boids.controller
{	
	
	import jp.tp.boids.constants.BoidsConst;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class InitCommand extends SimpleCommand
	{
		public function InitCommand()
		{
			super();
		}
		
		override public function execute(n:INotification):void
		{
			facade.registerCommand(BoidsConst.CALL_UPDATE_FRAME, FrameCommand);
			facade.registerCommand(BoidsConst.CALL_SET_PRESS1_STATE, FrameCommand);
			facade.registerCommand(BoidsConst.CALL_SET_PRESS2_STATE, FrameCommand);
			facade.registerCommand(BoidsConst.CALL_SET_MOUSE_POINT, FrameCommand);
			
			facade.registerCommand(BoidsConst.CALL_RESIZE_BMP, BmpCommand);
			facade.registerCommand(BoidsConst.CALL_SET_BOIDS_STAGE, StageCommand);
			facade.registerCommand(BoidsConst.CALL_SET_GROUPS_STAGE, StageCommand);
			
		}

	}
}