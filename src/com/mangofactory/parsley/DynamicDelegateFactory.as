

package com.mangofactory.parsley
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.utils.Dictionary;
	
	import mx.core.FlexGlobals;
	
	import org.as3commons.bytecode.proxy.IClassProxyInfo;
	import org.as3commons.bytecode.proxy.IProxyFactory;
	import org.as3commons.bytecode.proxy.impl.ProxyFactory;
	import org.as3commons.bytecode.reflect.ByteCodeType;
	
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	public class DynamicDelegateFactory extends EventDispatcher
	{
		private var remoteObjectBuilder:IRemoteObjectBuilder;
		private var delegatesToBuild:Dictionary = new Dictionary(); // Hash of key: Class, value: DynamicService
		private var proxyFactory:IProxyFactory;
		
		private static var _initialized:Boolean;
		public static function get initialized():Boolean
		{
			return _initialized;
		}
		public static function initialize():void
		{
			ByteCodeType.fromLoader(FlexGlobals.topLevelApplication.loaderInfo);
		}
		public function DynamicDelegateFactory(remoteObjectBuilder:IRemoteObjectBuilder=null,proxyFactory:IProxyFactory=null)
		{
			this.remoteObjectBuilder = remoteObjectBuilder || new DefaultRemoteObjectBuilder();
			this.proxyFactory = proxyFactory || new ProxyFactory();
		}
		
		/**
		 * Adds a DynamicService to the queue to be built when build() is called
		 * */
		public function prepareDelegate(service:DynamicService):void
		{
			delegatesToBuild[service.type] = service;
		}
		
		/**
		 * Starts the building of the dynamic proxies.
		 * This occurs Asyncronously, and dispatches either an Event.COMPLETE when complete
		 * or an IOErrorEvent.IO_ERROR when things go wrong
		 * */
		public function build():void
		{
			for each (var service:DynamicService in delegatesToBuild)
			{
				var proxyInfo:IClassProxyInfo = proxyFactory.defineProxy(service.type);
				proxyInfo.interceptorFactory = new ServiceMethodInterceptor(service,remoteObjectBuilder);
			}
			
			proxyFactory.generateProxyClasses();
			
			proxyFactory.addEventListener(Event.COMPLETE,onProxyGenerationComplete);
			proxyFactory.addEventListener(IOErrorEvent.IO_ERROR,onProxyGenerationFailed);
			proxyFactory.loadProxyClasses();
		}
		public function getRegisteredServices():Array
		{
			var services:Array = [];
			for (var service:* in delegatesToBuild)
			{
				services.push(service);	
			}
			return services;
		}
		protected function onProxyGenerationFailed(event:IOErrorEvent):void
		{
			dispatchEvent(event);
		}

		protected function onProxyGenerationComplete(event:Event):void
		{
			dispatchEvent(event);
		}
		
		public function getDelegate(delegateType:Class):*
		{
			return proxyFactory.createProxy(delegateType);
		}
	}
}
import com.mangofactory.parsley.DynamicService;
import com.mangofactory.parsley.IRemoteObjectBuilder;

import mx.rpc.AbstractService;
import mx.rpc.remoting.RemoteObject;

import org.as3commons.bytecode.proxy.IProxyFactory;

class DefaultRemoteObjectBuilder implements IRemoteObjectBuilder
{
	public function buildService(serviceDefinition:DynamicService):AbstractService
	{
		var remoteObject:RemoteObject = new RemoteObject();
		remoteObject.channelSet = serviceDefinition.channelSet;
		remoteObject.destination = serviceDefinition.destination;
		remoteObject.endpoint = serviceDefinition.endpoint;
		return remoteObject;
	}
}
