package com.mangofactory.parsley
{
	import org.as3commons.bytecode.interception.IMethodInvocationInterceptorFactory;
	
	public class ServiceMethodInterceptor implements IMethodInvocationInterceptorFactory
	{
		private var service:DynamicServiceDefinition;
		private var serviceFactory:IRemoteObjectBuilder;
		public function ServiceMethodInterceptor(service:DynamicServiceDefinition,serviceFactory:IRemoteObjectBuilder)
		{
			this.service = service;
			this.serviceFactory = serviceFactory;
		}
		
		public function newInstance():*
		{
			return new MethodInterceptor(service,serviceFactory);
		}
	}
}
import com.mangofactory.parsley.DynamicServiceDefinition;
import com.mangofactory.parsley.IRemoteObjectBuilder;

import mx.rpc.AbstractOperation;
import mx.rpc.AbstractService;
import mx.rpc.AsyncToken;

import org.as3commons.bytecode.interception.IMethodInvocationInterceptor;
import org.as3commons.bytecode.interception.impl.InvocationKind;

class MethodInterceptor implements IMethodInvocationInterceptor
{
	private var service:DynamicServiceDefinition;
	private var serviceFactory:IRemoteObjectBuilder;
	
	private var remoteObject:AbstractService;
	
	public function MethodInterceptor(service:DynamicServiceDefinition,serviceFactory:IRemoteObjectBuilder)
	{
		this.service = service;
		this.serviceFactory = serviceFactory;
	}
	public function intercept(targetInstance:Object, kind:InvocationKind, member:QName, arguments:Array=null, method:Function=null):*
	{
		if (kind == InvocationKind.METHOD)
		{
			assertService();
			var operation:AbstractOperation = remoteObject.getOperation(member.localName);
			var token:AsyncToken = operation.send.apply(null,arguments);
			return token;
		}
	}
	
	private function assertService():void
	{
		if (!remoteObject)
		{
			remoteObject = serviceFactory.buildService(service);
		}
	}
}