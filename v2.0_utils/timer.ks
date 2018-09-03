// timer.ks
// Timer object

Include("controller").

function Timer_New
{
	parameter interval.
	parameter callbackCtrl.
	parameter callbackFunc.
	parameter autoReset is true.
	
	local this is NewController(Timer_setup@, Timer_loop@, Timer_Err@).
	
	// Add arguments to the controller
	// this:add("x", x).
	
	this:add("interval", interval).
	this:add("callbackCtrl", callbackCtrl).
	this:add("callbackFunc", callbackFunc).
	this:add("autoReset", autoReset).
	
	// Add optional user functions to the controller
	// this:add("foo" foo@).
	
	// Add state variables to the controller
	// this:add("bar", 0).
	this:add("lastElapsed", time:seconds).
	
	return this.
}

function Timer_setup
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	// Do your setup here
	set this["lastElapsed"] to time:seconds.
	set this["enabled"] to true.
	
	return 0.
}

function Timer_loop
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	if time:seconds - this["lastElapsed"] >= this["interval"]
	{
		this["callbackCtrl"]["call"](this["callbackCtrl"], this["callbackFunc"]).
		if this["autoReset"] = false
		{
			set this["enabled"] to false.
		}
		else
		{
			this["setup"](this).
		}
	}
	
	return 0.
}

function Timer_Err
{
	parameter this.
	parameter errorCode.
	parameter caller.
	
	// Do your error handling here
	
	return 0.
}
