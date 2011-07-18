package com.mangofactory.parsley.tag
{
	import com.mangofactory.parsley.DynamicDelegateFactory;
	import com.mangofactory.parsley.DynamicServiceDefinition;
	import com.mangofactory.parsley.config.DefaultDynamicServiceContext;
	
	import org.spicefactory.parsley.config.Configuration;
	import org.spicefactory.parsley.config.RootConfigurationElement;
	import org.spicefactory.parsley.core.registry.ObjectInstantiator;
	import org.spicefactory.parsley.dsl.ObjectDefinitionBuilder;
	
	public class DynamicService extends DynamicServiceDefinition implements RootConfigurationElement
	{
		private var servicesContext:DynamicServiceContext;
		public function DynamicService(servicesContext:DynamicServiceContext=null)
		{
			super();
			this.servicesContext = servicesContext ? servicesContext : DefaultDynamicServiceContext.getInstance();
		}
		
		public function process(config:Configuration):void
		{
			registerDelegate(config);
			// TODO: Async init tag
			// These objects have an async depencney in that the bytecode must be loaded
			// before they can be used the first time.
			// TODO: Move byte-code creation to on-demand
		}
		
		private function registerDelegate(config:Configuration):void
		{
			var builder:ObjectDefinitionBuilder = config.builders.forClass(type);
			builder.lifecycle().instantiator(instantiator);
			builder.asSingleton().lazy(true).register();	
			factory.prepareDelegate(this);
		}
		
		protected function get instantiator():ObjectInstantiator
		{
			return servicesContext.getInstantiator();
		}
		protected function get factory():DynamicDelegateFactory
		{
			return servicesContext.getDynamicDelegateFactory();
		}
	}
}