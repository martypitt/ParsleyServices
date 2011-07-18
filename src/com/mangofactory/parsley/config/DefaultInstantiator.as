package com.mangofactory.parsley.config
{
	import com.mangofactory.parsley.DynamicDelegateFactory;
	import com.mangofactory.parsley.IRemoteObjectBuilder;
	
	import org.as3commons.bytecode.proxy.IProxyFactory;
	import org.spicefactory.parsley.core.lifecycle.ManagedObject;
	import org.spicefactory.parsley.core.registry.ObjectInstantiator;
	
	internal class DefaultInstantiator extends DynamicDelegateFactory implements ObjectInstantiator
	{
		public function DefaultInstantiator(remoteObjectBuilder:IRemoteObjectBuilder=null,proxyFactory:IProxyFactory=null)
		{
			super(remoteObjectBuilder,proxyFactory)
		}
		
		public function instantiate(target:ManagedObject):Object
		{
			var serviceClass:Class = target.definition.type.getClass();
			var delegate:* = getDelegate(serviceClass);
			return delegate;
		}
	}
}