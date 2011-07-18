package com.mangofactory.parsley
{
	import avmplus.getQualifiedClassName;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import mx.core.FlexGlobals;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	import org.as3commons.bytecode.emit.IClassBuilder;
	import org.as3commons.bytecode.emit.IMethodBuilder;
	import org.as3commons.bytecode.proxy.IClassProxyInfo;
	import org.as3commons.bytecode.proxy.IProxyFactory;
	import org.as3commons.bytecode.proxy.event.ProxyFactoryBuildEvent;
	import org.as3commons.bytecode.proxy.impl.ProxyFactory;
	import org.as3commons.bytecode.reflect.ByteCodeType;
	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.Parameter;
	import org.as3commons.reflect.Type;
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;
	import org.hamcrest.object.equalTo;

	public class SampleTests
	{
		[BeforeClass]
		public static function setup():void
		{
			ByteCodeType.fromLoader(FlexGlobals.topLevelApplication.loaderInfo);
		}
		[Test(async)]
		public function tryBuildingService():void
		{
			var proxyfactory:IProxyFactory = new ProxyFactory();
			var proxyInfo:IClassProxyInfo = proxyfactory.defineProxy(DynamicDelegate);
			var handler:Function = Async.asyncHandler(this,handler,20000,proxyfactory);
			proxyfactory.addEventListener(ProxyFactoryBuildEvent.AFTER_PROXY_BUILD,onAfterProxyBuild);
			proxyfactory.generateProxyClasses();
			proxyfactory.generateProxyClasses();
			proxyfactory.addEventListener(Event.COMPLETE,handler);
			proxyfactory.addEventListener(IOErrorEvent.VERIFY_ERROR,handler);
			proxyfactory.loadProxyClasses();
		}
		
		private function onAfterProxyBuild(event:ProxyFactoryBuildEvent):void
		{
			var builder:IClassBuilder = event.classBuilder;
			builder.implementInterface(getQualifiedClassName(IAccountService));
			var type:Type = Type.forClass(IAccountService);
			for each (var method:Method in type.methods)
			{
				var methodBuilder:IMethodBuilder = builder.defineMethod(method.name);
				for each (var param:Parameter in method.parameters)
				{
					methodBuilder.defineArgument(param.type.fullName,param.isOptional);
				}
				methodBuilder.returnType = method.returnType.fullName;
			}
		}
		private function handler(event:Event,proxyFactory:ProxyFactory):void
		{
			assertThat(event.type,equalTo(Event.COMPLETE));
			var delegate:DynamicDelegate = proxyFactory.createProxy(DynamicDelegate);
			assertTrue(delegate is IAccountService);
		}
	}
}
import mx.rpc.remoting.mxml.RemoteObject;

import org.as3commons.bytecode.interception.IMethodInvocationInterceptorFactory;

class ServiceFactory implements IMethodInvocationInterceptorFactory
{
	public function newInstance():*
	{
		return new RemoteObject();
	}
}