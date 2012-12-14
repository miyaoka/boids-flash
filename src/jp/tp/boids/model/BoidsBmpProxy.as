package jp.tp.boids.model
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import jp.tp.boids.BoidsFacade;
	import jp.tp.boids.constants.BoidsConst;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class BoidsBmpProxy extends Proxy
	{
		public static const NAME:String = "BoidsBmp";
		
		public var bmd:BitmapData;
		
		private var _width:Number;
		private var _height:Number;
		
		public var baseColor:uint = 0x009999;
		
		public function BoidsBmpProxy()
		{
			super(NAME);
		}
		
		[Bindable]
		public function get height():Number
		{
			return _height;
		}

		public function set height(value:Number):void
		{
			_height = value;
		}

		[Bindable]
		public function get width():Number
		{
			return _width;
		}

		public function set width(value:Number):void
		{
			_width = value;
		}
		
		public function resize(pt:Point):void
		{
			if(bmd && bmd.width == pt.x && bmd.height == pt.y) return;
			bmd = new BitmapData(pt.x, pt.y, false, baseColor);
			sendNotification(BoidsConst.UPDATE_BMP, bmd);
		}
		public function clear():void
		{
			
		}

		public static function getInstance():BoidsBmpProxy
		{
			if (!BoidsFacade.getInstance().hasProxy(NAME))
			{
				BoidsFacade.getInstance().registerProxy(new BoidsBmpProxy());
			}
			return BoidsFacade.getInstance().retrieveProxy(NAME) as BoidsBmpProxy;
		}
		
	}
}