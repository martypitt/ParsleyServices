package com.mangofactory.parsley.tag
{
	import com.mangofactory.parsley.DynamicDelegateFactory;
	import com.mangofactory.parsley.DynamicServiceDefinition;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	
	import org.spicefactory.parsley.core.bootstrap.AsyncConfigurationProcessor;
	import org.spicefactory.parsley.core.registry.ObjectDefinition;
	import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
	
	public class DynamicServiceConfigProcessor extends EventDispatcher implements AsyncConfigurationProcessor
	{
		private var delegateFactory:DynamicDelegateFactory;
		public function DynamicServiceConfigProcessor(factory:DynamicDelegateFactory=null)
		{
			this.delegateFactory = factory ? factory : new DynamicDelegateFactory();
		}
		
		public function cancel():void
		{
		}
		public function processConfiguration(registry:ObjectDefinitionRegistry):void
		{
			intialize();
			delegateFactory.addEventListener(Event.COMPLETE,onComplete);
			delegateFactory.addEventListener(IOErrorEvent.IO_ERROR,dispatchEvent);
			delegateFactory.build();
		}

		private function onComplete(event:Event):void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function intialize():void
		{
			if (!DynamicDelegateFactory.initialized)
				DynamicDelegateFactory.initialize();
		}
		
	}
}