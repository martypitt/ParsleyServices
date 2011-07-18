package com.mangofactory.parsley
{
	import flash.events.EventDispatcher;
	
	import mx.messaging.ChannelSet;

	public class DynamicServiceDefinition extends EventDispatcher
	{
		public var type:Class;
		public var destination:String;
		public var endpoint:String;
		public var channelSet:ChannelSet
		
		public static function createForTypeAndDestination(type:Class,destination:String):DynamicServiceDefinition
		{
			var service:DynamicServiceDefinition = new DynamicServiceDefinition();
			service.type = type;
			service.destination = destination;
			return service;
		}
	}
}