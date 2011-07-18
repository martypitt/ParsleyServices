package com.mangofactory.parsley.tag
{
	import com.mangofactory.parsley.DynamicDelegateFactory;
	import com.mangofactory.parsley.config.DefaultDynamicServiceContext;
	
	import flash.events.EventDispatcher;
	
	import org.spicefactory.parsley.core.bootstrap.BootstrapConfig;
	import org.spicefactory.parsley.flex.tag.builder.BootstrapConfigProcessor;

	public class DynamicServiceSupport extends EventDispatcher implements BootstrapConfigProcessor 
	{
		public var factory:DynamicDelegateFactory;
		
		public function DynamicServiceSupport(factory:DynamicDelegateFactory=null)
		{
			this.factory = factory ? factory : DefaultDynamicServiceContext.getInstance().getDynamicDelegateFactory(); 
		}
		
		public function processConfig(config:BootstrapConfig):void
		{
			var processor:DynamicServiceConfigProcessor = new DynamicServiceConfigProcessor(factory);
			config.addProcessor(processor);
		}
	}
}


