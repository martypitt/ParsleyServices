package com.mangofactory.parsley.tag
{
	import com.mangofactory.parsley.DynamicService;
	
	import org.spicefactory.parsley.config.Configuration;
	import org.spicefactory.parsley.config.RootConfigurationElement;
	import org.spicefactory.parsley.dsl.ObjectDefinitionBuilder;
	
	public class DynamicServiceTag extends DynamicService implements RootConfigurationElement
	{
		private var servicesContext:DynamicServiceContext;
		public function DynamicServiceTag(servicesContext:DynamicServiceContext=null)
		{
			super();
			this.servicesContext = servicesContext;
		}
		
		public function process(config:Configuration):void
		{
			var builder:ObjectDefinitionBuilder = config.builders.forClass(type);
			builder.lifecycle().instantiator(servicesContext.getInstantiator());
			builder.asSingleton().register();
			// TODO: Async init tag
			// These objects have an async depencney in that the bytecode must be loaded
			// before they can be used the first time.
			// TODO: Move byte-code creation to on-demand
		}
	}
}