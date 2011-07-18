package com.mangofactory.parsley
{
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	import mx.rpc.AsyncToken;
	import mx.rpc.remoting.RemoteObject;
	
	import org.as3commons.bytecode.reflect.ByteCodeType;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.async.Async;
	import org.mockito.integrations.flexunit4.MockitoRule;
	
	public class DynamicDelegateFactoryTests
	{
		private var factory:DynamicDelegateFactory;
		
		[Rule]
		public var mockitoRule:MockitoRule = new MockitoRule();
		[Mock]
		public var remoteObject:RemoteObject;
		
		[BeforeClass]
		public static function setup():void
		{
			ByteCodeType.fromLoader(FlexGlobals.topLevelApplication.loaderInfo);
		}
		
		[Before]
		public function setup():void
		{
			var serviceFactory:MockRemoteObjectBuilder = new MockRemoteObjectBuilder(this.remoteObject);
			factory = new DynamicDelegateFactory(serviceFactory);
		}
		[Test(async)]
		public function preparesServiceForInterface():void
		{
			factory.prepareDelegate(DynamicService.createForTypeAndDestination(IAccountService,"testDestination"));
			var handler:Function = Async.asyncHandler(this,onServicePrepared,2000)
			factory.addEventListener(Event.COMPLETE,handler);
			factory.build();
		}
		private function onServicePrepared(event:Event,...ignored):void
		{
			var service:IAccountService = factory.getDelegate(IAccountService);
			assertNotNull(service);
			var token:AsyncToken = service.validatePassword("password");
			assertNotNull(token);
		}
		
	}
}
import com.mangofactory.parsley.DynamicService;
import com.mangofactory.parsley.IRemoteObjectBuilder;

import mx.rpc.AbstractService;
import mx.rpc.remoting.RemoteObject;

class MockRemoteObjectBuilder implements IRemoteObjectBuilder
{
	private var remoteObject:RemoteObject;
	public function MockRemoteObjectBuilder(remoteObject:RemoteObject)
	{
		this.remoteObject = remoteObject;
	}
	public function buildService(service:DynamicService):AbstractService
	{
		return remoteObject;
	}
}