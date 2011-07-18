package com.mangofactory.parsley
{
	import mx.rpc.AbstractService;

	public interface IRemoteObjectBuilder
	{
		function buildService(service:DynamicService):AbstractService;
	}
}