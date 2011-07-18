package com.mangofactory.parsley.config
{
	import com.mangofactory.parsley.DynamicDelegateFactory;
	import com.mangofactory.parsley.tag.DynamicServiceContext;
	
	import org.spicefactory.parsley.core.registry.ObjectInstantiator;
	
	public class DefaultDynamicServiceContext implements DynamicServiceContext
	{
		private static var instance:DefaultDynamicServiceContext;
		
		public static function getInstance():DefaultDynamicServiceContext
		{
			if (!instance)
			{
				instance = new DefaultDynamicServiceContext();
			}
			return instance;
		}
		
		private var instantiator:DefaultInstantiator;
		public function DefaultDynamicServiceContext()
		{
			instantiator = new DefaultInstantiator();
		}
		
		public function getInstantiator():ObjectInstantiator
		{
			return instantiator;
		}

		public function getDynamicDelegateFactory():DynamicDelegateFactory
		{
			return instantiator;
		}
	}
}