package com.mangofactory.parsley.tag
{
	import com.mangofactory.parsley.DynamicDelegateFactory;
	
	import org.spicefactory.parsley.core.registry.ObjectInstantiator;

	public interface DynamicServiceContext
	{
		function getInstantiator():ObjectInstantiator;
		function getDynamicDelegateFactory():DynamicDelegateFactory;
	}
}