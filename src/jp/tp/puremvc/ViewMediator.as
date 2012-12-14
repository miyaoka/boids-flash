package jp.tp.puremvc
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.utils.UIDUtil;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class ViewMediator extends Mediator
	{
		public function ViewMediator(viewComponent:Object=null)
		{
			super(NAME + UIDUtil.getUID(viewComponent), viewComponent);
			(viewComponent as DisplayObject).addEventListener(Event.REMOVED_FROM_STAGE, _onViewRemoved);
		}
		public static function getInstance(view:Object, facade:IFacade):Mediator
		{
			return facade.retrieveMediator(NAME + UIDUtil.getUID(view)) as Mediator;
		}
		protected function onViewRemoved(e:Event):void
		{
			(viewComponent as DisplayObject).removeEventListener(Event.REMOVED_FROM_STAGE, _onViewRemoved);
			facade.removeMediator(NAME + UIDUtil.getUID(viewComponent));
		}
		private function _onViewRemoved(e:Event):void
		{
			if (e.target != viewComponent) return;
			onViewRemoved(e);
		}
	}
}