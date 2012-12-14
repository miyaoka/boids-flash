package jp.tp.boids.view
{
	
	import flash.events.Event;
	
	import jp.tp.boids.constants.BoidsConst;
	import jp.tp.boids.model.BoidsBmpProxy;
	import jp.tp.puremvc.ViewMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class BoidsMainViewMediator extends ViewMediator
	{
		public static const NAME:String = "BoidsMainView";
		public function BoidsMainViewMediator(view:Object)
		{
			super(view);
			this.view.addEventListener(Event.EXIT_FRAME, onFrame);
		}
		private function onFrame(e:Event):void
		{
			sendNotification(BoidsConst.CALL_UPDATE_FRAME);
		}
		private function get view():BoidsMainView
		{
			return viewComponent as BoidsMainView;
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