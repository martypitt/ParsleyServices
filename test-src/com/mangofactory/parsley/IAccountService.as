package com.mangofactory.parsley
{
	import mx.rpc.AsyncToken;

	public interface IAccountService
	{
		function validatePassword(password:String):AsyncToken;
	}
}