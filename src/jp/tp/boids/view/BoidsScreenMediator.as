package jp.tp.boids.view
{
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import jp.tp.boids.constants.BoidsConst;
	import jp.tp.boids.model.BoidsBmpProxy;
	import jp.tp.puremvc.ViewMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class BoidsScreenMediator extends ViewMediator
	{
		public static const NAME:String = "BoidsScreen";
		public function BoidsScreenMediator(view:Object)
		{
			super(view);
			init();
		}
		
		private function init():void
		{
			sendNotification(BoidsConst.CALL_SET_BOIDS_STAGE, view.boids);
			sendNotification(BoidsConst.CALL_SET_GROUPS_STAGE, view.groups);
			
			view.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void 
			{ 
				sendNotification(BoidsConst.CALL_SET_PRESS1_STATE, true);
			});
			view.stage.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void 
			{
				sendNotification(BoidsConst.CALL_SET_PRESS1_STATE, false);
			});
			view.addEventListener(MouseEvent.DOUBLE_CLICK, function(e:MouseEvent):void 
			{ 
				sendNotification(BoidsConst.CALL_SET_PRESS2_STATE, true);
			});
			view.addEventListener(MouseEvent.MOUSE_MOVE, function(e:MouseEvent):void 
			{
				sendNotification(BoidsConst.CALL_SET_MOUSE_POINT, new Point(e.localX, e.localY));
			});
			
			view.doubleClickEnabled = true;
		}
		
		private function get view():BoidsScreen
		{
			return viewComponent as BoidsScreen;
		}
		override public function listNotificationInterests():Array
		{
			return [
			];
		}
		
		override public function handleNotification(n:INotification):void
		{
			switch (n.getName())
			{
			}
		}
	}	
}